-- CREATING A DIRECTORY 
CREATE OR REPLACE DIRECTORY sales_directory as 'C:\sales_dir';

-- GRANTING READ PERMISSION TO SYS USER ON SALES_DIRECTORY
GRANT READ ON  DIRECTORY sales_directory TO sys;

-- CREATING AN EXTERNAL TABLE LINK TO THE CSV FILE
CREATE TABLE sales_data (ORDER_NUMBER NUMBER(8,2), QUANTITY_ORDERED NUMBER (6,1), PRICE_EACH NUMBER(10,3),ORDER_LINE_NUMBER NUMBER(7,3)
 , SALES VARCHAR(30) ,ORDER_DATE VARCHAR(40) ,STATUS VARCHAR(30) ,QTR_ID VARCHAR(30),MONTH_ID NUMBER(5),
 YEAR_ID VARCHAR(30),PRODUCT_LINE VARCHAR(40) ,MSRP VARCHAR(30) ,PRODUCT_CODE VARCHAR(30),CUSTOMER_NAME VARCHAR(40),PHONE VARCHAR(40),
 ADDRESS_LINE1 VARCHAR(40),ADDRESS_LINE2 VARCHAR(40),CITY VARCHAR(35),STATE VARCHAR(30),POSTAL_CODE VARCHAR(25),COUNTRY VARCHAR(25),
 TERRITORY VARCHAR (30),CONTACT_LAST_NAME VARCHAR(30),CONTACT_FIRST_NAME VARCHAR(40),DEAL_SIZE VARCHAR(30))
    ORGANIZATION EXTERNAL ( TYPE ORACLE_LOADER
                            DEFAULT DIRECTORY sales_directory
                            ACCESS PARAMETERS
                            (FIELDS TERMINATED BY ",")
                            LOCATION ('sales_data.csv'))
                            REJECT LIMIT 99;
                            
-- selecting data from the external table
SELECT * FROM sales_data;

-- copy external table data into an internal table
CREATE TABLE sales_internal AS SELECT * FROM sales_data;

-- selectting everything from internal data
select * from sales_internal;


-- 1.What is the total sales revenue for each product line?
SELECT PRODUCT_LINE, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY PRODUCT_LINE;

--2.What is the average a ordered per product line?
SELECT PRODUCT_LINE, ROUND(AVG(QUANTITY_ORDERED),2) AS AVG_QUANTITY_ORDERED
FROM sales_internal
GROUP BY PRODUCT_LINE;

--3.Which product has the highest price per unit (PRICE_EACH)?

SELECT PRODUCT_LINE, PRODUCT_CODE, max (PRICE_EACH) AS MAX_PRICE_PER_UNIT
FROM sales_internal
GROUP BY PRODUCT_LINE,PRODUCT_CODE;

--4.What is the total sales revenue for each year?
SELECT YEAR_ID, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY YEAR_ID
ORDER BY YEAR_ID DESC;

--5.What is the average sales revenue per quarter (QTR_ID) for each year?
SELECT YEAR_ID, QTR_ID, ROUND(AVG(SALES),2) AS AVG_REVENUE_PER_QUARTER
FROM sales_internal
GROUP BY YEAR_ID, QTR_ID;

--6.Which customers have placed the most orders (ORDER_NUMBER) in descending order?
SELECT CUSTOMER_NAME, COUNT(ORDER_NUMBER) AS NUM_ORDERS
FROM sales_internal
GROUP BY CUSTOMER_NAME
ORDER BY NUM_ORDERS DESC;

--7.What is the total sales revenue for each country?
SELECT COUNTRY, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY COUNTRY;

--8.What is the most common order status (STATUS) and its count?
SELECT STATUS, COUNT(*) AS STATUS_COUNT
FROM sales_internal
GROUP BY STATUS
ORDER BY STATUS_COUNT DESC
FETCH FIRST 1 ROW ONLY;

