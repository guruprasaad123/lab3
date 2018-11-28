#ifndef Company_lab3_H
#define Company_lab3_H

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// Base class of IT financial database |||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
/// employees class stores employees identification number (ID) and salary (salary)
class employees
{
    public:
        void setSalaryAndId(const int i, const double s);
        double getSalary(void) const;
        virtual void printEmployee(void) const;
    private:
        int ID;
        double salary;
};
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// First derived level : class correspond to general categories ||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
/// fixed-term contract category : employees only work in the company for a determined period. 
//! fixed_term class stores the period in months for which they are scheduled to stay in the company.
class fixed_term : public employees
{
    public:
        fixed_term(int id,double salary, double period_);
        double getPeriod(void) const;
        virtual double totalCost(void) const =0;
    private:
        double period;
};
/// Employees with a permanent contract. This category has a bonus corresponding to company
//! profits shared. permanent class represents this category and stores the bonus per month.
class permanent : public employees
{
    public:
        permanent(int id,double salary, double bonus_);
        virtual double cost(void) const =0;
    protected:
        double bonus;
};
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// second derived level : class corresponding to each type of permanent employees |
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
class manager : public permanent
{
    public:
        manager (int id, double salary, double bonus, double extra_bonus_, int team_size_);
        void printEmployee(void) const;
        double cost(void) const;
    private:
        int team_size;
        double extra_bonus;
};
class developer : public permanent
{
    public:
        developer (int id, double salary, double bonus, int number_of_active_project_);
        void printEmployee(void) const;
        double cost(void) const;
    private:
        int number_of_active_project;
};
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// second derived level : class corresponding to each type of fixed-term employees 
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
class trainee : public fixed_term
{
    public:
        trainee (int id, double salary, double period, double imputation_, const permanent &in_charge_ );
        void printEmployee(void) const;
        double totalCost(void) const;
    private:
        double imputation;
        const permanent &in_charge;
};
class subcontractor : public fixed_term
{
    public:
        subcontractor(int id, double salary, double period, double computer_cost_);
        void printEmployee(void) const;
        double totalCost(void) const;
    private:
        double computer_cost;
};
#endif
