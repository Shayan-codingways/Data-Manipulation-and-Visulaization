--Shayan 27027
/*  For every employee, display their ID, first name and last name together 
in one column separated by a space, and another column that shows 
- 'Low Earner' if their salary is less than equal to 5000. 
   If Salary is greater than 5000, but lower than equal to 1000, then ‘Middle Earner’. 
   Otherwise ‘High Earner’ except for where we have null or 0 value in salary 
   column.*/



select * 
from OEHR_EMPLOYEES

Select EMPLOYEE_ID,FIRST_NAME + ' ' + LAST_NAME as Employee,
       case when salary <= 5000 then 'LOW-EARNER'
	        when salary > 5000 and salary <= 10000 then 'MIDDLE-EARNER'
			when salary = 0 or salary is Null then 'Null'
			else 'HIGH-EARNER' 
	   end as Salary_category
from OEHR_EMPLOYEES


select *
from OEHR_EMPLOYEES

select avg(salary)
from OEHR_EMPLOYEES

--Shayan 27027
/* Find the names of employees who earn more than the average salary of the company.
Arrange the result by the highest salary, and if more than one person has the same
salary, you should give preference to the length of “First Name” column. 
So, two people with same salary, the first record would be of the person who has 
more letters in his/her first name.*/

SELECT FIRST_NAME, SALARY
FROM OEHR_EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) 
                FROM OEHR_EMPLOYEES)
ORDER BY SALARY DESC, LEN(FIRST_NAME) DESC;


select case when salary > (select avg(salary)
                           from OEHR_EMPLOYEES) then first_name
       end as name,
	   salary
from OEHR_EMPLOYEES
where (select case when salary > (select avg(salary)
                                  from OEHR_EMPLOYEES) then first_name
       end as name) is not null
order by salary desc, len(first_name) desc

--Shayan 27027
/*  Write a SQL query to find details of those employees where the salary falls 
within the range of the smallest salary and 7000 (both inclusive). 
Sort the results by highest salary to lowest salary. 
Put the results in a table and show results.*/
 
select * 
into #new_table
from OEHR_EMPLOYEES
where salary between (select min(Salary)
                      from OEHR_EMPLOYEES) and 7000
order by salary desc

select *
from #new_table

--Shayan 27027
/* Using subqueries, display all the records of employee table, display 
another column that gives the average salary of the whole company in each cell, 
and create another column which compares the employee’s salary with the company
average salary. 
If employee salary is greater than company average, this column should show 
“Above Average”, otherwise should show below average.*/

select *, 
      (select Avg(salary) from OEHR_EMPLOYEES) as AVG, 
	  case when salary > (select Avg(salary) 
                          from OEHR_EMPLOYEES) then 'Above-Average'
		   else 'Below-Average' 
		end as Salary_Category
from OEHR_EMPLOYEES

select FIRST_NAME, (Select avg(salary) from OEHR_EMPLOYEES) as bbc
from OEHR_EMPLOYEES
-- display overall avg in all rows


--Shayan 27027
/*Using Subqueries, from the department’s table, 
show only the departments that do not have any employee.*/

--by subqueires (all department ids not found in employee)
SELECT DEPARTMENT_ID, DEPARTMENT_NAME 
FROM OEHR_DEPARTMENTS 
WHERE DEPARTMENT_ID Not IN ( SELECT Distinct DEPARTMENT_ID 
                             FROM OEHR_EMPLOYEES
							 where DEPARTMENT_ID is not null)

Select * 
from OEHR_DEPARTMENTS

select * 
from OEHR_EMPLOYEES

-- by joins
select *
from OEHR_DEPARTMENTS as a
left join OEHR_EMPLOYEES as b
on a.DEPARTMENT_ID = b.DEPARTMENT_ID
where b.DEPARTMENT_ID is null
-- This is a common query used to find "unmatched" records between two related tables.
-- The result will contain all department details (from OEHR_DEPARTMENTS) for which no employees are listed in the OEHR_EMPLOYEES table (i.e., departments that have no employees).

--Shayan 27027
/* The query will return all departments from OEHR_DEPARTMENTS that do not have any 
employees associated with them. This is because the left join ensures that all rows from 
the OEHR_DEPARTMENTS table appear, and the WHERE b.DEPARTMENT_ID IS NULL condition ensures 
that only those departments without matching employees are included in the result.*/



-- wasn't working
SELECT * 
FROM OEHR_DEPARTMENTS 
WHERE DEPARTMENT_ID Not IN ( SELECT Distinct DEPARTMENT_ID 
                             FROM OEHR_EMPLOYEES )
-- wasn't working because from employees there will be null value as well and sql won't
-- evaluate on the list having null
-- When a NULL is present in the subquery results, NOT IN may fail to return any rows because NULL comparisons are indeterminate

--Shayan 27027
/* Find employees who were hired after the hiring date of the latest employee in 
IT department.*/

-- finding all employees
select *
from OEHR_EMPLOYEES
where HIRE_DATE > (select max(hire_Date)
                   from OEHR_EMPLOYEES as a
                   inner join OEHR_DEPARTMENTS as b
                   on a.DEPARTMENT_ID=b.DEPARTMENT_ID
                   where DEPARTMENT_NAME = 'IT')


select * from OEHR_EMPLOYEES
select * from OEHR_DEPARTMENTS

