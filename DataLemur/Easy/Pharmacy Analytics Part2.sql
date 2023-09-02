/*
Pharmacy Analytics (Part 2) [CVS Health SQL Interview Question]
===============================================================
Learnings from the problem:
	1. filtering the data using WHERE clause condition to identify the loss making drugs
	2. Applying the GROUP BY by manufacturer to identify the no of drugs making loss & total loss
	3. Arranging the results by highest loss making drug manufacturers on top
	
Order of Execution:
	=> FROM => WHERE => GROUP BY => SELECT => ORDER BY
*/
SELECT
   manufacturer
  ,COUNT(drug) AS drug_count
  ,SUM(cogs - total_sales) AS total_loss
FROM
  pharmacy_sales
WHERE
  cogs > total_sales
GROUP BY
  manufacturer
ORDER BY
  total_loss DESC;