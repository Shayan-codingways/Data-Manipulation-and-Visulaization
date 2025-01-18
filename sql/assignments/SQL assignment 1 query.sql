-- Display all the order related information for the orders in 2013 and above.


/* In SQL Server, the expression `CAST(SUBSTRING(Order_date, 1, 9))` appears to be attempting to extract a substring from the `Order_date` and cast it to another data type. Here's a breakdown:

1. `SUBSTRING(Order_date, 1, 9)`: This function extracts a substring from the `Order_date` column, starting at position 1 and extracting the next 9 characters.
   - `Order_date`: The column from which the substring is being extracted.
   - `1`: The starting position of the substring (first character).
   - `9`: The number of characters to extract.

2. `CAST(...)`: The `CAST` function converts the result of the `SUBSTRING` function to a specified data type. However, this SQL expression is incomplete, as the `CAST` function needs a target data type.

A correct example might look like this:
```sql
CAST(SUBSTRING(Order_date, 1, 9) AS DATE)
```
This extracts the first 9 characters from `Order_date` and casts it as a `DATE` type (assuming the substring represents a valid date). The target data type could vary based on what you're trying to achieve.*/

Select *
from OEHR_ORDERS
where year(cast(substring(Order_date, 1, 9) AS date)) >= '2013'

Select *
from OEHR_ORDERS
where cast(substring(Order_date, 1, 9) AS date) >= '01-01-2013'

--Display the job history of all the employees from 2010 to 2015.  
/*Recheck this Please*/
select *  --- came after 2010 and ended before or in 2015
from OEHR_JOB_HISTORY
where year(START_DATE) >= 2010 AND year(END_DATE) < 2015 -- one interpretation

select * 
from OEHR_JOB_HISTORY
where (year(START_DATE) >= 2010 AND year(Start_DATE) <= 2015) 
      or
	  (year(END_DATE) >= 2010 AND year(END_DATE) <= 2015) 

/*Display all employee related information for employees whose firstname contains two "s" at
any position. Two "s" may or may not be together, you have to show in both cases.*/

select *
from OEHR_EMPLOYEES
where FIRST_NAME like '%s%s%' or FIRST_NAME like '%ss%' 

--- %s%s%'  ->  any 2s anywhere in the string
--- '%ss%'  ->  any 2 consecutive s anywhere in between 


/* Show only the employee with the lowest salary in department 90, within the salary range 
of 5000 to 30000.*/

select Top 1 *
from OEHR_EMPLOYEES
where Salary between 5000 AND 30000 and DEPARTMENT_ID = '90'
order by salary 

/*Show All employees hired on the first of every month or on the third of every month, 
but not both. */

select *
from OEHR_EMPLOYEES
WHERE (DAY(HIRE_DATE)='01' AND DAY(HIRE_DATE) <> '03' ) or (DAY(HIRE_DATE) !='01' AND DAY(HIRE_DATE) = '03')

-- WE CAN'T JUST MAKE USE OF or AS THAT WILL BE TRUE EVEN WHEN BOTH CONDITIONS ARE TRUE. 

select distinct *
from OEHR_EMPLOYEES
where day(hire_date) in (1,3) -- 1 or 3 not both (IT'S LIKE A PYTHON TYPE AND NOT GIVING IT A LIST)

/*Show all the customers that live in the city which name contains an "a" but
not double "aa" together. */

select *
from OEHR_CUSTOMERS
where city like '%a%' and city not like '%aa%' 
 
-- Show all the customers who have not registered their email on Gmail.
select *
from OEHR_CUSTOMERS
WHERE CUST_EMAIL Not LIKE '%gmail.com'

--> has no email id
select *
from OEHR_CUSTOMERS
where CUST_EMAIL is null

-- or 

select *
from OEHR_CUSTOMERS
where CUST_EMAIL = ''

--or

select *
from OEHR_CUSTOMERS
where CUST_EMAIL like ''


-- Show All employees with salary greater than 10000 or department 90, but not both 
-- AGAIN ITS THE SAME CASE WHERE BOTH CONDITIONS CAN'T BE TRUE AND THAT'S WHY WE HAVE TO APPLY COMPLEX CONDITION. .

select *
from OEHR_EMPLOYEES
where (Salary > 10000 AND DEPARTMENT_ID != '90' ) 
      OR (salary <=10000 and DEPARTMENT_ID = '90')

/*Give me all the orders where order mode is "direct" and order status is 1, 
also display in the same query where order total is above 2000 regardless of the 
first condition.*/

select *
from OEHR_ORDERS
where (ORDER_MODE = 'direct' and ORDER_STATUS = '1') OR (ORDER_TOTAL > 2000) 
-- here both the cases can be true. 

