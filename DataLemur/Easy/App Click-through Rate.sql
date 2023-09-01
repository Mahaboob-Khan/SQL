/*
App Click-through Rate (CTR) [Facebook SQL Interview Question]
==============================================================
Learnings from the problem:
	1. Filtering the data using WHERE & DATE_PART() for year 2022 data
	2. Applying GROUP BY to group the data by each app id
	3. Applying the CASE WHEN along with SUM to identify the no of Clicks & Impressions and then calculate the CTR
	4. Apply the ROUND() to round off the CTR value to 2 decimal digits
*/
SELECT 
   app_id
  ,ROUND( 
		100.0 * SUM(CASE WHEN event_type='click' THEN 1 ElSE 0 END) / SUM(CASE WHEN event_type='impression' THEN 1 ElSE 0 END)
		,2
		) AS ctr
FROM
  events
WHERE
  DATE_PART('YEAR', timestamp) = 2022
GROUP BY
  app_id;