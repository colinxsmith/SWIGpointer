double opt(int n,double*a,double*b) {
  double back = 0;
  while(n--) {
    back += *a++ * *b;
    *b *= 10;
    b++;
  }
  return back;
}