--9.What is the total sales revenue for each deal size (DEAL_SIZE)?
SELECT DEAL_SIZE, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY DEAL_SIZE;

--10.What is the total sales revenue for each product line and year?
SELECT PRODUCT_LINE, YEAR_ID, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY PRODUCT_LINE, YEAR_ID;

--11.What is the average quantity ordered per product line and quarter (QTR_ID)?
SELECT PRODUCT_LINE, QTR_ID, ROUND(AVG(QUANTITY_ORDERED),2) AS AVG_QUANTITY_ORDERED
FROM sales_internal
GROUP BY PRODUCT_LINE, QTR_ID;

--GROUPBY

--12.What is the average sales revenue per month (MONTH_ID) for each year and product line?
SELECT YEAR_ID, PRODUCT_LINE, MONTH_ID, ROUND(AVG(SALES),2) AS AVG_REVENUE_PER_MONTH
FROM sales_internal
GROUP BY YEAR_ID, PRODUCT_LINE, MONTH_ID;

-- 13.Which customers have placed orders in multiple countries,
--and how many orders have they placed in each country?
SELECT CUSTOMER_NAME, COUNTRY, COUNT(DISTINCT ORDER_NUMBER) AS NUM_ORDERS
FROM sales_internal GROUP BY CUSTOMER_NAME, COUNTRY ;

--14.What is the total sales revenue for each product line and quarter (QTR_ID)
--for a specific year (e.g., 2005)?
SELECT YEAR_ID, PRODUCT_LINE, QTR_ID, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
WHERE YEAR_ID = 2005
GROUP BY YEAR_ID, PRODUCT_LINE, QTR_ID;

--15.Which product line has the highest average price per unit (PRICE_EACH) for a specific year (e.g., 2004)?
SELECT YEAR_ID, PRODUCT_LINE, ROUND(AVG(PRICE_EACH),3) AS AVG_PRICE_PER_UNIT
FROM sales_internal
WHERE YEAR_ID = 2004
GROUP BY YEAR_ID, PRODUCT_LINE
ORDER BY AVG_PRICE_PER_UNIT DESC;

-- 16.What is the total sales revenue for each year and deal size (DEAL_SIZE)?
SELECT YEAR_ID, DEAL_SIZE, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY YEAR_ID, DEAL_SIZE;

-- 17.What is the total number of orders (ORDERNUMBER) in the dataset?
SELECT COUNT(*) AS TOTAL_ORDERS
FROM sales_internal;

-- 18.What is the highest sales revenue (SALES) in the dataset?
SELECT MAX(SALES) AS HIGHEST_REVENUE
FROM sales_internal;

--19.What is the average manufacturer's suggested retail price (MSRP) per product line?**
SELECT PRODUCT_LINE, ROUND(AVG(MSRP),2) AS AVG_MSRP
FROM sales_internal
GROUP BY PRODUCT_LINE;

--20.What is the total quantity ordered (QUANTITY_ORDERED) for each year, ordered by year in descending order?
SELECT YEAR_ID, SUM(QUANTITY_ORDERED) AS TOTAL_QUANTITY_ORDERED
FROM sales_internal
GROUP BY YEAR_ID
ORDER BY YEAR_ID DESC;

-- 21.What is the total revenue for each status (STATUS) category?,total revenue ascending order?
SELECT STATUS, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY STATUS
ORDER BY STATUS ASC;
-- 22.What is the average price per unit (PRICE_EACH) for each product line
--with a price greater than $50?
SELECT PRODUCT_LINE, ROUND(AVG(PRICE_EACH),3) AS AVG_PRICE_PER_UNIT
FROM sales_internal
WHERE PRICE_EACH > 50
GROUP BY PRODUCT_LINE;

-- 23.Which year had the highest total sales revenue, and what was the revenue amount?
SELECT YEAR_ID, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY YEAR_ID
ORDER BY TOTAL_REVENUE DESC
FETCH FIRST 1 ROW ONLY;

