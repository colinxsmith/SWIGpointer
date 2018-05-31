# ------------------------------------------------------------
# SWIG Examples Makefile
#
# This file is used by the examples to build modules.  Assuming
# you ran configure, this file will probably work.  However,
# it's not perfect so you might need to do some hand tweaking.
#
# Other notes:
#
# 1.   Take a look at the prefixes below.   Since SWIG works with
#      multiple target languages, you may need to find out where
#      certain packages have been installed.   Set the prefixes
#      accordingly.
#
# 2.   To use this makefile, set required variables, eg SRCS, INTERFACE,
#      INTERFACEDIR, INCLUDES, LIBS, TARGET, and do a
#           $(MAKE) -f Makefile.template.in SRCDIR='$(SRCDIR)' SRCS='$(SRCS)' \
#           INCLUDES='$(INCLUDES) LIBS='$(LIBS)' INTERFACE='$(INTERFACE)' \
#           INTERFACEDIR='$(INTERFACEDIR)' TARGET='$(TARGET)' method
#
#      'method' describes what is being built.
#---------------------------------------------------------------

# Regenerate Makefile if Makefile.in or config.status have changed.
Makefile: ./Makefile.in ../config.status
	cd .. && $(SHELL) ./config.status Examples/Makefile

# SRCDIR is the relative path to the current source directory
# - For in-source-tree builds, SRCDIR with be either '' or './', but
#   '../' for the test suites that build in a subdir (e.g. C#, Java)
# - For out-of-source-tree builds, SRCDIR will be a relative
#   path ending with a '/'

# SRCDIR_SRCS, etc. are $(SRCS), etc. with $(SRCDIR) prepended
SRCDIR_SRCS    = $(addprefix $(SRCDIR),$(SRCS))
SRCDIR_CSRCS   = $(addprefix $(SRCDIR),$(CSRCS))
SRCDIR_CXXSRCS = $(addprefix $(SRCDIR),$(CXXSRCS))

ifeq (,$(SRCDIR))
SRCDIR_INCLUDE = -I.
else
SRCDIR_INCLUDE = -I. -I$(SRCDIR)
endif

TARGET     =
CC         = gcc
CXX        = g++
CPPFLAGS   = $(SRCDIR_INCLUDE)
CFLAGS     = 
CXXFLAGS   = -I/include/boost-0 
LDFLAGS    =
prefix     = /home/colin/SWIGcvs/SWIG
exec_prefix= ${prefix}
SRCS       =
INCLUDES   =
LIBS       =
INTERFACE  =
INTERFACEDIR  =
INTERFACEPATH = $(SRCDIR)$(INTERFACEDIR)$(INTERFACE)
SWIGOPT    =

# SWIG_LIB_DIR and SWIGEXE must be explicitly set by Makefiles using this Makefile
SWIG_LIB_DIR = /home/colin/SWIGcvs/SWIG/Lib
SWIGEXE    = swig
SWIG_LIB_SET = env SWIG_LIB=$(SWIG_LIB_DIR)
SWIGTOOL   =
SWIG       = $(SWIG_LIB_SET) $(SWIGTOOL) $(SWIGEXE)

LIBM       = -lieee -lm
LIBC       = 
LIBCRYPT   = -lcrypt
SYSLIBS    = $(LIBM) $(LIBC) $(LIBCRYPT)
LIBPREFIX  =

# RUNTOOL is for use with runtime tools, eg set it to valgrind
RUNTOOL    =
# COMPILETOOL is a way to run the compiler under another tool, or more commonly just to stop the compiler executing
COMPILETOOL=
# RUNPIPE is for piping output of running interpreter/compiled code somewhere, eg RUNPIPE=\>/dev/null
RUNPIPE=

RUNME = runme

IWRAP      = $(INTERFACE:.i=_wrap.i)
ISRCS      = $(IWRAP:.i=.c)
ICXXSRCS   = $(IWRAP:.i=.cxx)
IOBJS      = $(IWRAP:.i=.o)

##################################################################
# Some options for silent output
##################################################################

