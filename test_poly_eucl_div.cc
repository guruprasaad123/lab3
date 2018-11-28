#include <iostream>
#include "Poly.h"
using namespace std;

int main()
{
    // Some coefficients to instanciate Poly object
    // Warning : in this program, we suppose that the maximum order of a polynomial is 9
    // (maximum number of coefficient : 10)
    double coef1[10]={0};
    double coef2[10]={0};
    
    // Instanciate 2 objects
    
    int n ; // Polynomial order
    
    // Instanciate p1 :
    cout << "Input order of p1 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p1 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef1[i] ;
    }
    Poly p1(coef1,n);
    
    // Instanciate p2 :
    cout << "Input order of p2 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p2 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef2[i] ;
    }
    Poly p2(coef2,n);

    // test division operator  : QUOTIENT part.
    cout << "Testing euclidian divison, quotient part " << endl ;
    Poly pprod=(p1*p2);
    Poly pdivQ(pprod.euclidienDivisionQ(p1));
    cout<<"Q=(p2*p1)/p1=p2 : ";
    pdivQ.print();
    Poly pdivQ2(p2.euclidienDivisionQ(p1));
    cout<<"Q=p2/p1 : ";
    pdivQ2.print();

    // test division operator  : RESIDUAL part.
    cout << "Testing euclidian divison, residual part " << endl ;
    Poly pdivR(pprod.euclidienDivisionR(p1,pdivQ));
    cout<<"R=(p2*p1)-Q((p2*p1)/p1)*p1=0 : ";
    pdivR.print();
    Poly pdivRd(pprod.euclidienDivisionR(p1));
    cout<<"Rdirect=(p2*p1)-Q((p2*p1)/p1)*p1=0 : ";
    pdivRd.print();
    Poly pdivR2(p2.euclidienDivisionR(p1,pdivQ2));
    cout<<"R=p2-Q(p2/p1)*p1 : ";
    pdivR2.print();
    Poly pdivR2d(p2.euclidienDivisionR(p1));
    cout<<"Rdirect=p2-Q(p2/p1)*p1 : ";
    pdivR2d.print();

    return 0;
}

