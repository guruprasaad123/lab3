#ifndef POLY_H
#define POLY_H
class Poly
{
private:
double *values;
int size;

public:
Poly();
Poly(const Poly & ref);
Poly(double values[],int n);
int getSize(void) const ;

Poly operator+(const Poly & opp);
double operator()(const int &i) const;
Poly operator-(const Poly & opp);
Poly operator*(const Poly & opp);
void print(void) const;

};



#endif
