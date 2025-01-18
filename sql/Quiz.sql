
--QS 1)
select city, count(*)
from OEHR_CUSTOMERS
where CITY like '%ss%' AND city NOT Like '%t%' 
group by city

--QS 2)
select ORDER_MODE,ORDER_STATUS, count(*)
from OEHR_ORDERS
where ((lower(ORDER_MODE) = 'direct') and (order_status = 1 or ORDER_STATUS = 0))
      OR (ORDER_TOTAL > 2000) 
group by ORDER_MODE,ORDER_STATUS

-- QS 3)
select top 2 *
from OEHR_EMPLOYEES
where (DEPARTMENT_ID = 90) and (salary > 5000 and salary < 30000)
order by salary desc

select *
from OEHR_EMPLOYEES

-- Qs 4)
select department_id, count(department_id) as count, sum(Salary), avg(salary)
from OEHR_EMPLOYEES
where DEPARTMENT_ID is null or DEPARTMENT_ID in (90,100,110,120,140) 
group by DEPARTMENT_ID