-- 24.What is the total sales revenue for each city and state combination?
SELECT CITY, STATE, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY CITY, STATE;

-- 25.What is the total quantity ordered (QUANTITY_ORDERED) for each product line,
--sorted by quantity in descending order?
SELECT PRODUCT_LINE, SUM(QUANTITY_ORDERED) AS TOTAL_QUANTITY_ORDERED
FROM sales_internal
GROUP BY PRODUCT_LINE
ORDER BY TOTAL_QUANTITY_ORDERED DESC;\

--26.What is the highest total sales revenue for each product line?
SELECT PRODUCT_LINE, MAX(TOTAL_REVENUE) AS HIGHEST_REVENUE
FROM (
    SELECT PRODUCT_LINE, SUM(SALES) AS TOTAL_REVENUE
    FROM sales_internal
    GROUP BY PRODUCT_LINE
)
GROUP BY PRODUCT_LINE;

--27.What is the average sales revenue every month (based on ORDER_DATE)?
SELECT ORDER_DATE_1, ROUND(AVG(AVG_REVENUE_PER_DAY)) as AVG_REVENUE_PER_DAY from(
SELECT CASE 
    WHEN INSTR(ORDER_DATE, '/') = 2 THEN SUBSTR(ORDER_DATE, 1, 1)
    ELSE SUBSTR(ORDER_DATE, 1, 2)
    END AS ORDER_DATE_1, (SALES) AS AVG_REVENUE_PER_DAY
FROM sales_internal)
GROUP BY ORDER_DATE_1;

-- 28.What is the most common shipping territory (TERRITORY) and its count?
SELECT TERRITORY, COUNT(*) AS TERRITORY_COUNT
FROM sales_internal
GROUP BY TERRITORY
ORDER BY TERRITORY_COUNT DESC
FETCH FIRST 1 ROW ONLY;

-- 29.What is the total quantity ordered (QUANTITY_ORDERED) 
--for each year, month, and product line combination?
SELECT YEAR_ID, MONTH_ID, PRODUCT_LINE, SUM(QUANTITY_ORDERED) AS TOTAL_QUANTITY_ORDERED
FROM sales_internal
GROUP BY YEAR_ID, MONTH_ID, PRODUCT_LINE;

-- 30.What is the most common shipping territory (TERRITORY) and its count?
SELECT TERRITORY, COUNT(*) AS TERRITORY_COUNT
FROM sales_internal
GROUP BY TERRITORY
ORDER BY TERRITORY_COUNT DESC
FETCH FIRST 1 ROW ONLY;

--31.What is the total sales revenue for each month (MONTH_ID) in descending order of revenue?
SELECT MONTH_ID, SUM(SALES) AS TOTAL_REVENUE
FROM sales_internal
GROUP BY MONTH_ID
ORDER BY TOTAL_REVENUE DESC;

--32 What is the Monthly Sales Trend?

SELECT YEAR_ID, MONTH_ID, SUM(SALES) AS MONTHLY_REVENUE
FROM sales_internal
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID;

-- 33 What products have the highest sales growth:
WITH product_sales AS (
    SELECT YEAR_ID, PRODUCT_LINE, SUM(SALES) AS TOTAL_SALES
    FROM sales_internal
    GROUP BY YEAR_ID, PRODUCT_LINE
)

SELECT 
    ps1.YEAR_ID,
    ps1.PRODUCT_LINE,
    (ps1.TOTAL_SALES - ps2.TOTAL_SALES) AS SALES_GROWTH
FROM product_sales ps1
JOIN product_sales ps2
    ON ps1.PRODUCT_LINE = ps2.PRODUCT_LINE
    AND ps1.YEAR_ID = ps2.YEAR_ID + 1
ORDER BY YEAR_ID, PRODUCT_LINE, SALES_GROWTH DESC;

--34 What is the average order value?:
 SELECT ROUND(AVG(SALES),3) AS AVERAGE_ORDER_VALUE
FROM sales_internal;   





