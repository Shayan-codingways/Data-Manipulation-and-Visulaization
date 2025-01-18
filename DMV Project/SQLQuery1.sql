/*Find out the difference between maximum and minimum list_price for each category. Return CATEGORY_ID and the 
difference column. 
Order the result by highest difference.*/
-- Task 1
select CATEGORY_ID, (max(LIST_PRICE)-min(list_price)) as diff
from OEHR_PRODUCT_INFORMATION
group by CATEGORY_ID
order by diff desc

/*Find the top 3 most expensive products in each category based on LIST_PRICE. 
Return PRODUCT_ID, PRODUCT_NAME, CATEGORY_ID, LIST_PRICE. Order the result by category_ID and list_price,
both descending.*/
-- Task 2
Select * 
from ( select category_id, product_id, PRODUCT_NAME,LIST_PRICE, 
       dense_rank() over(partition by category_id order by list_price desc) as ranke
       from OEHR_PRODUCT_INFORMATION) as a
where ranke <= 3
order by CATEGORY_ID desc, LIST_PRICE desc

/*Find products that have a LIST_PRICE greater than the overall average LIST_PRICE and a WEIGHT_CLASS less than 
the overall average WEIGHT_CLASS. Return the PRODUCT_ID, PRODUCT_NAME, WEIGHT_CLASS, and LIST_PRICE. 
Order the result by highest weight class, and then by lowest list price.*/
-- TASK 3
select *
from OEHR_PRODUCT_INFORMATION

select PRODUCT_ID,PRODUCT_NAME,WEIGHT_CLASS, LIST_PRICE
from OEHR_PRODUCT_INFORMATION
where LIST_PRICE > (select avg(list_price) from OEHR_PRODUCT_INFORMATION) and
     WEIGHT_CLASS > (select avg(WEIGHT_CLASS) from OEHR_PRODUCT_INFORMATION) 
order by WEIGHT_CLASS desc, LIST_PRICE


/* Find all products whose LIST_PRICE is less than half of the average LIST_PRICE for their respective category. 
Find the average LIST_PRICE of each category, and compare it with individual Product's LIST_PRICE of the same category 
and select only those prodcuts whose list price is lower than half of average list price of its category. 
Return the PRODUCT_ID, PRODUCT_NAME, CATEGORY_ID, and LIST_PRICE. Order the result by highest product list price.*/


select c.PRODUCT_NAME,c.PRODUCT_ID,c.CATEGORY_ID,c.LIST_PRICE
from (select category_id, 0.5*avge as half
      from  (select CATEGORY_ID, avg(list_price) as avge
            from OEHR_PRODUCT_INFORMATION
            group by CATEGORY_ID )
      as b) as a
inner join OEHR_PRODUCT_INFORMATION as c
on a.CATEGORY_ID=c.CATEGORY_ID
where c.LIST_PRICE<a.half
order by c.LIST_PRICE desc


select category_id, 0.5*avge as half
      from  (select CATEGORY_ID, avg(list_price) as avge
            from OEHR_PRODUCT_INFORMATION
            group by CATEGORY_ID )as b


select LIST_PRICE 
from OEHR_PRODUCT_INFORMATION


/*Find the customer(s) with the longest combined first and last name and the customer(s) with the shortest 
combined first and last name. There can also be two or more customers with the largest or smallest name, not an issue. 
Your result for largest and smallest name should be displayed within one query, not two separate queries. 
Return CUSTOMER_ID, CUST_FIRST_NAME, CUST_LAST_NAME*/

select * from OEHR_CUSTOMERS

select max(length) as max
from(
select customer_id, con, len(con) as length
from (select customer_id, Concat(CUST_FIRST_NAME,CUST_LAST_NAME) as con
from OEHR_CUSTOMERS) as a) as b


select * 
from (
select customer_id, con, len(con) as length
from (select customer_id, Concat(CUST_FIRST_NAME,CUST_LAST_NAME) as con
from OEHR_CUSTOMERS) as a) as b
where length = (select max(length) as max
from(
select customer_id, con, len(con) as length
from (select customer_id, Concat(CUST_FIRST_NAME,CUST_LAST_NAME) as con
from OEHR_CUSTOMERS) as a) as b) and length =  (select min(length) as min
from(
select customer_id, con, len(con) as length
from (select customer_id, Concat(CUST_FIRST_NAME,CUST_LAST_NAME) as con
from OEHR_CUSTOMERS) as a) as b)


/*Show only the department ID with the 2nd highest average salary. 
Return Department ID and its corresponding average salary.*/


with cte2 as(
select*, dense_Rank() over(order by avg desc) as rank 
from (select a.department_id, avg(b.salary) as avg
from OEHR_DEPARTMENTS as a 
inner join OEHR_EMPLOYEES as b
on a.DEPARTMENT_ID = b.DEPARTMENT_ID
group by a.DEPARTMENT_ID) as b)
select * from cte2
where rank =2


