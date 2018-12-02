#ifndef POLY_H
#define POLY_H
class Poly
{
private:
double *values;
int size;

public:
Poly();
Poly(double values[],int n);
int getSize(void) const ;

Poly& operator+(const Poly & opp);
Poly& operator-(const Poly & opp);
Poly& operator*(const Poly & opp);
void print(void) const;

};



#endif
