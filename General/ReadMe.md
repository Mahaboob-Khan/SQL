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
</details>
<details>
  <summary>Q2. Employees with Maximum & Minimum Salary in each Department</summary>

  #### Problem Statement:
  Write a SQL query to identify the *Highest & Lowest Salaried Employee in each Department*.<br />
  
  #### Table Schema, Sample Input, and output

  `Employee` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | emp_id        | INT      |
  | emp_name      | VARCHAR  |
  | salary        | INT      |
  | dep_id        | INT      |

  **Table Creation:**
  
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE Employee(
	emp_id INT,
	emp_name VARCHAR(25),
	salary INT,
	dep_id INT
  );

  INSERT INTO Employee(emp_id, emp_name, salary, dep_id) VALUES
  (1001, 'Marlania', 92643, 1),
  (1002, 'Briana', 87202, 1),
  (1003, 'Maysha', 70545, 1),
  (1004, 'Jamacia', 65285, 1),
  (1005, 'Kimberli', 51407, 2),
  (1006, 'Lakken', 88933, 2),
  (1007, 'Micaila', 82145, 2),
  (1008, 'Gion', 66187, 2),
  (1009, 'Latoynia', 55729, 3),
  (1010, 'Shaquria', 52111, 3),
  (1011, 'Tarvares', 82979, 3),
  (1012, 'Gabriella', 74132, 4),
  (1013, 'Medusa', 72551, 4),
  (1014, 'Kubra', 55170, 4);
  ```

  **Sample Input:**
  
  `Employee`
  
  | emp_id | emp_name | salary | dep_id |
  | :--- | :--- | :--- | :--- |
  | 1001 | Marlania | 92643 | 1 |
  | 1002 | Briana | 87202 | 1 |
  | 1003 | Maysha | 70545 | 1 |
  | 1004 | Jamacia | 65285 | 1 |
  | 1005 | Kimberli | 51407 | 2 |
  | 1006 | Lakken | 88933 | 2 |
  | 1007 | Micaila | 82145 | 2 |
  | 1008 | Gion | 66187 | 2 |
  | 1009 | Latoynia | 55729 | 3 |
  | 1010 | Shaquria | 52111 | 3 |
  | 1011 | Tarvares | 82979 | 3 |
  | 1012 | Gabriella | 74132 | 4 |
  | 1013 | Medusa | 72551 | 4 |
  | 1014 | Kubra | 55170 | 4 |

  **Sample Output:**
  
  | dep_id | max_salary_emp | min_salary_emp |
  | :--- | :--- | :--- | :--- | 
  | 1 | Marlania | Jamacia |
  | 2 | Lakken | Kimberli |
  | 3 | Tarvares | Shaquria |
  | 4 | Gabriella | Kubra |

  ```sql
  -- CTE - Identified the Employees having maximum & minimum salary
  -- GROUP BY on dep_id and MAX of emp_name to identify the employee names
  WITH max_min_salary AS (
  SELECT
     dep_id
    ,CASE
	   WHEN salary=MAX(salary) OVER(PARTITION BY dep_id) THEN emp_name
     END AS max_salary_emp
    ,CASE
	   WHEN salary=MIN(salary) OVER(PARTITION BY dep_id) THEN emp_name
     END AS min_salary_emp
  FROM Employee)

  SELECT
     dep_id
    ,MAX(max_salary_emp) AS max_salary_emp
    ,MAX(min_salary_emp) AS min_salary_emp
  FROM max_min_salary
  GROUP BY dep_id;
  ```
</details>