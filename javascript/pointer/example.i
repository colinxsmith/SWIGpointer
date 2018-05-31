%module example
%{
    extern double opt(int n,double*a,double*b);
    extern int iopt(int n,int*a,int*b);
    extern "C" char* Return_Message(int);
    extern "C" char* version(char*);
%}
%typemap(in) double*,int*
{
    $1 = 0;
    if($input->IsArray())
    {
        v8::Handle<v8::Array> arr= v8::Handle<v8::Array>::Cast($input);
        $1 = new $*1_ltype[arr->Length()];
        for(size_t i = 0;i < arr->Length();++i) {
            $1[i] = ($*1_ltype) arr->Get(i)->NumberValue();
        }
    }

}
%typemap(argout) double*
{
    if($1 && $input->IsArray()) {
        v8::Handle<v8::Array> arr= v8::Handle<v8::Array>::Cast($input);
        for(size_t i = 0;i < arr->Length();++i) {
            arr->Set(i,SWIG_From_double($1[i]));
        }
    }
}
%typemap(argout) int*
{
    if($1 && $input->IsArray()) {
        v8::Handle<v8::Array> arr= v8::Handle<v8::Array>::Cast($input);
        for(size_t i = 0;i < arr->Length();++i) {
            arr->Set(i,SWIG_From_int($1[i]));
        }
    }
}
%typemap(freearg) double*,char*,int*
{
   if($1) {delete[] $1;}
}
%typemap(in,numinputs=0) char*asetup
{
    $1=new char[500];
}
double opt(int n,double*a,double*b);
int iopt(int n,int*a,int*b);
char* Return_Message(int);
char* version(char*asetup);



