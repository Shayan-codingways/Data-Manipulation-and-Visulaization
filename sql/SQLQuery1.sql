-------------------------------------------------------------------------------------
--                        Creating Database and Tables
-------------------------------------------------------------------------------------

-- Creating Database
Create Database HR_DATA;

USE HR_DATA --> this is for selecting hr data and deselect the master one.

-- Defining a Schema (defining datatype of the columns + putting constraints)
Create Table #Employee(    --- table Employee
    -- name | data type | constraint 
    id Int primary key,   --- id field | int datatype | constraint of primary key
	name Varchar(50),     --- name field | varchar datatype | constraint of length 50
	age int not null      --- age field | int datatype | constraint not null
);


-- Drop Table ==> Delete Table
--> BLOB  saving any datatype that is not easily percieved eg emojis.

--> (import flat file from database name)

-------------------------------------------------------------------------------------------------
--                           Accessing Data From a Table
-------------------------------------------------------------------------------------------------
SELECT *
FROM OEHR_EMPLOYEES; -- Caution! Don't run on Master Database 

SELECT *
FROM OEHR_COUNTRIES;

SELECT *
FROM OEHR_DEPARTMENTS;


--Assignment: Make ERD [Entity Reltionship Diagram] Diagrams + identitfy relationships + express relations in ERD.

-----------------------------------------------------------------------------------------------------------------
--                                         New Query
--------------------------------------------------------------------------------------------------------------------------
Select Employee_id EMP_id, --- Select Employee_id Emp; --> renames column even without Alias 
       first_name AS Your_Name, 
	   last_name  
From OEHR_EMPLOYEES

--> name can't name a field {First Name} with space in between untill you do --> 
Select Employee_id, 
       first_name AS "Your Name",  -- naming with spaces are done in inverted commas
	   last_name,  
	   Job_ID
From OEHR_EMPLOYEES
where JOB_ID = 'IT_PROG' --FILTER
order by Employee_id desc

Select *
from OEHR_EMPLOYEES
where salary >= 2500 AND HIRE_DATE > '2010-03-13'
order by salary, HIRE_DATE

----------------------------------------------------------------------------------------------------------
--                     Date Functions --> IMPORTANT FOR IT TO BE A DATE datatype
-------------------------------------------------------------------------------------------------------------------
Select *
from OEHR_EMPLOYEES
where year( HIRE_DATE ) = '2010' and month( HIRE_DATE ) = '01' AND Day( HIRE_DATE ) = '1'
order by salary, HIRE_DATE


--- A function in SQL SERVER to directly print name of month.
SELECT FORMAT(HIRE_DATE, 'MMMM') AS month_name
FROM OEHR_EMPLOYEES;



----------------------------------------------------------------------------------------------------------
--                                  Top Command + Order BY           
-----------------------------------------------------------------------------------------------------------
Select Top 5 *  --> alternative to 'LIMIT' // [Top would run in last]
From OEHR_EMPLOYEES
order by salary desc; -->  order by salary in descending order

Select top 1 FIRST_NAME, EMPLOYEE_ID, LAST_NAME, SALARY  --> alternative to 'LIMIT' // [Top would run in last]
From OEHR_EMPLOYEES
order by salary;

Select Top 1 EMPLOYEE_ID  
From OEHR_EMPLOYEES
where JOB_ID = 'IT_PROG'
order by salary desc;

Select * 
From OEHR_EMPLOYEES
where EMPLOYEE_ID = '101';

Select *
From OEHR_EMPLOYEES
where salary <= '10000' and DEPARTMENT_ID = '100';

Select *
From OEHR_EMPLOYEES
where salary <= '10000' or DEPARTMENT_ID = '100';

Select *
From OEHR_EMPLOYEES
where (salary > 11000 And DEPARTMENT_ID != 100) OR (salary <= 11000 And DEPARTMENT_ID = 100);

--find data for salary between 10000 and 15000
Select *
From OEHR_EMPLOYEES
where salary between 10001 and 14999 ---> between is inclusive 


