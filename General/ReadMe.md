# Common SQL Interview Questions
<details>
  <summary>Q1. Repeat Rows based on the no of characters in the skill name</summary>

  #### Problem Statement:
  Write a SQL query to repeat skill_name based on the no of characters in the skill_name.<br />
  
  #### Table Schema, Sample Input, and output

  `Skills_data` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | skill_id      | VARCHAR  |
  | skill_name    | VARCHAR  |

  **Table Creation:**
  
  ```sql
  CREATE TABLE Skills_data (
	skill_id VARCHAR(3),
	skill_name VARCHAR(15)
  );
  
  INSERT INTO Skills_data VALUES
  ('S1', 'SQL'),
  ('S2', 'Python'),
  ('S3', 'Excel');
  ```

  `Skills_data` **Example Input:**
  
  | skill_id    | skill_name      |
  | :--- | :--- |
  | S1 | SQL |
  | S2 | Python |
  | S3 | Excel |

  `Example` **Output:**
  | skill_id | skill_name |
  | :--- | :--- |
  | S1 | SQL  |
  | S1 | SQL  |
  | S1 | SQL  |
  | S2 | Python |
  | S2 | Python |
  | S2 | Python |
  | S2 | Python |
  | S2 | Python |
  | S2 | Python |
  | S3 | Excel |
  | S3 | Excel |
  | S3 | Excel |
  | S3 | Excel |
  | S3 | Excel |

  ```sql
  WITH cte_repeat AS (
	SELECT skill_id, skill_name, LEN(skill_name) AS Num 
	FROM Skills_data
	UNION ALL
	SELECT skill_id, skill_name, Num - 1 
	FROM cte_repeat
	WHERE Num > 1
  )
  SELECT skill_id, skill_name
  FROM cte_repeat
  ORDER BY skill_id;
  ```

  Solution: [Repeat Rows](https://github.com/Mahaboob-Khan/SQL/blob/new_sql/General/RepeatRows.sql)
</details>
