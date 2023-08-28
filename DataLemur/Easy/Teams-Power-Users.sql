-- Method 1 - Using the SQL GROUP BY clause
/*
	Learnings from the excercise:
		1. Usage of SELECT & FROM to get the data from a table
		2. Filtering the required rows using WHERE clause
		3. Usage GROUP BY to group the identical values
		4. Usage the aggregate function COUNT() to find the number of messages
		5. Usage of ORDER BY clause for sorting the result set
		6. Usage of LIMIT clause to limit the no of rows returned by the SQL query
		7. Ability of using the Column Alias (i.e. message_count) with ORDER BY clause as 
			ORDER BY comes after the SELECT in the SQL query order of execution
	Order of execution:
		FROM => WHERE => GROUP BY => SELECT => ORDER BY => LIMIT
*/
SELECT
  sender_id,
  COUNT(message_id) AS message_count
FROM 
  messages
WHERE
  sent_date BETWEEN '2022-08-01' AND '2022-08-31'
GROUP BY
  sender_id
ORDER BY 
  message_count DESC
LIMIT 2;


-- Method 2 - Using the SQL Window function concept
/*
	Learnings from the excercise:
		1. Usage of SELECT & FROM to get the data from a table
		2. Filtering the required rows using WHERE clause
		3. Usage COUNT() OVER() Window function to find the number of messages sent by each sender
		4. Usage DISTINCT keyword - 
			because COUNT() OVER() window function will not group the rows into a bucket like GROUP BY, 
			but each row will keep its own identity. So just removing the duplicate rows by using DISTINCT keyword
		5. Usage of ORDER BY clause for sorting the result set
		6. Usage of LIMIT clause to limit the no of rows returned by the SQL query
		7. Ability of using the Column Alias (i.e. message_count) with ORDER BY clause as 
			ORDER BY comes after the SELECT in the SQL query order of execution
	Order of execution:
		FROM => WHERE => COUNT() OVER() => SELECT DISTINCT => ORDER BY => LIMIT
*/
SELECT DISTINCT
  sender_id,
  COUNT(message_id) OVER(PARTITION BY sender_id) AS message_count
FROM 
  messages
WHERE
  sent_date BETWEEN '2022-08-01' AND '2022-08-31'
ORDER BY 
  message_count DESC
LIMIT 2;