--> Like command and '%' use. (like is used for pattern)
Select *
From OEHR_EMPLOYEES
where FIRST_NAME like 'S%';

Select *
From OEHR_EMPLOYEES
where FIRST_NAME like '%s%';

Select *
From OEHR_EMPLOYEES
where FIRST_NAME = '%s%'; --> would search for a percentage sign in string

----------------------------------------------------------------------------------------------
              --           Further Functions  + crucial concepts          --
-----------------------------------------------------------------------------------------------

-- lower() --> function for lower case
-- upper() --> function for upper case

select * 
From OEHR_EMPLOYEES
where lower(first_name) like 'l%s'  
--> won't change capitalization as function is applied on filter (no changes in database)

select first_name, LOWER(first_name) 'first name' -->(would change the capatilization in results)
from OEHR_EMPLOYEES
where lower(first_name) like 'l%s'
--> (2 cols -->  with one having 'Luis' and other 'luis' as the later one is lower() on filter


--> [NOT] == sql won't evaluate those rows in cols which are null --> 
--> Null(data is missing) !=  ' '(void spaces) != self-entered  NULL is a string
--> is not null won't evaluate on computer's null values[missing data]
--> is null values won't evaluate on our entered null values
 select *
 from OEHR_EMPLOYEES
 where COMMISSION_PCT is not null and COMMISSION_PCT != ''
 --    searching for null/not null || searching for empty space / not null

 -- creating cols with dummy values
 select 'dummies' as students
 from OEHR_EMPLOYEES

 -- IN/List of Values
 select * 
 from OEHR_EMPLOYEES
 where EMPLOYEE_ID in ('100','101','102') --> list of values

 -- // where employee_id not in null --> won't evaluate due NOT


 ------
 Select count(*), sum(salary), AVG(salary), min(salary), max(salary) 
 from OEHR_EMPLOYEES

 -- ** count won't count rows with null values. 
 select count(*), count(COMMISSION_PCT) 
 from OEHR_EMPLOYEES

 -- count won't count rows with null values for specific column
 -- ans --> 107 | 35 rows(bcz 'null' won't be counted on a specific topic count(col)) 

--_____________________________________________________________________________

--___________________________________________________________________________

-- Find total no. emps
SELECT  COUNT(*), COUNT(DEPARTMENT_ID), COUNT(DISTINCT DEPARTMENT_ID)
FROM dbo.OEHR_EMPLOYEES -- DISTINCT selects unique values only

--Find maximum and minimum salary
SELECT EMPLOYEE_ID ,MIN(SALARY) 'MIN_SALARY' 
FROM OEHR_EMPLOYEES
group by EMPLOYEE_ID
having MIN(salary) > 17000  
-- we can't have aliased col name bcz select runs approx. at end so it isn't sawved as that

select distinct *
from OEHR_EMPLOYEES

select count(distinct *)  --> wrong!
from OEHR_EMPLOYEES

--Alternate Solution -- Subquery
SELECT COUNT(*) 
FROM (
    SELECT DISTINCT * 
    FROM OEHR_CUSTOMERS
) AS unique_rows;

select count(department_id)
from OEHR_EMPLOYEES
where DEPARTMENT_ID = '90'

select department_id, count(department_id),count(employee_id),sum(salary), count(COMMISSION_PCT)
from OEHR_EMPLOYEES
group by DEPARTMENT_ID

select job_id, count(*)
from OEHR_EMPLOYEES
group by job_id

SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), SUM(SALARY), COUNT(*), SUM(SALARY)/COUNT(*) AS AVG, STDEV(SALARY)
FROM OEHR_EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY AVG(SALARY)

--> FROM -- >  WHERE -->  AGGREGATES --> DISPLAY --> LIMIT
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), SUM(SALARY), COUNT(*), SUM(SALARY)/COUNT(*) AS AVG, STDEV(SALARY)
FROM OEHR_EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID

SELECT *, LEFT(PHONE_NUMBER,2) 'left', RIGHT(PHONE_NUMBER,3) 'right', 
       SUBSTRING(PHONE_NUMBER, 4,3)