ifneq (,$(findstring s, $(filter-out --%, $(MAKEFLAGS))))
  # make -s detected
  SILENT=1
else
  SILENT=
endif

ifneq (,$(SILENT))
  SILENT_OPTION = -s
  SILENT_PIPE = >/dev/null
  ANT_QUIET = -q -logfile /dev/null
else
  SILENT_OPTION =
  SILENT_PIPE =
  ANT_QUIET =
endif

##################################################################
# Dynamic loading for C++
# If you are going to be building dynamic loadable modules in C++,
# you may need to edit this line appropriately.
#
# This line works for g++, but I'm not sure what it might be
# for other C++ compilers
##################################################################

CPP_DLLIBS = #-L/usr/local/lib/gcc-lib/sparc-sun-solaris2.5.1/2.7.2 \
	     -L/usr/local/lib -lg++ -lstdc++ -lgcc

# Solaris workshop 5.0
# CPP_DLLIBS = -L/opt/SUNWspro/lib -lCrun

# Symbols used for using shared libraries
SO=		.so
LDSHARED=	gcc -shared
CCSHARED=	-fpic
CXXSHARED=      gcc -shared

# This is used for building shared libraries with a number of C++
# compilers.   If it doesn't work,  comment it out.
CXXSHARED= g++ -shared 

OBJS      = $(SRCS:.c=.o) $(CXXSRCS:.cxx=.o)

distclean:
	rm -f Makefile
	rm -f d/example.mk
	rm -f xml/Makefile

##################################################################
# Very generic invocation of swig
##################################################################

swiginvoke:
	$(SWIG) $(SWIGOPT)


##################################################################
#####                       JAVASCRIPT                      ######
##################################################################

# Note: These targets are also from within Makefiles in the Example directories.
# There is a common makefile, 'Examples/javascript/js_example.mk' to simplify
# create a configuration for a new example.

ROOT_DIR = /home/colin/SWIGcvs/SWIG
JSINCLUDES =  -I"/usr/include"
JSDYNAMICLINKING =  -L/usr/lib/ -lv8
NODEJS = ../../node_modules/.bin/node
NODEGYP = ../../node_modules/.bin/node-gyp

# ----------------------------------------------------------------
# Creating and building Javascript wrappers
# ----------------------------------------------------------------

javascript_wrapper:
	$(SWIG) -javascript $(SWIGOPT) -o $(INTERFACEDIR)$(TARGET)_wrap.c $(INTERFACEPATH)

javascript_wrapper_cpp: $(SRCDIR_SRCS)
	$(SWIG) -javascript -c++ $(SWIGOPT) -o $(INTERFACEDIR)$(TARGET)_wrap.cxx $(INTERFACEPATH)

javascript_build: $(SRCDIR_SRCS)
	$(CC) -c $(CCSHARED) $(CPPFLAGS) $(CFLAGS) $(ISRCS) $(SRCDIR_SRCS) $(INCLUDES) $(JSINCLUDES)
	$(LDSHARED) $(CFLAGS) $(LDFLAGS) $(OBJS) $(IOBJS) $(JSDYNAMICLINKING) $(LIBS) -o $(LIBPREFIX)$(TARGET)$(SO)

javascript_build_cpp: $(SRCDIR_SRCS)
ifeq (node,$(JSENGINE))
	sed -e 's|$$srcdir|./$(SRCDIR)|g;s/"/'\''/g' $(SRCDIR)binding.gyp.in > binding.gyp
	MAKEFLAGS= $(NODEGYP) --loglevel=silent configure build 1>>/dev/null
else
	$(CXX) -c $(CCSHARED) $(CPPFLAGS) $(CXXFLAGS) $(ICXXSRCS) $(SRCDIR_SRCS) $(SRCDIR_CXXSRCS) $(INCLUDES) $(JSINCLUDES)
	$(CXXSHARED) $(CXXFLAGS) $(LDFLAGS) $(OBJS) $(IOBJS) $(JSDYNAMICLINKING) $(LIBS) $(CPP_DLLIBS) -o $(LIBPREFIX)$(TARGET)$(SO)

