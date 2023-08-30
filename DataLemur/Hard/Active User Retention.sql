/*
	 Active User Retention [Facebook SQL Interview Question]
	*=======================================================*
	Learning from the problem:
		1. Get the current month users data using WHERE & DATE_PART() and create CTE
		2. Applying JOIN between main user_actions table & CTE of current month users to find the active users
		3. Applying the GROUP BY to find the no of active users by month
	
	Order of Execution:
		=> FROM & INNER JOIN (CTE => FROM => WHERE => SELECT) => WHERE => GROUP BY => SELECT
*/
WITH cur_month_users AS (
  SELECT DISTINCT
     user_id
    ,DATE_PART('MONTH', event_date) AS event_month
    ,DATE_PART('YEAR', event_date) AS event_year
  FROM
    user_actions
  WHERE
    DATE_PART('YEAR', event_date) = 2022 AND
    DATE_PART('MONTH', event_date) = 7
)
SELECT 
   c.event_month as mth
  ,COUNT(DISTINCT c.user_id) AS monthly_active_users
FROM
  user_actions p
INNER JOIN
  cur_month_users c
ON p.user_id = c.user_id AND
   DATE_PART('YEAR', p.event_date) = c.event_year
WHERE
   DATE_PART('MONTH', p.event_date) = c.event_month - 1
GROUP BY c.event_month;