/*
Average Review Ratings [Amazon SQL Interview Question]
======================================================
Learnings from the problem:
	1. Applying GROUP BY to find the average star rating for each product by month
	2. Usage of DATE_PART() to get the numeric value of month
	3. Usage of ROUND() to round off the decimal points to 2 digits
	4. Arrange the results in the order by month and then by product id
*/
SELECT
   DATE_PART('MONTH', submit_date) AS mth
  ,product_id AS product
  ,ROUND(AVG(stars), 2) AS avg_stars
FROM
  reviews
GROUP BY
   DATE_PART('MONTH', submit_date)
  ,product
ORDER BY
   mth
  ,product;