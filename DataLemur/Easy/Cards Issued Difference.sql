/*
Cards Issued Difference [JPMorgan Chase SQL Interview Question]
===============================================================
Learnings from the problem:
	1. Applying the GROUP BY to find 
		the difference in the number of issued cards between the month with the highest issuance cards and 
		the lowest issuance.
	2. Arranging the results based on the largest difference
	
Order of Execution:
	=> FROM => GROUP BY => SELECT => ORDER BY
*/
SELECT
   card_name
  ,MAX(issued_amount) - MIN(issued_amount) AS difference
FROM
	monthly_cards_issued
GROUP BY
  card_name
ORDER BY
  difference DESC;