endif

# These targets are used by the test-suite:

javascript: $(SRCDIR_SRCS) javascript_custom_interpreter
	$(SWIG) -javascript $(SWIGOPT) $(INTERFACEPATH)
ifeq (jsc, $(ENGINE))
	$(CC) -c $(CCSHARED) $(CPPFLAGS) $(CFLAGS) $(ISRCS) $(SRCDIR_SRCS) $(INCLUDES) $(JSINCLUDES)
	$(LDSHARED) $(CFLAGS) $(LDFLAGS) $(OBJS) $(IOBJS) $(JSDYNAMICLINKING) $(LIBS) -o $(LIBPREFIX)$(TARGET)$(SO)
else # (v8 | node) # v8 and node must be compiled as c++
	$(CXX) -c $(CCSHARED) $(CPPFLAGS) $(CXXFLAGS) $(ISRCS) $(SRCDIR_SRCS) $(SRCDIR_CXXSRCS) $(INCLUDES) $(JSINCLUDES)
	$(CXXSHARED) $(CXXFLAGS) $(LDFLAGS) $(OBJS) $(IOBJS) $(JSDYNAMICLINKING) $(LIBS) $(CPP_DLLIBS) -o $(LIBPREFIX)$(TARGET)$(SO)
endif

javascript_cpp: $(SRCDIR_SRCS) javascript_custom_interpreter
	$(SWIG) -javascript -c++ $(SWIGOPT) $(INTERFACEPATH)
	$(CXX) -c $(CCSHARED) $(CPPFLAGS) $(CXXFLAGS) $(ICXXSRCS) $(SRCDIR_SRCS) $(SRCDIR_CXXSRCS) $(INCLUDES) $(JSINCLUDES)
	$(CXXSHARED) $(CXXFLAGS) $(LDFLAGS) $(OBJS) $(IOBJS) $(JSDYNAMICLINKING) $(LIBS) $(CPP_DLLIBS) -o $(LIBPREFIX)$(TARGET)$(SO)

# -----------------------------------------------------------------
# Running a Javascript example
# -----------------------------------------------------------------

javascript_custom_interpreter:
	(cd $(ROOT_DIR)/Tools/javascript && $(MAKE) JSENGINE='$(JSENGINE)')

ifeq (node,$(JSENGINE))
javascript_run:
	env NODE_PATH=$$PWD:$(SRCDIR) $(RUNTOOL) $(NODEJS) $(SRCDIR)$(RUNME).js $(RUNPIPE)
else
javascript_run: javascript_custom_interpreter
	$(RUNTOOL) $(ROOT_DIR)/Tools/javascript/javascript -$(JSENGINE) -L $(TARGET) $(SRCDIR)$(RUNME).js $(RUNPIPE)
endif

# -----------------------------------------------------------------
# Version display
# -----------------------------------------------------------------

javascript_version:
ifeq (, $(ENGINE))
	@if [ "$(NODEJS)" != "" ]; then \
	  echo "Node.js: `($(NODEJS) --version)`"; \
	  echo "node-gyp: `($(NODEGYP) --version)`"; \
	else \
	  echo "Version depends on the interpreter"; \
	fi
endif
ifeq (node, $(ENGINE))
	echo "Node.js: `($(NODEJS) --version)`"
	echo "node-gyp: `($(NODEGYP) --version)`"
endif
ifeq (jsc, $(ENGINE))
	@if [ "" != "" ]; then \
	  echo ""; \
	else \
	  echo "Unknown JavascriptCore version."; \
	fi
endif
ifeq (v8, $(ENGINE))
	echo "Unknown v8 version."
endif

# -----------------------------------------------------------------
# Cleaning the Javascript examples
# -----------------------------------------------------------------

javascript_clean:
	rm -rf build
	rm -f *_wrap* $(RUNME)
	rm -f core 
	rm -f *.o *.so
	rm -f binding.gyp example-gypcopy.cxx
	cd $(ROOT_DIR)/Tools/javascript && $(MAKE) -s clean

