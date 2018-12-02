#include <iostream>
#include "company.h"
using namespace std;

int main()
{
    manager Alice(2,5000,400,50,7);
    cout<<"OUT01 :";Alice.printEmployee();
    cout<<"Total cost = "<<Alice.cost();
}
//