/*
Second Day Confirmation [TikTok SQL Interview Question]
========================================================
Learning from the problem:
	1. JOINing multiple tables based on a common key
	2. Filtering the combined data using WHERE clause to identify the users 
	   who did not confirm their sign-up on the first day, but confirmed on the second day.
	   
Order of Execution:
	=> FROM & INNER JOIN => WHERE => SELECT
*/
SELECT
  e.user_id
FROM
  emails e
INNER JOIN
  texts t
ON e.email_id = t.email_id
WHERE
  t.signup_action = 'Confirmed' AND
  CAST(t.action_date AS DATE) - CAST(e.signup_date AS DATE) = 1;