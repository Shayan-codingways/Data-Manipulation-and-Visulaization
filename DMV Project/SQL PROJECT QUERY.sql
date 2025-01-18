--------------------------------------------------------------------------------------------
-- Only Products table require cleaning as it only contains null values 
Select *
from Products

Select *
from Cleaned_Products

Select *
from Calendars

Select *
from Sales

Select *
from Customers
------------------------------------------------------------------------------------------

-- Sub-category / product-category already has NULL
-- Product-color has missing values 
-- Product desciption, product_model name, product line 
/*If there are null or missing values in any of the columns in your dataset and if the column type is string,
replace null value/missing values with ‘NULL’. */

SELECT 
    ProductKey, -- all okay
    ProductItemCode, -- all okay
    Product_Name,    -- all okay
    ISNULL(Sub_Category, 'NULL') AS Sub_Category, -- convert to string 'NULL'  if NULL
    ISNULL(Product_Category, 'NULL') AS Product_Category, -- convert to string 'NULL'  if NULL
    --ISNULL(Product_Color, 'NULL') AS Product_Color,  
    CASE  
    WHEN Product_Color IS NULL THEN 'NULL' -- Check for NULL 
    WHEN Product_Color = 'NA' THEN 'NULL' -- Convert 'NA' to NULL
    ELSE Product_Color -- Keep other valid values as is
    END AS Product_Color,

    -- Handle Product_Size as text, converting numbers to categories
    CASE 
        WHEN CAST(Product_Size AS VARCHAR(MAX)) IN ('L', 'XL', 'S', 'M') THEN Product_Size -- Retain valid categories
        WHEN TRY_CAST(CAST(Product_Size AS VARCHAR(MAX)) AS INT) BETWEEN 30 AND 40 THEN 'S' -- Map numeric ranges to categories
        WHEN TRY_CAST(CAST(Product_Size AS VARCHAR(MAX)) AS INT) BETWEEN 41 AND 50 THEN 'M'
        WHEN TRY_CAST(CAST(Product_Size AS VARCHAR(MAX)) AS INT) BETWEEN 51 AND 60 THEN 'L'
        WHEN TRY_CAST(CAST(Product_Size AS VARCHAR(MAX)) AS INT) > 61 THEN 'XL'
        ELSE 'NULL' -- Replace invalid or non-numeric values with 'NULL'
    END AS Product_Size,
    ISNULL(Product_Line, 'NULL') AS Product_Line,
    ISNULL(Product_Model_Name, 'NULL') AS Product_Model_Name,
    ISNULL(Product_Description, 'NULL') AS Product_Description,
    Product_Status
-- INTO Cleaned_Products
FROM Products;
-------------------------------------------------------------------------------------------------------

-- we can join cutomer table with sales
-- we can join product table with sales
-- and can join these 3 tables together

-- Joining Cleaned_products with Sales
SELECT p.*,o.SalesOrderNumber,o.CustomerKey,o.SalesAmount,o.OrderDateKey,o.DueDateKey,o.ShipDateKey
INTO #Product_Sales
FROM Sales o
INNER JOIN Cleaned_Products p ON o.ProductKey = p.ProductKey;

Select * from #Product_Sales

-- Joining Customer and Sales
SELECT p.*,o.SalesOrderNumber,o.ProductKey,o.SalesAmount,o.OrderDateKey,o.DueDateKey,o.ShipDateKey
INTO #Customer_Sales
FROM Sales o
INNER JOIN Customers p ON o.CustomerKey = p.CustomerKey;

Select * from #Customer_Sales

--Joining Customer, product and Sales
-- Joining Customer, Product and Sales
select p.*,c.First_Name,c.Last_Name,c.Full_Name,c.Gender,c.DateFirstPurchase,c.Customer_City
into #Product_Customer_Sale
from #Product_Sales as p
inner join Customers as c
on p.CustomerKey=c.CustomerKey

select * from #Product_Customer_Sale
Select * from Calendars

/*2019 02 29 not present in calendars 2019 wasn't leap but orders taken data issue*/
select distinct OrderDateKey
from #Product_Customer_Sale
where OrderDateKey not in (select datekey from calendars)

Select * 
from #Product_Customer_Sale
where orderDateKey = (select distinct OrderDateKey
from #Product_Customer_Sale
where OrderDateKey not in (select datekey from calendars))

-- Joined All Data
Select *
--into all_data
from (select p.*,c.DateKey,c.Date,c.Day,c.Month,c.MonthNo,c.MonthShort,c.Quarter,c.Year
from #Product_Customer_Sale as p
left join Calendars as c
on p.OrderDateKey=c.DateKey) as g
where g.ShipDateKey != '20190229' and g.DueDateKey != '20190229' and g.OrderDateKey != '20190229'

Select * from all_data



---------------------------------------   KPIS  -----------------------------------------------------
--  Creating KPIs
-- total Sales

select round(sum(SalesAmount),2) as total_Sales
from all_data

select round(avg(SalesAmount),2) as avg_Sales
from all_data

-- Total Orders
SELECT COUNT(DISTINCT SalesOrderNumber) AS Total_Orders
FROM all_data;

------------------------------------------------------------------------------------------------------------------------------
--  Total Orders and Sales by category 
SELECT Product_Category, COUNT(DISTINCT SalesOrderNumber) AS Total_Orders, sum(Salesamount) as Sales_bycategory
FROM all_data
group by Product_Category

