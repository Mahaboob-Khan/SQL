/*
	Learnings from the challege:
		1. SELECT...FROM data from table
		2. Applying WHERE clause with DATE_PART() to filter the records to YEAR=2022
		3. Applying GROUP BY clause to calculate the gross i.e. aggregare SUM() at product level for each category
		4. Applying RANK() window function to rank the gross of products with in each category
		5. Defining CTE or Subquery to find the top 2 highest-grossing products of each category
		
	Order of Execution:
		=> FROM CTE( FROM => WHERE => GROUP BY => RANK() => SELECT ) => WHERE => SELECT
*/
WITH prod_rank AS (
	SELECT
		 category
		,product
		,SUM(spend) AS total_spend
		,RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS rnk
	FROM
		product_spend
	WHERE
		DATE_PART('YEAR', transaction_date)=2022
	GROUP BY category, product
)
SELECT
	 category
	,product
	,total_spend
FROM
	prod_rank
WHERE
	rnk <= 2;