-- by joins

-- latest hire date in [IT] department
select max(hire_Date)
from OEHR_EMPLOYEES as a
full outer join OEHR_DEPARTMENTS as b
on a.DEPARTMENT_ID=b.DEPARTMENT_ID
where DEPARTMENT_NAME = 'IT'



--Shayan 27027
/*Using subqueries, find the departments where the average salary of department is greater 
than the company's overall average salary.*/

SELECT d.DEPARTMENT_ID, DEPARTMENT_NAME, AVG(SALARY) AS avg_salary
FROM OEHR_EMPLOYEES e
inner join OEHR_DEPARTMENTS d 
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_ID, d.DEPARTMENT_NAME
HAVING AVG(SALARY) > (
    SELECT AVG(SALARY)
    FROM OEHR_EMPLOYEES
);

-- avg salary of department
select a.DEPARTMENT_ID,department_name, avg(Salary) as avg
from OEHR_DEPARTMENTS as a 
inner join OEHR_EMPLOYEES as b
on a.department_id=b.department_id
 group by DEPARTMENT_NAME,a.DEPARTMENT_ID

select * 
from (
    select a.DEPARTMENT_ID,department_name, avg(Salary) as avg
    from OEHR_DEPARTMENTS as a 
    inner join OEHR_EMPLOYEES as b
    on a.department_id=b.department_id
    group by DEPARTMENT_NAME,a.DEPARTMENT_ID
) as subquery
where avg > (select avg(salary)
             from OEHR_EMPLOYEES)




--Shayan 27027
/* List the employees who have a job title that is not present in the 
job history table.*/

select * from OEHR_EMPLOYEES
select * from OEHR_JOB_HISTORY

SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.JOB_ID
FROM OEHR_EMPLOYEES e
WHERE e.JOB_ID NOT IN (
    SELECT Distinct JOB_ID 
    FROM OEHR_JOB_HISTORY
);

-- joining jobs and job history
SELECT *
FROM OEHR_EMPLOYEES a
LEFT JOIN OEHR_JOB_HISTORY b 
ON a.JOB_ID = b.JOB_ID  
WHERE b.JOB_ID IS NULL;




--Shayan 27027
/* Find the names of employees who have been in the company longer than the average tenure 
of employees in their department.*/
select first_name, last_name, a.DEPARTMENT_ID, DATEDIFF(DAY, HIRE_DATE, GETDATE()) as dif,
       avgTenure
from OEHR_EMPLOYEES  as a
inner join (SELECT department_id, AVG(DATEDIFF(Day, HIRE_DATE, GETDATE())) AS AvgTenure
            FROM OEHR_EMPLOYEES
            GROUP BY DEPARTMENT_ID) as b
on a.DEPARTMENT_ID = b.department_id
where DATEDIFF(DAY, HIRE_DATE, GETDATE()) > avgTenure

select * from OEHR_EMPLOYEES
select * from OEHR_DEPARTMENTS

--average tenure
SELECT DEPARTMENT_ID,
       AVG(DATEDIFF(Day, HIRE_DATE, GETDATE())) AS AvgTenure
FROM OEHR_EMPLOYEES
GROUP BY DEPARTMENT_ID

--1st Way
select first_name, last_name, DEPARTMENT_ID, DATEDIFF(DAY, HIRE_DATE, GETDATE()) as dif,
       (SELECT AVG(DATEDIFF(DAY, HIRE_DATE, GETDATE())) AS AvgTenure
        FROM OEHR_EMPLOYEES b
		where a.department_id = b.department_id) as avg
from OEHR_EMPLOYEES a
where DATEDIFF(DAY, HIRE_DATE, GETDATE()) > (SELECT AVG(DATEDIFF(DAY, HIRE_DATE, GETDATE())) AS AvgTenure
                                             FROM OEHR_EMPLOYEES b
											 where a.department_id = b.department_id)

--2nd Way


--Shayan 27027
/*Using subquery, show only the employee record with the 3rd highest salary. 
If two people have same 3rd highest salary, show the one that has the lowest difference 
between his/her employee ID and the company’s average salary. 
(Yes, you read it write. I want you to compare employee ID with company’s average salary. 
Just for fun)*/

-- Showing employee record with just 3rd high salary
Select *
from OEHR_EMPLOYEES
where salary in (select top 1*        -- just 3rd high salaries
                 from (select Distinct top 3 salary
                       from OEHR_EMPLOYEES
                       group by salary
                       order by salary desc) as a
                 order by salary)
order by ((Select avg(salary)         -- the one with lowest difference
          from OEHR_EMPLOYEES) - EMPLOYEE_ID) 


-- 3 high salaries
select Distinct top 3 salary
from OEHR_EMPLOYEES
group by salary
order by salary desc

-- just 3rd high salary 
--(by selecting the all from subquery and inverting it and just sleecting top 1)

select top 1*
from (select top 3 salary
      from OEHR_EMPLOYEES
      group by salary
      order by salary desc) as a
order by salary



-- 2nd highest
Select *
from OEHR_EMPLOYEES
where salary = (select top 1*
                 from (select Distinct top 2 salary
                       from OEHR_EMPLOYEES
                       group by salary
                       order by salary desc) as a
                 order by salary)
order by ((Select avg(salary)
          from OEHR_EMPLOYEES) - EMPLOYEE_ID)










