/* File : example.i */
%module example

%{
extern void add(int *, int *, int *);
extern void sub(int *, int *, int *);
extern void subtract(double *, double *, double *);
extern void divide(double *, double *, double *);
extern double opt(int n,double*a,double*b);
%}

/* This example illustrates a couple of different techniques
   for manipulating C pointers */

/* First we'll use the pointer library */
extern void add(int *x, int *y, int *result);
extern void sub(int *x, int *y, int *result);
%include cpointer.i
%pointer_functions(int, intp);

/* Next we'll use some typemaps */

%include typemaps.i
extern void subtract(double *INPUT, double *INPUT, double *OUTPUT);

/* Next we'll use typemaps and the %apply directive */

%apply double *OUTPUT { double *r };
%apply double *INPUT { double *a };
%apply double *INPUT { double *b };
extern void divide(double *a, double *b, double *r);

%inline %{
    double aaa[4];
    double bbb[4];
%}
%include <arrays_javascript.i>
extern double opt(int n,double*a,double*b);




