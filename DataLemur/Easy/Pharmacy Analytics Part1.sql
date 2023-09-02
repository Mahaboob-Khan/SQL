/*
Pharmacy Analytics (Part 1) [CVS Health SQL Interview Question]
================================================================
Learnings from the problem:
	1. Calculating the Total profit of each drug using the mathematical formula total_sales - cost_of_goods_sold
	2. Arranging the drugs in the order from highest profit to lowest profit
	3. SELECTing only 3 highest profit drugs using LIMIT
	
Order of Execution:
	=> FROM => SELECT => ORDER BY => LIMIT
*/
SELECT
   drug
  ,total_sales - cogs AS total_profit
FROM
  pharmacy_sales
ORDER BY
  total_profit DESC
LIMIT 3;