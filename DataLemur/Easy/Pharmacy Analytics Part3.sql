/*
Pharmacy Analytics (Part 3) [CVS Health SQL Interview Question]
===============================================================
Learnings from the problem:
	1. Applying GROUP BY at manufacturer level to identify the total sales of each manufacturer
	2. Dividing the SUM of total sales of each manufacturer by 1M to report the sales in Millions
	3. Using ROUND() function for rounding off the total sales to nearest number of millions
	4. Formating the results to match the requested format using concatenate operator ||
	5. Arraging the results in descending order of total sales.
		In case of any duplicates, sorting them alphabetically by the manufacturer name.
Order of Execution:
	=> FROM => GROUP BY => SELECT => ORDER BY
*/
SELECT
   manufacturer
  ,'$'||ROUND(SUM(total_sales) / 1000000)||' million' AS sale
FROM
  pharmacy_sales
GROUP BY
  manufacturer
ORDER BY
   SUM(total_sales) DESC
  ,manufacturer;