-- Selected the list of unique products sold on each date as 
-- DISTINCT keyword is not supported on MS SQL
WITH uniq_prod AS (
  SELECT DISTINCT 
		sell_date,
		product
  FROM Products )
SELECT
  sell_date,
  COUNT(product) AS num_sold, 
  STRING_AGG(product, ', ') WITHIN GROUP (ORDER BY product) AS product_list
FROM uniq_prod
GROUP BY sell_date
ORDER BY sell_date;

-- Snowflake
SELECT
  sell_date,
  COUNT( DISTINCT product) AS num_sold,
  LISTAGG(DISTINCT product, ', ') WITHIN GROUP (ORDER BY product) AS product_list
FROM Products
GROUP BY sell_date
ORDER BY sell_date;