/*Display all the details of the customers who have placed more than one order. 
Order the result by increasing customer_ID.*/
select *
from OEHR_CUSTOMERS
where customer_id in (
select a.customer_id
from OEHR_CUSTOMERS as a
inner join OEHR_ORDERS as b
on a.CUSTOMER_ID=b.CUSTOMER_ID
group by a.CUSTOMER_ID
having count(*) > 1)
order by CUSTOMER_ID 


/*Rank departments by sum of total salary each department takes. Order the result by highest salaries. 
Return Department name (not ID), total salary, and salary rank. Assign rank in such a way that if two department 
take same salaries, they should be assigned the same rank. If the department does not take any salary, 
it shoud be shown as a total_salary of 0.*/

/*There is a supplied ID in the catalog_URL column. Extract the supplied id from that column, based on the majority
rule (use the positions with which you can extract most of the supplied IDs correctly).
Compare the extracted supplied id with the original supplied ID column in the table. 
Return supplied ID original column and extracted column, but only show the rows where supplied ID original column does 
not match the supplier ID extracted column. Order the result by original supplied ID column in the increasing order.*/

/*Find only the employees who earn 2nd highest salaries in their departments. 
In case of a tie, display both employees. Return all columns. Order the result by increasing department ID, 
decreasing salary.
*/

Select *
from(
select *, DENSE_RANK() over(partition by department_id order by salary desc) as ranke
from OEHR_EMPLOYEES) as b
where ranke = 2
order by DEPARTMENT_ID, SALARY desc


/*Find customers whose CREDIT_LIMIT is higher than the average CREDIT_LIMIT for customers in their respective 
STATE_PROVINCE. 
Calculate the average credit limit of each state and compare it with each customer's credit limit who 
lives in the same state province. Make sure to not include the "Null" values in your STATE_PROVINCE column. 
Return CUSTOMER_ID, CUST_FIRST_NAME, CUST_LAST_NAME, CREDIT_LIMIT, STATE_PROVINCE. 
Make sure the result is ordered by customer ID in increasing order.*/

select * 
from OEHR_CUSTOMERS as a
inner join (
select state_province ,avg(credit_limit) as avge
from OEHR_CUSTOMERS
group by STATE_PROVINCE) as b
on a.STATE_PROVINCE = b.STATE_PROVINCE
where a.CREDIT_LIMIT > avge
order by CUSTOMER_ID 

/*Find the STATE_PROVINCE where the most customers live and list all customers residing in that state. 
Make sure to not include the "Null" values in your STATE_PROVINCE column. Return CUSTOMER_ID, CUST_FIRST_NAME, 
CUST_LAST_NAME, STATE_PROVINCE. Make sure the result is ordered by customer ID in increasing order.*/
Select CUST_FIRST_NAME,CUSTOMER_ID,CUST_LAST_NAME,STATE_PROVINCE
from(
) as a
inner join OEHR_CUSTOMERS as b
on a.STATE_PROVINCE = b.STATE_PROVINCE
order by CUSTOMER_ID 



with ctee as (
E
)
Select CUST_EMAIL
from ctee 
where ranke=1

select CUSTOMER_ID,CUST_LAST_NAME,CUST_FIRST_NAME,d.STATE_PROVINCE
from(
select *
from(
select *, DENSE_RANK() over(order by count desc) as ranke
from(
select STATE_PROVINCE,count(*) as count
from OEHR_CUSTOMERS
where state_province is not null
group by STATE_PROVINCE
) as b) as a
where ranke=1) as c
inner join OEHR_CUSTOMERS as d
on c.STATE_PROVINCE=d.STATE_PROVINCE
order by CUSTOMER_ID



/*Display the number of orders and number of customers for each country_ID. 
Create another column to show if the number of orders for each country are greater than the average number of 
orders per country. If yes, then write "Above Average" else write "Below Average". Order the result by increasing 
"number of customers" column.*/

Select country_id, avg(count(b.order_id))
from OEHR_CUSTOMERS as a
inner join OEHR_ORDERS as b
on a.CUSTOMER_ID=b.CUSTOMER_ID
group by COUNTRY_ID

Select *, COUNT(b.order_id) over(),count(a.CUSTOMER_ID) over() 
from OEHR_CUSTOMERS as a
inner join OEHR_ORDERS as b
on a.CUSTOMER_ID=b.CUSTOMER_ID



/*Rank departments by sum of total salary each department takes. Order the result by highest salaries. 
Return Department name (not ID), total salary, and salary rank. 
Assign rank in such a way that if two department take same salaries, they should be assigned the same rank. 
If the department does not take any salary, it shoud be shown as a total_salary of 0.*/

select *, rank() over(order by salaray desc)
from(
select a.DEPARTMENT_ID,sum(b.salary)  as salaray
from OEHR_DEPARTMENTS as a
left join OEHR_EMPLOYEES as b
on a.DEPARTMENT_ID=b.DEPARTMENT_ID
group by a.DEPARTMENT_ID) as d


/*Figure out which product is in the lowest quantity in each of the warehouse. 
Return all columns. In case of a tie, bring the one that has a higher product_ID.*/

select *
from OEHR_PRODUCT_INFORMATION

select *
from OEHR_WAREHOUSES 