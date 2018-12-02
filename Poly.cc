#include<iostream>
#include "Poly.h"
#define MAX_SIZE 10

using namespace std;

Poly::Poly()
{
    values=NULL;
    size=0;
}

Poly::Poly(double val[],int N)
{
    size=N;
    int i=0;
    double *array;
    try{
       array = new double[N];
       values=array;
       for(;i<size;i++)
       {
           array[i]=val[i];
       }
    }
    catch(...)
    {
        throw -1;
    }
}


void Poly::print(void) const
{
    try{
if( size > 0)
{
    
    if( values[0]!=0 )
    {
        cout<<values[0]<<"+";
    }

int i=0;

for(;i<size;i++)
{
string end=(i==size-1)?"":"+";
if( values[i]!=0 )
{
    cout<<values[i]<<"*x^"<<i+1<<end;
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

int Poly::getSize(void) const 
{
return size;
}

Poly& Poly::operator+(const Poly & opp)
{
    try{
int min_size = ( size < opp.getSize() ) ? size:opp.getSize();
 int i=0;
 for(;i<min_size;i++)
 {
     values[i] = values[i] + opp.values[i];
 }
    }
    catch(...)
    {
        throw -1;
    }
 return *this;
}


Poly& Poly::operator-(const Poly & opp)
{
   try{
int min_size = ( size < opp.getSize() ) ? size:opp.getSize();
 int i=0;
 for(;i<min_size;i++)
 {
     values[i] = values[i] * opp.values[i];
 }
    }
    catch(...)
    {
        throw -1;
    }
 return *this;
}


Poly& Poly::operator*(const Poly & opp)
{
   try{
int min_size = ( size < opp.getSize() ) ? size:opp.getSize();
 int i=0;
 for(;i<min_size;i++)
 {
     values[i] = values[i] * opp.values[i];
 }
    }
    catch(...)
    {
        throw -1;
    }
 return *this;
}