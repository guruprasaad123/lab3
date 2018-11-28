#include "company.h"
using namespace std;

//employee
void  employee::setSalaryAndId(const int i, const double s)
{
ID=i;
salary=s;

}

double employee::getSalary(void) const
{
return salary;

}

void employee::printEmployee(void) const
{

cout<<"ID "<<ID<<", "<<"Salary "<<salary<<endl;
}

//fixed_term
fixed_term::fixed_term(int id,double salary_, double period_)
{
ID=id;
salary=salary_;
period=period_;

}

double fixed_term::getPeriod(void) const
{
return period;

}

double fixed_term::totalCost(void) const
{
return salary*period;

}

//permanent
permanent::permanent(int id,double salary_, double bonus_)
{
ID=id;
salary=salary_;
bonus=bonus_;
}

double permanent::cost(void) const 
{
ID=0;
salary=0;
bonus=0;
}

//manager
manage::manager (int id, double salary_, double bonus_, double extra_bonus_, int team_size_)
{

ID=id;
salary=salary_;
bonus=bonus_;
extra_bonus=extra_bonus_;
team_size=team_size_;

}

void manager::printEmployee(void) const
{
cout<<"ID "<<ID<<", "<<"Salary "<<salary<<", "<<"Bonus "<<bonus<<", "<<"Extra bonus "<<extra_bonus<<", "<<"Team size "<<team_size<<endl;
}

double manager::cost(void) const
{

return ( salary+bonus+(extra_bonus*team_size) );

}

//trainer
trainee::trainee (int id, double salary_, double period_, double imputation_, const permanent &in_charge_ )
{
ID=id;
salary=salary_;
period=period_;
imputation=imputation_;
in_charge=in_charge_;
}

void trainee::printEmployee(void) const
{

cout<<"ID "<<ID<<", "<<"Salary "<<salary<<", "<<"Period "<<period<<", "<<"Imputation "<<imputation<<endl;
}

double trainee::totalCost(void) const
{
// (salary*period)+(imputation*)
return (salary+imputation)*period;
}


//subcontractor
subcontractor::subcontractor(int id, double salary_, double period_, double computer_cost_)
{
ID=id;
salary=salary_;   
period=period_;
computer_cost=computer_cost_; 
}

void subcontractor::printEmployee(void) const
{
cout<<"ID "<<ID<<", "<<"Salary "<<salary<<", "<<"Period "<<period<<", "<<"Computer cost"<<computer_cost;
}

void subcontractor::totalCost(void) const
{
    return (salary+computer_cost)*period;
}



 developer::developer (int id, double salary_, double bonus, int number_of_active_project_)
 {
     ID=id;
     salary=salary_;
     bonus=bonus_;
     number_of_active_project=number_of_active_project_;
 }
void developer::printEmployee(void) const
{
cout<<"ID "<<ID<<", "<<"Salary "<<salary<<", "<<"Bonus "<<bonus<<", "<<"Project number "<<number_of_active_project<<endl;
}
        
double developer::cost(void) const
{
return (salary+bonus);
}