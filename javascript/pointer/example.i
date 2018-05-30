/* File : example.i */
%module example

%{
extern double opt(int n,double*a,double*b);
%}

%typemap(in) double*
{
    $1 = 0;
    if($input->IsArray())
    {
     v8::Handle<v8::Array> arr= v8::Handle<v8::Array>::Cast($input);
     $1 = new double[arr->Length()];
     for(size_t i = 0;i < arr->Length();++i) {
        $1[i] = arr->Get(i)->NumberValue();
     }
    }

}
%typemap(argout) double*
{
    if($1 && $input->IsArray()) {
     v8::Handle<v8::Array> arr= v8::Handle<v8::Array>::Cast($input);
     for(size_t i = 0;i < arr->Length();++i) {
        arr->Set(i,SWIGV8_NUMBER_NEW($1[i]));
     }
    }
}
%typemap(freearg) double*
{
   if($1) delete[] $1;
}

extern double opt(int n,double*a,double*b);




