/*
Histogram of Tweets [Twitter SQL Interview Question]
=====================================================
Learnings from the problem
	1. Filtering the tweets data to 2022 using WHERE & BETWEEN...AND
	2. GROUP BY - grouping the tweets by user to find the no of tweets by each user in 2022
	3. Creating a CTE/Subquery using the above to operations
	4. Appying the GROUP BY on CTE to find the no of users falling into tweets count
	
Order of Execution:
	==> FROM CTE (FROM => WHERE => GROUP BY => SELECT)=> GROUP BY => SELECT
*/
WITH cte_user AS(
	SELECT 
		 user_id
		,COUNT(tweet_id) AS tweet_num
	  FROM
		tweets
	 WHERE
		tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
	GROUP BY user_id)

SELECT
	 tweet_num AS tweet_bucket
	,COUNT(user_id) AS user_num
FROM cte_user
GROUP BY tweet_num;