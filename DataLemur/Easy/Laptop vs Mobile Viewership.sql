/*
Laptop vs. Mobile Viewership [New York Times SQL Interview Question]
====================================================================
Learnings from the problem:
	1. Usage of CASE statement to identify if the data is of laptop or tablet and SUM to find the no of views by each device
	
Order of Execution:
	FROM => SELECT
*/
SELECT 
	 SUM(CASE WHEN device_type='laptop' THEN 1 ELSE 0 END) AS laptop_reviews
	,SUM(CASE WHEN device_type='tablet' OR device_type='phone' THEN 1 ELSE 0 END) AS mobile_views
FROM
	viewership;