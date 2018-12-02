#include <iostream>
#include "Poly.h"
using namespace std;

int main()
{
    // Some coefficients to instanciate Poly object
    // Warning : in this program, we suppose that the maximum order of a polynomial is 9
    // (maximum number of coefficient : 10)
    double coef1[3]={3,3,2};
 
    Poly p1(coef1,3);
    Poly p2(coef1,4);
    p2=p2+p1;
    cout<<"Poly : 1 => ";
    p1.print();
    p2.print();

}