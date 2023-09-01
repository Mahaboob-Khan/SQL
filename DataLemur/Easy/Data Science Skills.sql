/*
Data Science Skills [LinkedIn SQL Interview Question]
======================================================
Learnings from the problem:
	1. Aplying CASE WHEN along with SUM to identify the job applicants having the 3 skills mentioned
	2. Filtering the results using subquery to identify the actual job applicants having all 3 skills
	
Order of Execution:
	=> FROM SubQuery ( FROM => GROUP BY => SELECT ) => WHERE => SELECT => ORDER BY
*/
SELECT
	candidate_id
FROM (
		SELECT
			 candidate_id
			,SUM(CASE WHEN skill IN ('Python', 'Tableau', 'PostgreSQL') THEN 1 ELSE 0 END) AS num
		FROM
			candidates
		GROUP BY
			candidate_id) AS Datascience
WHERE
	num = 3
ORDER BY
	candidate_id;