--  Total Orders and Sales by Sub-category 
SELECT Sub_Category, COUNT(DISTINCT SalesOrderNumber) AS Total_Orders, sum(Salesamount) as Sales_bycategory
FROM all_data
group by Sub_Category

--  Total Orders and Sales by Day
SELECT Day, COUNT(DISTINCT SalesOrderNumber) AS Total_Orders, sum(Salesamount) as sales_Day
FROM all_data
group by Day


select * from all_data
-- top 3 Products
SELECT top 10  Product_Name, COUNT(DISTINCT SalesOrderNumber) AS Total_Orders, sum(Salesamount) as Product_Sales
--into top10_products
FROM all_data
group by Product_Name
order by Product_Sales desc, Total_Orders desc


-- Sales and total orders By Customer
SELECT Customerkey, COUNT(DISTINCT SalesOrderNumber) AS Total_Orders, sum(Salesamount) as Product_Sales
--into sales_totalorder_percustomer
FROM all_data
group by CustomerKey
order by Product_Sales desc, Total_Orders desc
-------------------------------------------------------------------------------------------------------------------------------
/*
Ensure Proper Formatting for Conversion:
OrderDateKey is often stored as an integer (e.g., 20240228) or a string of numbers.
Directly casting such a value to DATE may cause errors if SQL doesn't recognize the format.
Casting it to CHAR(8) ensures it is treated as a valid 8-character string ('20240228'), which SQL can reliably convert to a DATE.
*/

-- Customer timespan
SELECT 
    CustomerKey,
    DATEDIFF(
        DAY, 
        MIN(CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE)), 
        MAX(CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE))
    ) AS DaysSinceFirstPurchase
FROM all_data
GROUP BY CustomerKey
order by DaysSinceFirstPurchase desc
-------------------------------------------------------------------------------------------------------------------------=

--                                 Sales Analalysis within particular Timeframe

------------------------------------------------------------------------------------------------------------------------------------
-- Sales Trend Analysis  KPI 2
select * from all_data


-- yearly and quarter sales and growth. 
SELECT 
        year,quarter,
        SUM(SalesAmount) AS TotalSales
FROM all_data
GROUP BY quarter,year
order by year,quarter


-- Quarterly growth rate span over all 3 years. 
SELECT 
    year,quarter,
    TotalSales,
    LAG(TotalSales) OVER (ORDER BY year,quarter) AS PreviousMonthSales,
    (TotalSales - LAG(TotalSales) OVER (ORDER BY Year,quarter)) * 100.0 / LAG(TotalSales) OVER (ORDER BY Year,quarter) AS GrowthRate
--into growth_rate_quarterly
FROM (
    SELECT 
        year,quarter,
        SUM(SalesAmount) AS TotalSales
    FROM all_data
    GROUP BY year,quarter
)  as yearly_Sales;


-- monthly growth rate for every year!
with monthly_Sales as(
 SELECT 
        year, month,monthno,
        SUM(SalesAmount) AS TotalSales
 FROM all_data
 --where year=2019
 GROUP BY year, month,monthno
)


SELECT 
    year, month,monthno,
    TotalSales,
    LAG(TotalSales) OVER (ORDER BY year, monthno) AS PreviousMonthSales,
    (TotalSales - LAG(TotalSales) OVER (ORDER BY year, monthno)) * 100.0 / LAG(TotalSales) OVER (ORDER BY year, monthno) AS GrowthRate
-- into growth_rate_yearly
FROM monthly_Sales
--order by MonthNo
---------------------------------------------------------------------------------------------------------------------------------------------

--                                              CLV WORKING

---------------------------------------------------------------------------------------------------------------------------
-- CLV  /*Average Order*/
Select * from all_data

 /*purchase value (eik order aaustan kitne ka hai)  = total sales/total orders*/ 
select sum(SalesAmount)/count(SalesOrderNumber)
from all_data

select avg(SalesAmount)
from all_data

/* order/customer -->  avg*/ 
select count(salesOrderNumber)/count(Distinct CustomerKey)
from all_data;

/*Average customer life span (Sum of cutomer lifespans / no of customers)*/
with lifeespan as(
SELECT 
    CustomerKey,
    DATEDIFF(
        DAY, 
        MIN(CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE)), 
        MAX(CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE))
    ) AS Lifespan
FROM all_data
GROUP BY CustomerKey)


select (sum(lifespan)/count(distinct CustomerKey))
from lifeespan -- avg yearly customer lifespan


-- CLV actually calculated
-- avg(sale on order) * avg orders by a customer * avg lifespan of a customer in years
select (select avg(SalesAmount)) * (select count(salesOrderNumber)/count(Distinct CustomerKey)) * 
      (select (sum(lifespan)/count(distinct CustomerKey))/365.0
       from (SELECT 
            CustomerKey,
            DATEDIFF(
            DAY, 
            MIN(CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE)), 
            MAX(CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE))
            ) AS Lifespan
            FROM all_data
            GROUP BY CustomerKey) as b) as CLV
--into customer_revenue_lifespan
from all_data;


-- lifespan avg is 83 days, 

-- clv 260.04 means expected revenue from a new coming customer over a expected lifespan.
----------------------------------------------------------------------------------------------------------------------------



SELECT @@SERVERNAME AS ServerName;

























