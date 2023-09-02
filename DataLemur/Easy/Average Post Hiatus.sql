/*
Average Post Hiatus (Part 1) [Facebook SQL Interview Question]
==============================================================
Learnings from the problem:
	1. Filtering the data to Year 2021 using WHERE
	2. Applying GROUP BY by user_id to identify the latest & earliest post date of 2021
	3. Applying CAST() to explicitly convert the timestamp to date datatype
	4. Usage of HAVING for filtering the aggregated result to identify the users having more than a difference in
		their latest & earliest post on Facebook
		
Order of Execution:
	=> FROM => WHERE => GROUP BY => HAVING => SELECT
*/
SELECT
   user_id
  ,CAST(MAX(post_date) AS DATE) - CAST(MIN(post_date) AS DATE) AS days_between
FROM posts
WHERE DATE_PART('YEAR', post_date) = 2021
GROUP BY user_id
HAVING COUNT(*) > 1;