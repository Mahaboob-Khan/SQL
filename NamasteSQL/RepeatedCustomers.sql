-- Method1 - Using JOIN & GROUP BY
WITH first_order AS (
  SELECT
     customer_id
	,MIN(order_date) AS first_order_date
  FROM NamasteSQL.Orders
  GROUP BY customer_id
)
SELECT
   o.order_date
  ,COUNT(o.customer_id) AS total_customers
  ,SUM( CASE WHEN o.order_date = f.first_order_date THEN 1 ELSE 0 END ) AS new_customers
  ,SUM( CASE WHEN o.order_date > f.first_order_date THEN 1 ELSE 0 END ) AS repeated_customers
FROM NamasteSQL.Orders o
LEFT JOIN first_order f
ON o.customer_id = f.customer_id
GROUP BY o.order_date;


-- Method2 - Using ROW_NUMBER() & GROUP BY
WITH order_entry AS (
  SELECT
     customer_id
    ,order_date
    ,ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS order_no
  FROM NamasteSQL.Orders
)
SELECT
   order_date
  ,COUNT( customer_id ) AS total_customers
  ,SUM( CASE WHEN order_no = 1 THEN 1 ELSE 0 END ) AS new_customers
  ,SUM( CASE WHEN order_no > 1 THEN 1 ELSE 0 END ) AS repeated_customers
FROM order_entry
GROUP BY order_date;