FROM OEHR_EMPLOYEES;

-- substring(col_name, a,b) --> start from a and count b numbers to display.

SELECT COUNT(distinct DEPARTMENT_ID)
FROM OEHR_EMPLOYEES


SELECT DEPARTMENT_ID, JOB_ID, COUNT(*)
FROM OEHR_EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID


-----------------------------------------------------------------------------
 ---      HAVING CLAUSE (used for aggregate functions)  + NESTED QUERIES                       ---
------------------------------------------------------------------------------

SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), 
       SUM(SALARY) as sum, COUNT(*) as count, 
	   SUM(SALARY)/COUNT(*) AS AVG, STDEV(SALARY)
FROM OEHR_EMPLOYEES
where DEPARTMENT_ID=110
GROUP BY DEPARTMENT_ID, JOB_ID
having avg(Salary) = 8300 -- having clause is used for filtering aggregate functions
--> order => From -> Where -> Group BY -> Having -> Select -> top
--> (where can't use avg() with where as it runs before group by thus we can't filter by non-existing cols)


-- nested query using cte for 'having' alternative 
-- using where to filter column of aggregate function by subquery
WITH new_table AS 
    (SELECT  Avg(Salary) as avg, DEPARTMENT_ID
     FROM OEHR_EMPLOYEES
	 group by DEPARTMENT_ID)

SELECT *
FROM new_table
where avg>7000; -- now can filter average in where command that too by name

-- nested query without cte. 
SELECT *
FROM (SELECT phone_number, DEPARTMENT_ID
     FROM OEHR_EMPLOYEES
     WHERE phone_number LIKE '515%') as new
where DEPARTMENT_ID=90;


select *
from OEHR_EMPLOYEES
where first_name like 'h?t' and FIRST_NAME like 'h??t' and
      FIRST_NAME like 'cv*' and FIRST_NAME like 'fk[oeo]kdke'

	  -- look for these wildcards

-- create table
select *, month(hire_date) as month_name
into #hk    --> create table automatically and inputs this data into that table
            --> #table_name (temporary table)
	        --> #table --> can't be accessed by others on servers
			--> this table is on your pc
from OEHR_EMPLOYEES
where year(hire_date)='2018'


select *, month(hire_date) as month_name
into ##hk    --> create table automatically and inputs this data into that table
            --> ##table_name ( permenant table)
	        --> ##table --> can be accessed by others on servers
			--> this table is on your pc
from OEHR_EMPLOYEES
where year(hire_date)='2018'

-----------------------------------------------------------------------------
-- COPYING DATA INTO csv
-- do it from databse left top corner.
select *
from OEHR_EMPLOYEES

-----------------------------------------------------------------------------
 --                           Joins
-----------------------------------------------------------------------------
 
-- Inner Join (joins only rows on which joining cols have same/common values)
-- (only rows will be displayed which are in both tables)
select o.order_id, o.ORDER_MODE, oi.unit_price
from OEHR_ORDERS as o
inner join OEHR_ORDER_ITEMS as oi
on o.ORDER_ID=oi.ORDER_ID

-- Left Join (joins all values from left table and brings only matching values from right one) 
select o.order_id, o.ORDER_MODE, oi.unit_price
from OEHR_ORDERS as o
left join OEHR_ORDER_ITEMS as oi
on o.ORDER_ID=oi.ORDER_ID

-- Right Join (joins all values from right table and brings only matching values from left one) 
select o.order_id , o.ORDER_MODE, oi.unit_price
from OEHR_ORDERS as o
right join OEHR_ORDER_ITEMS as oi
on o.ORDER_ID=oi.ORDER_ID

-- Full Outer Join ( joins every thing)
select o.order_id , o.ORDER_MODE, oi.unit_price
from OEHR_ORDERS as o
full outer join OEHR_ORDER_ITEMS as oi
on o.ORDER_ID=oi.ORDER_ID

