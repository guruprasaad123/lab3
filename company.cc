#include "company.h"
#include <iostream>
using namespace std;

//employee
void  employees::setSalaryAndId(const int i, const double s)
{
ID=i;
salary=s;

}

double employees::getSalary(void) const
{
return salary;

}

void employees::printEmployee(void) const
{

cout<<"ID "<<ID<<", "<<"Salary "<<getSalary();
}

//fixed_term
fixed_term::fixed_term(int id,double salary_, double period_)
{
setSalaryAndId(id,salary_);

period=period_;

}

double fixed_term::getPeriod(void) const
{
return period;

}



//permanent
permanent::permanent(int id,double salary_, double bonus_)
{
setSalaryAndId(id,salary_);
bonus=bonus_;
}



//manager
manager::manager (int id, double salary_, double bonus_, double extra_bonus_, int team_size_):permanent(id,salary_, bonus_)
{

cout<<"manager";
extra_bonus=extra_bonus_;
team_size=team_size_;

}

void manager::printEmployee(void) const
{
employees::printEmployee();
cout<<", "<<"Bonus "<<bonus<<", "<<"Extra bonus "<<extra_bonus<<", "<<"Team size "<<team_size<<endl;
}

double manager::cost(void) const
{

return ( getSalary()+bonus+(extra_bonus*team_size) );

}

//trainer
trainee::trainee (int id, double salary_, double period_, double imputation_, const permanent &in_charge_):in_charge(in_charge_),fixed_term(id, salary_, period_)
{

imputation=imputation_;
//in_charge=(*in_charge_);
}

void trainee::printEmployee(void) const
{
employees::printEmployee();
cout<<", "<<"Period "<<fixed_term::getPeriod()<<", "<<"Imputation "<<imputation<<endl;
}

double trainee::totalCost(void) const
{
// (salary*period)+(imputation*)
return (getSalary()+imputation)*fixed_term::getPeriod();
}


//subcontractor
subcontractor::subcontractor(int id, double salary_, double period_, double computer_cost_):fixed_term(id, salary_, period_)
{

computer_cost=computer_cost_; 
}

void subcontractor::printEmployee(void) const
{
    employees::printEmployee();
cout<<", "<<"Period "<<fixed_term::getPeriod()<<", "<<"Computer cost "<<computer_cost<<endl;
}

double subcontractor::totalCost(void) const
{
    return (getSalary()+computer_cost)*fixed_term::getPeriod();
}



 developer::developer (int id, double salary_, double bonus_, int number_of_active_project_):permanent(id,salary_,bonus_)
 {

     number_of_active_project=number_of_active_project_;
 }

void developer::printEmployee(void) const
{
    employees::printEmployee();
cout<<", "<<"Bonus "<<bonus<<", "<<"Project number "<<number_of_active_project<<endl;
}
        
double developer::cost(void) const
{
return (getSalary()+bonus);
}