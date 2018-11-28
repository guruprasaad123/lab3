#include <iostream>
#include "company.h"
using namespace std;

int main()
{
    int ID,i,j;
    double s,b,d;
    // Generating  company employee
    cout<<"Enter id, salary, bonus, extra bonus and managed team size for Alice manager"<<endl; 
    cin>>ID>>s>>b>>d>>i;
    manager Alice(ID,s,b,d,i);
    cout<<"Enter id, salary, bonus, and active project in charge for Igor developer"<<endl; 
    cin>>ID>>s>>b>>i;
    developer Igor(ID,s,b,i);
    cout<<"Enter id, salary, bonus, and active project in charge for Kim developer"<<endl; 
    cin>>ID>>s>>b>>i;
    developer Kim(ID,s,b,i);
    cout<<"Enter id, salary, bonus, and active project in charge for Aalap developer"<<endl; 
    cin>>ID>>s>>b>>i;
    developer Aalap(ID,s,b,i);
    cout<<"Enter id, salary, contract period, and charge for Ling subcontractor"<<endl; 
    cin>>ID>>s>>b>>d;
    subcontractor Ling(ID,s,b,d);
    cout<<"Enter id, salary, contract period, and imputation ration for John student"<<endl; 
    cin>>ID>>s>>b>>d;
    trainee John(ID,s,b,d,Igor);
    // some testing variable
    //employees e;
    //e.setSalaryAndId(900,0.);
    //permanent Olivia(900,2500.,300.);
    //fixed_term Rabier(900,2500.,2.);

    // some pointers
    employees *pe;
    permanent *pp;
    fixed_term *pf;
    manager *pm;
    developer *pd;
    subcontractor *ps;
    trainee *pt;

    //
    cout<<"OUT01 :";Alice.printEmployee();
    cout<<"OUT02 :";Igor.printEmployee();
    cout<<"OUT03 :";Kim.printEmployee();
    cout<<"OUT04 :";Aalap.printEmployee();
    cout<<"OUT05 :";Ling.printEmployee();
    cout<<"OUT06 :";John.printEmployee();


    //pe=&Alice;
    //cout<<"OUT07 :";pe->printEmployee();
    //cout<<"OUT08 :"<<pe->cost()<<endl;;
    //cout<<"OUT09 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //pe=&Igor;
    //cout<<"OUT10 :";pe->printEmployee();
    //cout<<"OUT11 :"<<pe->cost()<<endl;
    //cout<<"OUT12 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //pe=&Ling;
    //cout<<"OUT13 :";pe->printEmployee();
    //cout<<"OUT14 :"<<pe->cost()<<endl;
    //cout<<"OUT15 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //pe=&John;
    //cout<<"OUT16 :";pe->printEmployee();
    //cout<<"OUT17 :"<<pe->cost()<<endl;
    //cout<<"OUT18 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //
    //pp=&Alice;
    //cout<<"OUT19 :";pp->printEmployee();
    //cout<<"OUT20 :"<<pp->cost()<<endl;
    //cout<<"OUT21 :"<<pp->totalCost()<<endl;
    pp=NULL;

    //pp=&Igor;
    //cout<<"OUT22 :";pp->printEmployee();
    //cout<<"OUT23 :"<<pp->cost()<<endl;
    //cout<<"OUT24 :"<<pp->totalCost()<<endl;
    pp=NULL;

    //pp=&Ling;
    //cout<<"OUT25 :";pp->printEmployee();
    //cout<<"OUT26 :"<<pp->cost()<<endl;
    //cout<<"OUT27 :"<<pp->totalCost()<<endl;
    pp=NULL;

    //pp=&John;
    //cout<<"OUT28 :";pp->printEmployee();
    //cout<<"OUT29 :"<<pp->cost()<<endl;
    //cout<<"OUT30 :"<<pp->totalCost()<<endl;
    pp=NULL;
    
    //
    //pf=&Alice;
    //cout<<"OUT31 :";pf->printEmployee();
    //cout<<"OUT32 :"<<pf->cost()<<endl;
    //cout<<"OUT33 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //pf=&Igor;
    //cout<<"OUT34 :";pf->printEmployee();
    //cout<<"OUT35 :"<<pf->cost()<<endl;
    //cout<<"OUT36 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //pf=&Ling;
    //cout<<"OUT37 :";pf->printEmployee();
    //cout<<"OUT38 :"<<pf->cost()<<endl;
    //cout<<"OUT39 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //pf=&John;
    //cout<<"OUT40 :";pf->printEmployee();
    //cout<<"OUT41 :"<<pf->cost()<<endl;
    //cout<<"OUT42 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //
    //pm=&Alice;
    //cout<<"OUT43 :";pm->printEmployee();
    //cout<<"OUT44 :"<<pm->cost()<<endl;
    //cout<<"OUT45 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //pm=&Igor;
    //cout<<"OUT46 :";pm->printEmployee();
    //cout<<"OUT47 :"<<pm->cost()<<endl;
    //cout<<"OUT48 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //pm=&Ling;
    //cout<<"OUT49 :";pm->printEmployee();
    //cout<<"OUT50 :"<<pm->cost()<<endl;
    //cout<<"OUT51 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //pm=&John;
    //cout<<"OUT51 :";pm->printEmployee();
    //cout<<"OUT52 :"<<pm->cost()<<endl;
    //cout<<"OUT53 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //
    //pd=&Alice;
    //cout<<"OUT54 :";pd->printEmployee();
    //cout<<"OUT55 :"<<pd->cost()<<endl;
    //cout<<"OUT56 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //pd=&Igor;
    //cout<<"OUT57 :";pd->printEmployee();
    //cout<<"OUT58 :"<<pd->cost()<<endl;
    //cout<<"OUT59 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //pd=&Ling;
    //cout<<"OUT60 :";pd->printEmployee();
    //cout<<"OUT61 :"<<pd->cost()<<endl;
    //cout<<"OUT62 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //pd=&John;
    //cout<<"OUT63 :";pd->printEmployee();
    //cout<<"OUT64 :"<<pd->cost()<<endl;
    //cout<<"OUT65 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //
    //ps=&Alice;
    //cout<<"OUT66 :";ps->printEmployee();
    //cout<<"OUT67 :"<<ps->cost()<<endl;
    //cout<<"OUT68 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //ps=&Igor;
    //cout<<"OUT69 :";ps->printEmployee();
    //cout<<"OUT70 :"<<ps->cost()<<endl;
    //cout<<"OUT71 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //ps=&Ling;
    //cout<<"OUT72 :";ps->printEmployee();
    //cout<<"OUT73 :"<<ps->cost()<<endl;
    //cout<<"OUT74 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //ps=&John;
    //cout<<"OUT75 :";ps->printEmployee();
    //cout<<"OUT76 :"<<ps->cost()<<endl;
    //cout<<"OUT77 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //
    //pt=&Alice;
    //cout<<"OUT78 :";pt->printEmployee();
    //cout<<"OUT79 :"<<pt->cost()<<endl;
    //cout<<"OUT80 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //pt=&Igor;
    //cout<<"OUT81 :";pt->printEmployee();
    //cout<<"OUT82 :"<<pt->cost()<<endl;
    //cout<<"OUT83 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //pt=&Ling;
    //cout<<"OUT84 :";pt->printEmployee();
    //cout<<"OUT85 :"<<pt->cost()<<endl;
    //cout<<"OUT86 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //pt=&John;
    //cout<<"OUT87 :";pt->printEmployee();
    //cout<<"OUT88 :"<<pt->cost()<<endl;
    //cout<<"OUT89 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //cout<<"OUT90 :";e.printEmployee();
    cout<<endl;
    cout<<endl;
    cout<<endl;
    cout<<endl;
    cout<<"finished"<<endl;

    return 0;
}