/* Math functions 
 -->  num % 2 = 0 even else odd
 -->  mod(num, divisor)
 -->  Power(num, exponent)

 --------------------------------------------------------------------------
 --                         Joins
 ------------------------------------------------------------------------------
 */
 select * from oehr_employees
 select * from OEHR_DEPARTMENTS

 select a.*, 
        b. DEPARTMENT_NAME, b.MANAGER_ID
 from OEHR_EMPLOYEES as a
 Left join OEHR_DEPARTMENTS as b
 on a.manager_ID  = b.manager_ID

 select a.*, 
        b. DEPARTMENT_NAME, b.MANAGER_ID
 from OEHR_EMPLOYEES as a
 Left join OEHR_DEPARTMENTS as b
 on a.DEPARTMENT_ID = b.DEPARTMENT_ID AND a.MANAGER_ID = b.MANAGER_ID

 select a.*, 
        b. DEPARTMENT_NAME, b.MANAGER_ID
 from OEHR_EMPLOYEES as a
 Left join OEHR_DEPARTMENTS as b
 on a.DEPARTMENT_ID = b.DEPARTMENT_ID or a.MANAGER_ID = b.MANAGER_ID

 select a.DEPARTMENT_ID, 
        b. DEPARTMENT_NAME, b.MANAGER_ID,
		c.CUST_FIRST_NAME
 from OEHR_EMPLOYEES as a
 Left join OEHR_DEPARTMENTS as b
 on a.EMPLOYEE_ID = b.DEPARTMENT_ID
 left join OEHR_CUSTOMERS c
 on c.CUSTOMER_ID=a.EMPLOYEE_ID

 
 -- will give all of left / no advantage of joining as it'll display whole left table
 
 /*union/union all/intersection are used for combining data(vertically)*/
 select *
 from OEHR_EMPLOYEES
 union     --> combine distinct rows (combines on order of column) (takes col name of first table)
 select *    --> remogve comletely duplicate rows.
 from OEHR_EMPLOYEES
 
 select *
 from OEHR_EMPLOYEES
 union all   --> display duplicate rows as well
 select *
 from OEHR_EMPLOYEES
 
 select employee_id, department_id from OEHR_EMPLOYEES
 union all
 select department_id, employee_id from OEHR_EMPLOYEES
 -- employee_id from table 1 and then after 107 reos employee id 
 -- will be joined with values of department_id and vice versa

 select *
 from OEHR_EMPLOYEES
 intersection 
 select *
 from OEHR_EMPLOYEES

 select * , 
       case
            when salary < 5000 then 'Low'
			when salary > 6000 then 'High'
			else 'Mid Salary' 
	   end as Salary_type
from OEHR_EMPLOYEES

-- whenever SQL case doesn't satisfy/find any condition then it'll give null
select  
       case
            when salary < 5000 then 'Low'
			when salary > 6000 then 'High'
	   end as Salary_type,
	   count(employee_id) as count
from OEHR_EMPLOYEES
-- here 6000 salary would have null

select  
       case
            when salary < 5000 then 'Low'
			when salary > 6000 then 'High'
	   end as Salary_type
	   --count(employee_id) as count
from OEHR_EMPLOYEES
group by (case
            when salary < 5000 then 'Low'
			when salary > 6000 then 'High'
	      end )

select Salary_type, count(employee_id)
from (select  *,
            case
            when salary < 5000 then 'Low'
			when salary > 6000 then 'High'
	        end as Salary_type
	   from OEHR_EMPLOYEES) as a
group by Salary_type


select 
       case
            when salary < 5000 then 'Low'
			when salary > 6000 then 'High'
	   end as Salary_type
	  
into #hk
from oehr_employees

select salary_type, count(*) 
from #hk
group by salary_type;


-- Subqueries

-------------------------------------------------------------------------------------------------------------------
                          --  Common Table Expressions  --
----------------------------------------------------------------------------------------------------------

with sub as(
    Select b.department_id, avg(salary)
	from OEHR_EMPLOYEES as a
	inner join OEHR_DEPARTMENTS as b
	on a.DEPARTMENT_ID=b.DEPARTMENT_ID
	group by b.DEPARTMENT_ID
)

