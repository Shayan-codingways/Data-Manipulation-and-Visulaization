/*Write a SQL query to find the department name, department ID, and 
number of employees in each department whose salary is greater than 10,000.*/

select *
from OEHR_EMPLOYEES

select * 
from OEHR_DEPARTMENTS

select * 
from OEHR_LOCATIONS

select a.DEPARTMENT_ID,b.DEPARTMENT_NAME, 
       count(EMPLOYEE_ID) as EMP_COUNT
from OEHR_EMPLOYEES as a
inner join OEHR_DEPARTMENTS as  b
on a.DEPARTMENT_ID=b.DEPARTMENT_ID   -- we can use using(department_id) instead of on if col names are same in tables
where a.SALARY > 10000
group by a.DEPARTMENT_ID, b.DEPARTMENT_NAME


/* Qs2 --> Write a SQL query to find the department name and first and 
last name of the manager.  RECHECK */  

select b.MANAGER_ID, DEPARTMENT_NAME,FIRST_NAME,LAST_NAME, 
       FIRST_NAME + ' ' + LAST_NAME as Full_name
from OEHR_DEPARTMENTS as b
inner join OEHR_EMPLOYEES as a
on a.EMPLOYEE_ID=b.MANAGER_ID


/* qs 3 --> Write a SQL query to display the department name, city, and 
state province for each department. 
Show the results from both the tables even if you don't find their
matching results in the tables.*/

select *
from OEHR_DEPARTMENTS

select *
from OEHR_LOCATIONS

Select DEPARTMENT_NAME, CITY, STATE_PROVINCE
from OEHR_DEPARTMENTS as a
full outer join OEHR_LOCATIONS as b
on a.LOCATION_ID=b.LOCATION_ID



/* qs 4--> Show the number of employees in each department, 
but only for departments with more than 3 employees.*/

select b.DEPARTMENT_NAME,count(employee_id) as count_emp
from OEHR_EMPLOYEES as a
inner join OEHR_DEPARTMENTS as  b
on a.DEPARTMENT_ID=b.DEPARTMENT_ID
group by b.DEPARTMENT_NAME
having count(employee_id)>3


/*Show each department's name along with the count of employees per 
department. 
In the count of employees, only those employees should be considered 
who earn more than $5000*/

select a.DEPARTMENT_NAME,count(b.employee_id) as count_emp
from OEHR_EMPLOYEES as b 
left join OEHR_DEPARTMENTS as a
on a.department_id=b.DEPARTMENT_ID
where salary>5000 -- Observation --> QS: all joins work same why?
group by a.DEPARTMENT_NAME

/*QS 6: Find the highest salary in the 'IT' department. 
Do not use the department ID of 'IT' Department. 
Use joins to figure it out.*/
select max(salary)
from OEHR_EMPLOYEES as a
left join OEHR_DEPARTMENTS as b
on a.DEPARTMENT_ID=b.DEPARTMENT_ID
where DEPARTMENT_NAME='IT' 
--where statement leads to all joins doing same task

/* QS 7: Write a SQL query to calculate the average salary, and total employees. 
Return department name (Not department ID), average salary of that 
department and number of employees in that department. 
Only those departments should be displayed which departments have the 
average salary greater than $5000.*/

select department_name, avg(salary) as avg, count(employee_id) as count
from OEHR_EMPLOYEES as a
left join OEHR_DEPARTMENTS as b
on a.DEPARTMENT_ID=b.DEPARTMENT_ID
group by DEPARTMENT_NAME
having avg(salary)>5000

/* QS 8: Write a SQL query to find out which employees have or do not have a 
department. 
Return first name, last name, department ID, department name.*/

select FIRST_NAME,LAST_NAME,a.DEPARTMENT_ID,DEPARTMENT_NAME
from OEHR_EMPLOYEES as a
left join OEHR_DEPARTMENTS as b
on a.DEPARTMENT_ID=b.DEPARTMENT_ID
--where a.DEPARTMENT_ID is null or a.DEPARTMENT_ID is not null
--> just 1 employee with no department

/*QS 9: Show me all the data from Departments table and 
all the data from employees table. 
Even if a department does not have an employee, I want its data. 
But if an employee does not have a department, I dont want its data.*/
SELECT * FROM OEHR_EMPLOYEES
select * from OEHR_DEPARTMENTS

select *
from OEHR_DEPARTMENTS  as a  -- all departments irrespective of employee due left join
LEFT join OEHR_EMPLOYEES  as b 
on a.DEPARTMENT_ID=b.DEPARTMENT_ID 
where a.DEPARTMENT_ID is not null
-- where  a.DEPARTMENT_ID is not null  -- mean employee doesn't have a department  










 










 
