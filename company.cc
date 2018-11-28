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
}

void trainee::printEmployee(void) const
{

cout<<"ID "<<ID<<", "<<"Salary "<<salary<<", "<<"Period "<<period<<", "<<"Imputation "<<imputation<<endl;
}

double trainee::totalCost(void) const
{


}