select * from sub


---------------------------------------------------------------------------------------------------------
--  Window functions
---------------------------------------------------------------------------------------------------------
WITH SALARY_ORDER AS(
    SELECT 
	    Salary,
        ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS ROW_NUM, --just add row numbers
        RANK() OVER (ORDER BY SALARY DESC) AS RANK_NUM,  --ranks and skip ranks
        DENSE_RANK() OVER (ORDER BY SALARY DESC) AS DENSE_RANK_NUM --best ranks and includes all
    FROM OEHR_EMPLOYEES
)
SELECT * 
FROM SALARY_ORDER;

select * from OEHR_EMPLOYEES

SELECT employee_id,Salary,
       ROW_NUMBER() OVER (ORDER BY SALARY DESC, employee_id desc) AS ROW_NUM --just add row numbers
FROM OEHR_EMPLOYEES

SELECT  hire_date,Salary,
        lag(SALARY) OVER (ORDER BY SALARY) AS previous_salary 
FROM OEHR_EMPLOYEES

SELECT  hire_date,Salary,
        lag(SALARY,2) OVER (ORDER BY SALARY) AS secondlast_salary 
FROM OEHR_EMPLOYEES

SELECT  hire_date,Salary,
        lead(SALARY) OVER (ORDER BY SALARY) AS previous_salary --just add row numbers
FROM OEHR_EMPLOYEES

SELECT  hire_date,Salary,
        lead(SALARY,3) OVER (ORDER BY SALARY) AS third_salary 
FROM OEHR_EMPLOYEES  

SELECT department_id, salary,
       ROW_NUMBER() OVER (partition BY department_id order by salary desc) AS ROW_NUM --just add row numbers
FROM OEHR_EMPLOYEES

--In partition by row_number rest to 1 for each group/partition




 -- SELECT DISTINCT CITY FROM STATION WHERE MOD(ID, 2) = 0;
 -- select count(city)-count(distinct city) from station;
 /*(
    select CITY, length(CITY) AS name_length
    from STATION
    order by length(CITY) ASC, CITY ASC
    limit 1
)
union
(
    select CITY, length(CITY) AS name_length
    FROM STATION
    order by length(CITY) desc, CITY asc
    limit 1
); */


/*SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE 'A%' 
   OR CITY LIKE 'E%' 
   OR CITY LIKE 'I%' 
   OR CITY LIKE 'O%' 
   OR CITY LIKE 'U%';
*/  
-- CITY REGEXP '^[AEIOU]':
-- This uses a regular expression to match any CITY name that starts with one of the specified vowels (A, E, I, O, U).
-- ^ denotes the start of the string, ensuring the vowel is at the beginning of the CITY name.
/*
SELECT DISTINCT CITY
FROM STATION
WHERE lower(CITY)  REGEXP '^[AEIOU]';

-- where CITY regexp '^[aeiouAEIUO]';
*/



/* -- ends with vowel
select distinct CITY
from STATION
where lower(CITY) regexp '[aiueo]$'
-- The $ symbol denotes the end of the string, ensuring the last character is one of the specified vowels.
*/

/*
select CITY
from STATION
where lower(CITY) regexp '^[aeiou]' and lower(CITY) regexp '[aeiou]$'
*/


--Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
/*SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(SUBSTR(CITY, 1, 1)) NOT IN ('a', 'e', 'i', 'o', 'u')
AND LOWER(SUBSTR(CITY, LENGTH(CITY), 1)) NOT IN ('a', 'e', 'i', 'o', 'u');
*/


/*select 
    case when A + B <= C or A+ C <= B or B + C <= A then 'Not A Triangle'
         when A = B and B = C then 'Equilateral'
         when A = B or A = C or B = C then 'Isosceles'
         else 'Scalene'         
end as triangle_type
from TRIANGLES;*/

-- distance
/*
SELECT ROUND(SQRT(POW(MIN(LAT_N)-MAX(LAT_N),2) + POW(MIN(LONG_W)-MAX(LONG_W),2)),4)
FROM STATION;
*/












