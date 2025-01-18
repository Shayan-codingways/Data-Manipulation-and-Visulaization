-- Shayan 27027
/*
Find the employee with the 9th Highest salary from the employees table 
(Among row_num, rank, and dense_rank, use the function that gives the 9th highest salary
most accurately, even when there are duplicates). Don't use any of the subqueries, use a CTE.
*/
with ninth_highsalary as(
select employee_id , salary, 
       DENSE_RANK() over(order by salary desc) as dense_rank
from OEHR_EMPLOYEES
)

select *
from ninth_highsalary
where dense_rank=9

--by subquery
select top 9 salary
from OEHR_EMPLOYEES
group by salary
order by SALARY desc

-- OR

select distinct top 9 salary
from OEHR_EMPLOYEES
order by SALARY desc


select top 1*
from (select top 9 salary
      from OEHR_EMPLOYEES
      group by salary
      order by SALARY desc) as a
order by SALARY asc

-- this is actually finding the employee details for ninth high salary.
select EMPLOYEE_ID
from OEHR_EMPLOYEES
where salary = (select top 1*
from (select top 9 salary
      from OEHR_EMPLOYEES
      group by salary
      order by SALARY desc) as a
order by SALARY)  --the answer of subquery is in list


-- Shayan 27027
/*
 Use a CTE to calculate how many people have salary above or below the company average. 
 I want two columns, with two rows, one column that shows “Above Average” and “Below Average”, other 
 column that shows the respective count.
*/
    
with company_average as (
    select salary, avg(salary) over() as avg --created whole column for salary
    from OEHR_EMPLOYEES
),
salary_type as (
    select case 
            when salary > avg  then 'Above Average'
            when salary < avg then 'Below Average'
            else 'Average'  -- just included though this case isn't there in the data
           end as salary_category
    from company_average
)
select 
      salary_category, 
      count(*) as count
from salary_type 
group by salary_category;



-- Shayan 27027
/*
 Create a CTE to only have those employees who have salary above company average, and then join this CTE 
 with the department table to bring out the count of employees 
 (only those employees with salary above company average) with department names.
*/

-- finding above-average salaried employees
with average as(
      select * , avg(salary) over() as avg
	  from OEHR_EMPLOYEES
),
abv_avg as(
      select a.*
	  from OEHR_EMPLOYEES as a
	  inner join average as b
	  on a.EMPLOYEE_ID=b.EMPLOYEE_ID
	  where a.salary > b.avg
 )
 -- above average salaried employees count for each department
 select b.department_name , count(*) as count
 from abv_avg as a
 left join OEHR_DEPARTMENTS as b
 on a.DEPARTMENT_ID=b.DEPARTMENT_ID
 group by b.DEPARTMENT_NAME
 order by count desc

-- Shayan 27027
/*
 Give me all the employees who have the lowest salaries in their respective departments. 
 Use Dense rank.
*/

with employeedepart_ranking as(
   select * ,
         DENSE_RANK() over(partition by department_id order by salary ) as Ranking
   from OEHR_EMPLOYEES
)

select EMPLOYEE_ID, FIRST_NAME,LAST_NAME,DEPARTMENT_ID,SALARY 
from employeedepart_ranking
where Ranking=1   -- department 90 has 2 lowest salaries

-- Shayan 27027
/*
Give me all the employees who have the Highest salaries in their respective departments and job titles. 
Use Dense rank.
*/

with high_ranking as(
   select EMPLOYEE_ID, concat(FIRST_NAME, ' ', LAST_NAME) as name, a.department_id, b.department_name, salary,
       DENSE_RANK() over(partition by a.department_id, b.department_name order by salary desc ) as Ranking
   from OEHR_EMPLOYEES as a
   left join OEHR_DEPARTMENTS as b
   on a.DEPARTMENT_ID=b.DEPARTMENT_ID
)

Select *
from high_ranking
where Ranking=1

--Shayan 27027
/*
 Use Row_num, rank, and dense_rank together in one query on the employees table to rank employees with respect to salary. 
 Along with displaying the starting 10 rows, make sure to write the difference between these three functions.
*/
select top 10 *, 
      ROW_NUMBER() over (order by salary) as row_num,
      rank() over (order by salary) as rank,
	  dense_rank() over (order by salary) as dense_rank
from OEHR_EMPLOYEES;
-- Differnce --
/* Row_number -->  just numbers the rows uniquely based on salary and duplicates aren't catered */
/* Rank --> ranks the salaries and the duplicates gets the same rank but it skips the rank due duplicates */
/* Dense_rank --> ranks the salaries and duplicates gets the same rank but it doesn't skips ranks */


 -- Shayan 27027
 /*
 List the employees who have a job title that is not present in the job history table. 
 Use CTE, not subquery.
 */

with Job as(
    SELECT Distinct JOB_ID 
    FROM OEHR_JOB_HISTORY
)
-- join needed because the cte is now a table and not a list.
-- List case is the second way around. 
SELECT a.employee_id, a.job_id
FROM OEHR_EMPLOYEES a
LEFT JOIN Job b 
ON a.job_id = b.job_id
WHERE b.job_id IS NULL;

-- 2nd way around to do the same thing. 
select employee_id, job_id
from OEHR_EMPLOYEES
where JOB_ID not in (SELECT Distinct JOB_ID 
    FROM OEHR_JOB_HISTORY)




 -- Shayan 27027
 /*
 Find the names of employees who have been in the company longer than the average tenure of employees 
 in their department. Use CTE, not subquery.
 */

 with average as (
    SELECT DEPARTMENT_ID,
       AVG(DATEDIFF(Day, HIRE_DATE, GETDATE())) AS AvgTenure
    FROM OEHR_EMPLOYEES
    GROUP BY DEPARTMENT_ID
 )

 select first_name, last_name, a.department_id, datediff(day, HIRE_DATE,getdate()) as diff, AvgTenure
 from OEHR_EMPLOYEES as a
 left join average as b
 on a.DEPARTMENT_ID=b.DEPARTMENT_ID
 where datediff(day, HIRE_DATE,getdate())  > AvgTenure

 -- Shayan 27027
 /*
  Along with all the employee data, show me the difference in salary of the current employee and 
  employee who was hired just before current employee. Use only employee table.
 */
 with lag as(
    select EMPLOYEE_ID,HIRE_DATE, salary ,
	lag(HIRE_DATE) over(order by hire_date) as hire_before ,lag(salary) over(order by hire_date) as salary_before
	from OEHR_EMPLOYEES
 )
 select *, abs(SALARY-salary_before)  as sal_diff
 from lag

 -- more better way
with prev_salary as(
   select *, lag(salary) over(order by hire_date) as previous
   from OEHR_EMPLOYEES
)
Select *, abs((salary-previous)) as Difference
from prev_salary