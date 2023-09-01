/*
Duplicate Job Listings [Linkedin SQL Interview Question]
========================================================
Learnings from the problem:
	1. Applying the GROUP BY on specific columns of table to identify the duplicate jobs and company_id
	2. Usage of HAVING to filter the aggregated results i.e. GROUP BY
	3. Using Subquery to find the no of companies posted the duplicate job listings
	
Order of Execution:
	=> Inner query/Sub query i.e. Dup ( FROM => GROUP BY => HAVING => SELECT)=> SELECT DISTINCT
*/
SELECT 
	COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
		SELECT  company_id
				,title
				,description
				,COUNT(*)
		FROM 
			job_listings
		GROUP BY 
			company_id
			,title
			,description
		HAVING
			COUNT(*) > 1
	) AS Dup;