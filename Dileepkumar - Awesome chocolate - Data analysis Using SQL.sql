SHOW DATABASES;

USE awesome_chocolates;

SHOW TABLES;

SELECT * FROM people;
SELECT * FROM products;
SELECT * FROM sales;

-- ---------------------------------------------------------------------------------------------------
-- 1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
SELECT * FROM sales s
WHERE s.amount>2000 AND s.amount<100;
-- ---------------------------------------------------------------------------------------------------
-- 2. How many shipments (sales) each of the sales persons had in the month of January 2022?
SELECT p.Salesperson, 
COUNT(*) AS 'Total_sales'
FROM sales s
JOIN people p ON (s.spid=p.spid)
WHERE YEAR(s.saleDate)=2022 AND MONTH(s.saleDate)=1
GROUP BY p.salesperson
ORDER BY p.salesperson;

-- ---------------------------------------------------------------------------------------------------
-- 3. Which product sells more boxes? Milk Bars or Eclairs?
SELECT prd.Product,
SUM(s.boxes) AS Sales_boxes
FROM sales s
JOIN products prd ON (s.pid=prd.pid)
WHERE prd.pid IN ('p01', 'p06')
GROUP BY prd.product
ORDER BY Sales_boxes DESC
LIMIT 1;
-- ---------------------------------------------------------------------------------------------------
-- 4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

SELECT prd.Product,
SUM(s.boxes) AS Sales_boxes
FROM sales s
JOIN products prd ON (s.pid=prd.pid)
WHERE prd.pid IN ('p01', 'p06')
AND s.saledate>='2022-02-01' AND s.saledate<='2022-02-07'
GROUP BY prd.product
ORDER BY Sales_boxes DESC
LIMIT 3;
-- ---------------------------------------------------------------------------------------------------
-- 5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?

SELECT *
FROM sales s
WHERE s.customers<100
AND s.boxes<100
AND WEEKDAY(s.saledate)=2;


-- ---------------------------------------------------------------------------------------------------
-- Hard level
-- ---------------------------------------------------------------------------------------------------
-- 1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
SELECT p.spid, p.Salesperson
FROM people p
WHERE p.spid IN (SELECT s.spid
FROM Sales s
WHERE s.saleDate >= '2022-01-01' AND s.saleDate <= '2022-01-07'
GROUP BY s.spid
HAVING COUNT(*)>1);

-- ---------------------------------------------------------------------------------------------------
-- 2. Which salespersons did not make any shipments in the first 7 days of January 2022?
SELECT p.spid, p.Salesperson
FROM people p
WHERE p.spid IN (
SELECT s.spid
FROM Sales s
WHERE s.saleDate BETWEEN '2022-01-01' AND '2022-01-07'
GROUP BY s.spid
HAVING COUNT(*)<1);
-- ---------------------------------------------------------------------------------------------------
-- 3. How many times we shipped more than 1,000 boxes in each month?
SELECT EXTRACT(MONTH FROM s.saledate) ,
COUNT(*) AS Shipment_count
FROM sales s
WHERE s.boxes>1000
GROUP BY EXTRACT(MONTH FROM s.saledate)
ORDER BY EXTRACT(MONTH FROM s.saledate);
-- ---------------------------------------------------------------------------------------------------
-- 4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
SELECT COUNT(DISTINCT EXTRACT(MONTH FROM s.saledate))
FROM sales s
JOIN products p ON s.pid=p.pid
JOIN geo g ON (s.geoid=g.geoid)
WHERE g.geo='New Zealand' AND p.product='After Nines';
-- ---------------------------------------------------------------------------------------------------
-- 5. India or Australia? Who buys more chocolate boxes on a monthly basis?

SELECT *
FROM sales s
WHERE s.geoid IN ('g1', 'g5');

SELECT geoid, geo, MAX(sales_month), MAX(Count_of_sales) max_counts
FROM (SELECT s.geoid,
g.geo,
MONTH(s.saledate) AS Sales_month,
SUM(s.boxes) AS Count_of_sales
FROM sales s, geo g
WHERE s.geoid=g.geoid AND s.geoid IN ('g1', 'g5')
GROUP BY s.geoid, Sales_month
-- HAVING COUNT(*)
ORDER BY s.geoid, Count_of_sales DESC) AS T
GROUP BY geoid
ORDER BY max_counts DESC
LIMIT 1;
-- ---------------------------------------------------------------------------------------------------