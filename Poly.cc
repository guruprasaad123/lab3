#include<iostream>
#include "Poly.h"
#include<cmath>

#define MAX_SIZE 10

using namespace std;


// helper or Utility Function to minize the possibility of error in case of zero polynomial
int OptimizeOrder(const Vector& vector)
{
     int order=vector.getSize()-1;
     while( order>0 && vector(order)==0) 
     {
          order--; 
     }    
     return order;  
}
// helper or Utility Function to initialie the vector with the value of {0}
Vector initWithZeros(const int & size)
{
    int i=0;
    Vector vector(size);
    for(;i<vector.getSize();i++)
    {
    vector(i) = 0.;    
    }
    return vector;
}
 /*Poly::Poly(const Poly & ref)
{
poly=ref;

}
Poly::~Poly()
{
poly(0);
}

*/


Poly::Poly(const double *val,const int &N):poly(N-1)         
{

    try{

     if(N<0)
     {
        cout<<"Sorry, not defined! Order of the polynomial has to be greater than or equal to zero!";
        cout<<endl;
        throw -1;
     }
     if(N!=0 && val[N]==0 ) 
     {
        cout<<"Invalid! The last coefficient of polynomials(order > 0) cannot be zero!";
        cout<<endl;
        throw -1;   
     }      
     for(int i=0;i<N;i++)
     {
         poly(i) = val[i];
     } 

    }
    catch(...)
    {
        throw -1;
    }
}


void Poly::print(void) const
{
    int size = poly.getSize();
    cout<<"poly(x)=";
    try{
    if( size > 0)
    {
    
    if( poly(0)!=0 )
    {
        cout<<poly(0);
    }

    int i=1;

    for(;i<size;i++)
    {
    string end=(i==size-1)?"":"+";
    if( poly(i)!=0 )
    {
    string end = (poly(i)>0)?"+":"";
    cout<<end;
    cout<<poly(i)<<"*x^"<<i;
    }

    }
    cout<<endl;
    }
    }
    catch(...)
    {
        throw -1;
    }
}


double Poly::operator()(const double &var) const
{
int i=0,size=poly.getSize();
double res=0;
try{
    for(;i<size;i++)
    {
        res+= (poly(i)*pow(var,i));
       // cout<<"pow > "<< (values[i]*pow(var,i))<<endl;
    }
}
catch(...)
{
    throw -1;
}
return res;
}

Poly Poly::operator+(const Poly & opp) const
{ 
    int max_size =( poly.getSize() > opp.poly.getSize() )? poly.getSize():opp.poly.getSize();
    int i=0;
    Vector newVector(max_size+1);
 
    try{
        newVector = ( poly.getSize()-1 == max_size ) ? ( poly+opp.poly ):( opp.poly+poly );

    }
    catch(...)
    {
        throw -1;
    }
    int optorder = OptimizeOrder(newVector);
    Poly newPoly(&newVector(0),optorder);
}

void Poly::operator=(const Poly&) const
{
     cout<<"Sorry, assignment(=) operator is not available for use with polynomials";
     cout<<endl;
     throw -1;
}


Poly Poly::operator-(const Poly & opp) const
{
     int max_size =( poly.getSize() > opp.poly.getSize() )? poly.getSize():opp.poly.getSize();
    int i=0;
    Vector newVector(max_size+1);
 
    try{
        newVector = ( poly.getSize()-1 == max_size ) ? ( poly-opp.poly ):( opp.poly-poly );

    }
    catch(...)
    {
        throw -1;
    }
    int optorder = OptimizeOrder(newVector);
    Poly newPoly(&newVector(0),optorder);
    return newPoly;
}



Poly Poly::operator*(const Poly & opp) const
{
    int order =( opp.poly.getSize()-1 ) + ( poly.getSize()-1);
    int i=0;
   // Vector ZeroVector(order+1);
    Vector tempVector(order+1);
    Vector ZeroVector=initWithZeros(order+1);
  
    try{
        for(;i<poly.getSize();i++)
        {
            tempVector*=0.;
            int j=0;
            for(;j<opp.poly.getSize();j++)
            {
                tempVector(i+j) = poly(i) * opp.poly(j);
            }
            ZeroVector+=tempVector;
        }
    }
    catch(...)
    {
        throw -1;
    }
    int optorder = OptimizeOrder(ZeroVector);
    Poly newPoly(&ZeroVector(0),optorder);
 return newPoly;
}


//Euclidean Divison of polynomials to find the quotient
Poly Poly::euclidienDivisionQ(const Poly& Divisor) const
{
     int n1=poly.getSize()-1; int n2=Divisor.poly.getSize()-1;
     if(n2==0 && Divisor.poly(n2)==0)  //Ensuring the divisor is not a zero polynomial ( p(x) = 0 )
     {
         cout<<"Invalid! Divisor cannot be a zero polynomial!"<<endl;
         throw -1; 
     }
     if(n2>n1)  //Ensuring the order of the divisor is not greater than that of the dividend
     {
         cout<<"Not defined!, please make sure the order of the divisor is not greater than the order of the dividend!"<<endl;
         throw -2;
     }
     Poly Num(*this); //Making a copy of the dividend to Num, to be able to modify Num without modifying the input dividend polynomial
     int i = (n1-n2);   //Order of the resulting quotient polynomial
     Vector vQ=initWithZeros(i+1);  //Vector of the Quotient polynomial with zeros initially
     Vector vR=initWithZeros(n1+1);     //Vector of the remainder polynomial with zeros initially
     Vector temp=initWithZeros(n1+1);  //Temporary vector for an intermediate operation
     while(n1>=n2)   //Repeat until the order of the numerator is >= to that of the denomerator
     {
         vQ(i)=Num.poly(n1)/Divisor.poly(n2);  //Divison of the highest degree coefficients of the numerator and the divisor
         for(int j=n2; j>=0; j--)
             temp(i+j)=vQ(i)*Divisor.poly(j);  //Multiplying each term of the divisor with the coefficient of the quotient corresponding to each step
         Num.poly-=temp;  //New numerator after subtracting the result from previous step from the old numerator
         temp*=0;   //Flushing the temp vector back to zeros before next iteration
         n1--; i--;  //Decreasing the order of the numerator after each step, and decreasing the index of the quotient vector
     }
     return Poly(&vQ(0), vQ.getSize()-1); //Returning the quotient polynomial
}

//Euclidean Divison of polynomials to find the remainder (Version 1.0)
Poly Poly::euclidienDivisionR(const Poly& Divisor) const //Remainder = Dividend - Quotient*Divisor
{
     return Poly((*this) - ((*this).euclidienDivisionQ(Divisor))*Divisor); //Function call to first find quotient of the inputs and then compute the remainder
}

//Euclidean Divison of polynomials to find the remainder (Version 2.0)
Poly Poly::euclidienDivisionR(const Poly& Divisor, const Poly& Quotient) const //Remainder = Dividend - Quotient*Divisor
{
     return Poly((*this) - Quotient*Divisor);  //Use the previous Poly operator overloading functions with the given inputs to compute the remainder
}     
//END OF THE PROGRAM    
