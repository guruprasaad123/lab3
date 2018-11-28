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
    double coef3[10]={0};
    
    // Instanciate 3 objects
    
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
    
    // Instanciate p3 :
    cout << "Input order of p3 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p3 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef3[i] ;
    }
    Poly p3(coef3,n);
    
    // test output and constructor correct assignement of values
    cout << "Testing constructor and output " << endl ;
    cout<<"p1 : ";
    p1.print();
    cout<<"p2 : ";
    p2.print();
    cout<<"p3 : ";
    p3.print();

    // test addition operator. Use of default copy constructor to avoid use of forbiden assignement operator with 
    // already existing instance of Poly
    cout << "Testing addition " << endl ;
    Poly padd(p2+p3);
    cout<<"p2+p3 : ";
    padd.print();
    Poly padd2(p3+p2);
    cout<<"p3+p2 : ";
    padd2.print();

    // test substraction operator.
    cout << "Testing substraction " << endl ; 
    cout<<"p2-p3 : ";
    Poly pneg(p2-p3);
    pneg.print();
    cout<<"p3-p2 : ";
    Poly pneg2(p3-p2);
    pneg2.print();
    // check that operators (here -) are returning correct instance (i.e coeficient of higher order is not null)
    cout<<"p3-p3=0 : ";
    // Illustration here of the implicite use of the copy constructor when left hand side of 
    // the assignement operator is not already created. Otherwise this would have give a runtime error (throw)
    // as = operator is throwing exception.
    Poly pneg3=p3-p3;
    pneg3.print();

    // test multiplication operator. 
    cout << "Testing multiplication " << endl ;
    cout<<"p2*p3 : ";
    Poly pprod=(p2*p3);
    pprod.print();
    cout<<"p3*p2 : ";
    Poly pprod2=(p3*p2);
    pprod2.print();

    // test "complicate"  operation
    cout << "Testing complicate operation " << endl ;
    cout<<"p3-p1*p2 : ";
    Poly pcplx(p3-p1*p2);
    pcplx.print();
    cout<<"(p3-p1*p2)*p1 : ";
    Poly pcplx2((p3-p1*p2)*p1);
    pcplx2.print();

    // test () operator
    double x;
    cout << "Testing () operator " << endl ;
    cout<<"First try, input a value for x1 : " << endl ;
    cin >> x ;
    cout << "p2(x1) : "<<p2(x) <<endl ;
    cout << "p3(x1) : "<<p3(x) <<endl ;

    cout<<"Second try, input a value for x2 : " << endl ;
    cin >> x ;
    cout << "p2(x2) : "<<p2(x) <<endl ;
    cout << "p3(x2) : "<<p3(x) <<endl ;

    // test exception for problematic cases
    cout << "Testing exceptions from problematic cases " << endl ; 
    try
    {
        Poly pb(coef3,n+1);
    }
    catch (int e)
    {
         cout << "Error1 : catching exception for null order coef "<<endl;
    }
    
    try
    {    	
        pcplx=pcplx2;
    }
    catch (int e)
    {
         cout << "Error2 : catching exception for = usage"<<endl;
    }

    return 0;
}

