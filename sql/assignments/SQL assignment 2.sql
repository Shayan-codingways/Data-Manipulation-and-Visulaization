-- Show the break down of numbers of orders by order mode and 
--order status

select order_mode, order_status, count(*) as count 
from OEHR_ORDERS
group by ORDER_MODE, ORDER_STATUS

-- Shown by department id, 
-- tell me how many employees each department has, 
-- the total salary each department takes, -
-- average salary each department takes
select department_id, 
       count(*) as count, 
       sum(salary) as Total_Salary, 
	   avg(salary) as Avg_Salary
from OEHR_EMPLOYEES 
group by DEPARTMENT_ID

--Show me total num of customers and total distinct num of customers
--in each country id and each city together. 
--there should be no null in country id or city column

select country_id, city, count(*) as c1, count(customer_id) as c2
from OEHR_CUSTOMERS
where COUNTRY_ID is not null and City is not null
group by COUNTRY_ID, city

-- show me number of customers aggregated by city name 
-- that live in a city whose name contains 'a' or 'n'

select city, count(*) as num_customers
from OEHR_CUSTOMERS
where city like '%a%' or city like '%s%'
group by city 
order by num_customers desc

-- give me the total number of orders by each sales representative 
-- (broken up by each sales representative)

select sales_rep_id, count(*) as num_count
from OEHR_ORDERS
group by SALES_REP_ID
order by num_count desc

-- give me total num of orders in each year and in each month togther
-- excluding month april in every year
select year(substring(order_Date, 1, 9)) as year,
       month(substring(order_date, 1, 9)) as month,
       case 
	   when month(substring(order_date, 1, 9)) = '01' then 'Jan' 
	   when month(substring(order_date, 1, 9)) = '02' then 'Feb' 
	   when month(substring(order_date, 1, 9)) = '03' then 'Mar' 
	   when month(substring(order_date, 1, 9)) = '04' then 'Apr' 
	   when month(substring(order_date, 1, 9)) = '05' then 'May' 
	   when month(substring(order_date, 1, 9)) = '06' then 'Jun' 
	   when month(substring(order_date, 1, 9)) = '07' then 'Jul' 
	   when month(substring(order_date, 1, 9)) = '08' then 'Aug' 
	   when month(substring(order_date, 1, 9)) = '09' then 'Sep'
	   when month(substring(order_date, 1, 9)) = '10' then 'Oct' 
	   when month(substring(order_date, 1, 9)) = '11' then 'Nov' 
	   else 'Dec'
	   END AS Month_name,
	   count(*) as Count
from oehr_orders
where month(substring(order_date, 1, 9)) != '04'
group by year(substring(order_date, 1, 9)), 
         month(substring(order_date, 1, 9))

/*. 

COUNT(*):
Counts all rows in the table, including rows where all columns are NULL.
It does not consider the values in any specific column; it simply counts the total number of rows.

2. COUNT(column_name):
Counts only the non-NULL values in the specified column.
If the column contains NULL values, those rows are ignored in the count.

*/

-- Find out the unique postal codes that our customers belong too.
select distinct postal_code
from oehr_Customers
where postal_code is not null --> unique must not include null


--Display number of employees per department wise. 
--Select and display information for only those employees who do not take any commission.
select  DEPARTMENT_ID , count(*) as Depart_count_zerocommission
from OEHR_EMPLOYEES
where COMMISSION_PCT is null or COMMISSION_PCT= '0'
group by DEPARTMENT_ID

--Give me the count of customers by the first six characters of 
--the phone number. 
--Please know that “space” and special characters are also characters.
select substring(phone_number,1,6),count(*) 
from OEHR_CUSTOMERS
group by substring(phone_number,1,6)
-- very useful in finding the country customers by country via phone number. 

SELECT LEFT(phone_number, 6) AS FIRST_SIX_CHARACTERS, COUNT(*)
FROM OEHR_CUSTOMERS
GROUP BY LEFT(PHONE_NUMBER, 6);
