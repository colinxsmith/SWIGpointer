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
//     printf("Length %d\n",arr->Length());
     $1 = new double[arr->Length()];
     for(size_t i = 0;i < arr->Length();++i) {
     $1[i] = arr->Get(i)->NumberValue();
//     printf("a[%d] %f\n",i,$1[i]);

     }
    }

}
%typemap(argout) double*
{
    if($1 && $input->IsArray()) {
/*     //   v8::Isolate* isolate = $input->GetIsolate();
     v8::Handle<v8::Array> arr= v8::Handle<v8::Array>::Cast($input);
     for(size_t i = 0;i < arr->Length();++i) {
     arr->Set(i,v8::Number::New(isolate,$1[i]));
//     printf("a[%d] %f\n",i,$1[i]);


     }*/
        
    }
}
%typemap(freearg) double*
{
   if($1) delete[] $1;
}

extern double opt(int n,double*a,double*b);




