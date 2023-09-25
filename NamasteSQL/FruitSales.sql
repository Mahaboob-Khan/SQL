-- Using CTE for each fruit type and JOIN
WITH apple_sales AS (
	SELECT sales_date, sold_num
	  FROM NamasteSQL.Sales_tbl
	 WHERE fruits = 'apples'
),
orange_sales AS (
	SELECT sales_date, sold_num
	  FROM NamasteSQL.Sales_tbl
	 WHERE fruits = 'oranges'
)
SELECT a.sales_date, a.sold_num - o.sold_num AS diff
  FROM apple_sales a 
  LEFT JOIN orange_sales o
    ON a.sales_date = o.sales_date
 ORDER BY a.sales_date;

-- Using CASE WHEN to generate the Fruit Sold_num as columns and
-- CTE, GROUP BY for difference calculation 
WITH fruit_Sales AS (
SELECT  sales_date
	   ,CASE WHEN fruits = 'apples' THEN sold_num ELSE 0 END AS apple_sales
	   ,CASE WHEN fruits = 'oranges' THEN sold_num ELSE 0 END AS orange_sales
FROM NamasteSQL.Sales_tbl
)
SELECT sales_date, SUM(apple_sales) - SUM(orange_sales) AS diff
FROM fruit_Sales
GROUP BY sales_date
ORDER BY sales_date;

-- Simple CASE WHEN & GROUP BY
SELECT Sales_date
	,SUM(CASE 
			WHEN fruits = 'apples' THEN sold_num
			WHEN fruits = 'oranges' THEN -sold_num
		 END) AS diff
FROM NamasteSQL.Sales_tbl
GROUP BY sales_date
ORDER BY sales_date;