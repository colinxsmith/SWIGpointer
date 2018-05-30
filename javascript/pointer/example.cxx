/* File : example.c */

void add(int *x, int *y, int *result) {
  *result = *x + *y;
}
void sub(int *x, int *y, int *result) {
  *result = *x - *y;
}

void subtract(double *x, double *y, double *result) {
  *result = *x - *y;
}

void divide(double *n, double *d, double *r) {
   *r = *n/ *d;
}

double opt(int n,double*a,double*b) {
  double back = 0;
  while(n--) {
    back += *a++ * *b;
    *b *= 10;
    b++;
  }
  return back;
}