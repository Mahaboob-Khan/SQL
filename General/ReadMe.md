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
  | :--- | :--- | :--- |
  | 1 | Marlania | Jamacia |
  | 2 | Lakken | Kimberli |
  | 3 | Tarvares | Shaquria |
  | 4 | Gabriella | Kubra |

  **Solution:**
  
  `Method 1`
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
  
  `Method 2`
  ```sql
  -- Using FIRST_VALUE
  SELECT DISTINCT 
     dep_id
    ,FIRST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC) AS max_salary_emp
    ,FIRST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary) AS min_salary_emp
  FROM Employee;
  ```
  
  `Method 3`
  ```sql
  -- Using LAST_VALUE - We need to change the default window frame (UNBOUNDED PRECEDING AND CURRENT ROW) to consider all
  SELECT DISTINCT 
     dep_id
    ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS max_salary_emp
    ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS min_salary_emp
  FROM Employee;

  SELECT DISTINCT
     dep_id
    ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_salary_emp
    ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_salary_emp
  FROM Employee;
  ```
</details>
<details>
  <summary>Q3. Find the Nth Weekday date from given date</summary>

  #### Problem Statement:
  Write a SQL query to find the Nth Weekday date from current date / any given date.<br />
  
  `MS SQL Solution`
  ```sql
  DECLARE @Today DATE = GETDATE(), @Nth TINYINT = 3, @Day TINYINT = 6;
  SELECT
    @Today AS Today,
    DATEPART(dw, @Today) AS Today_DoW_num,
    DATENAME(dw, @Today) AS Today_DoW,
    DATEADD(dd, @Nth*7 - (7 + DATEPART(dw, @Today) - @Day) % 7, @Today) AS Nth_DoW_Date,
    DATENAME( dw, DATEADD(dd, @Nth*7 - (7 + DATEPART(dw, @Today) - @Day) % 7, @Today) ) AS Nth_DoW;
  ```
  
  Where<br />
  * @Today - Date from which we need to calculate the day
  * @Nth - Which occurence need to be determined
  * @Day - Weekday ( 1(Sunday) - 7(Saturday) because it's @@DATEFIRST is 7)
	
  ```sql
  -- Below query can give you the first weekday configured in the system
  SELECT @@DATEFIRST;
  
  -- It sets the first day of the week ( Default, us_english is 7)
  -- Where DATEFIRST 7 is Sunday [ 1 (Mon) - 7 (Sun) ]
  SET DATEFIRST 7;
  
  -- If the DATEFIRST is set to 7, then below query returns 1
  SELECT DATEPART(dw, any_sunday_date)
  ```
  
  **Sample Output** <br />
  * The SQL query was executed on 08-Oct-2023 and below is the output generated
	
  | Today | Today_DoW_num | Today_DoW | Nth_DoW_Date | Nth_DoW |
  | :---  | :---          | :---      | :---         | :---    |
  | 2023-10-08 | 1 | Sunday | 2023-10-27 | Friday |

  `Snowflake`
  ```sql
  SET (Nth, Day) = (3, 'friday');
  SELECT
    CURRENT_DATE() AS today,
    DAYNAME(today) AS today_dow,
    DATEADD(day, ($Nth - 1) * 7, NEXT_DAY(today, $Day)) AS Nth_dow_date,
    DAYNAME(Nth_dow_date) AS Nth_dow;
  ```
  
  **Sample Output**
  | TODAY | TDAY_DOW | NTH_DOW_DATE | NTH_DOW |
  | :---  | :---     | :---         | :---    |
  | 2023-10-08 | Sun | 2023-10-27   | Fri     |
</details>
<details>
  <summary>Q4. Two or more consecutive empty seats in a Cinema hall</summary>

  #### Problem Statement:
  Write a SQL query to identify the *Two or more consecutive empty seats in a Cinema hall*.<br />
  
  #### Table Schema, Sample Input, and output

  `Cinema` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | seat_id       | INT, AUTO INCREMENT |
  | free	      | INT (1 or 0)  |

  **Table Creation:**
  
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE Cinema(
	seat_id INT PRIMARY KEY,
	free INT
  );

  INSERT INTO Cinema(seat_id, free) VALUES
  (1, 1),
  (2, 0),
  (3, 1),
  (4, 1),
  (5, 1),
  (6, 0),
  (7, 1),
  (8, 1),
  (9, 0),
  (10, 1),
  (11, 0),
  (12, 1),
  (13, 0),
  (14, 1),
  (15, 1),
  (16, 0),
  (17, 1),
  (18, 1),
  (19, 1),
  (20, 1);
  ```

  **Sample Input:**
  
  `Employee`
  
  | seat_id | free |
  | :--- | :--- |
  | 1 | 1 |
  | 2 | 0 |
  | 3 | 1 |
  | 4 | 1 |
  | 5 | 1 |
  | 6 | 0 |
  | 7 | 1 |
  | 8 | 1 |
  | 9 | 0 |
  | 10 | 1 |
  | 11 | 0 |
  | 12 | 1 |
  | 13 | 0 |
  | 14 | 1 |
  | 15 | 1 |
  | 16 | 0 |
  | 17 | 1 |
  | 18 | 1 |
  | 19 | 1 |
  | 20 | 1 |

  **Sample Output:**
  
  | seat_id | free |
  | :--- | :--- |
  | 3 | 1 |
  | 4 | 1 |
  | 5 | 1 |
  | 7 | 1 |
  | 8 | 1 |
  | 14 | 1 |
  | 15 | 1 |
  | 17 | 1 |
  | 18 | 1 |
  | 19 | 1 |
  | 20 | 1 |

  **Solution:**
  
  `Method 1`
  ```sql
  -- Finding the difference of seats between empty seats
  WITH empty_seats AS (
      SELECT SEAT_ID, FREE, SEAT_ID - ROW_NUMBER() OVER(ORDER BY SEAT_ID) AS diff
      FROM CINEMA
      WHERE FREE = TRUE
  ),
  -- Finding the two or more consecutive empty seat groups
  -- If there is a need to identify more than 2 consecutive empty seats, just update the HAVING clause filter value
  conseq_empty_seats AS (
      SELECT diff
      FROM empty_seats
      GROUP BY diff
      HAVING COUNT(*) > 1
  )
  -- Final SELECT to find the two or more empty consecutive groups
  SELECT e.SEAT_ID, e.FREE
  FROM conseq_empty_seats c INNER JOIN empty_seats e
  ON e.diff = c.diff;
  ```
  
  `Method 2`
  ```sql
  -- Finding the Next or Previous empty seat using LEAD & LAG Window functions
  WITH empty_seats AS (
      SELECT SEAT_ID, FREE, LEAD(SEAT_ID) OVER(ORDER BY SEAT_ID) - SEAT_ID AS next_empty, SEAT_ID - LAG(SEAT_ID) OVER(ORDER BY SEAT_ID) AS prev_empty
      FROM CINEMA
      WHERE FREE = TRUE
  )
  SELECT SEAT_ID, FREE
  FROM empty_seats
  WHERE next_empty = 1 OR prev_empty = 1;
  ```
  
  `Method 3`
  ```sql
  -- Snowflake - Finding the Next or Previous empty seat using LEAD & LAG Window functions & QULIFY
  SELECT SEAT_ID, FREE
  FROM CINEMA
  WHERE FREE = TRUE
  QUALIFY ( LEAD(SEAT_ID) OVER(ORDER BY SEAT_ID) - SEAT_ID = 1 ) OR ( SEAT_ID - LAG(SEAT_ID) OVER(ORDER BY SEAT_ID) = 1 )
  ORDER BY SEAT_ID;
  ```
</details>
<details>
  <summary>Q5. Get the persons data organized into columns by their Professions</summary>

  #### Problem Statement:
  Write a SQL query to populate *persons data organized into columns by their Professions*.<br />
  
  #### Table Schema, Sample Input, and output

  `PROFESSION_DATA` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | NAME          | VARCHAR |
  | AGE	          | NUMBER  |
  | PROFESSION    | VARCHAR |

  **Table Creation:**
  
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE OR REPLACE TABLE PROFESSION_DATA (
  	NAME VARCHAR,
  	AGE NUMBER,
  	PROFESSION VARCHAR
  );

  INSERT INTO PROFESSION_DATA (NAME, AGE, PROFESSION) VALUES
  ('A',22,'ENG'),
  ('B',21,'DOCTOR'),
  ('C',29,'NURSE'),
  ('D',22,'ENG');
  ```

  **Sample Input:**
  
  `PROFESSION_DATA`
  
  | NAME | AGE  | PROFESSION |
  | :--- | :--- | :---       |
  | A | 22 | ENG |
  | B | 21 | DOCTOR |
  | C | 29 | NURSE |
  | D | 25 | ENG |

  **Sample Output:**
  
  | ENG | DOCTOR | NURSE |
  | :--- | :---  | :---  |
  | A | B | C |
  | D | null | null |

  **Solution:**

  `Using LEFT JOIN`
  ```sql
  -- Filter data by each profession into it's own CTE
  WITH ENG_DATA AS (
      SELECT
          NAME AS ENG,
          ROW_NUMBER() OVER(ORDER BY NAME) AS RN_ENG
      FROM
          PROFESSION_DATA
      WHERE 
          PROFESSION = 'ENG'
  )
  ,DOCTOR_DATA AS (
      SELECT
          NAME AS DOCTOR,
          ROW_NUMBER() OVER(ORDER BY NAME) AS RN_DOCTOR
      FROM
          PROFESSION_DATA
      WHERE 
          PROFESSION = 'DOCTOR'
  )
  ,NURSE_DATA AS (
      SELECT
          NAME AS NURSE,
          ROW_NUMBER() OVER(ORDER BY NAME) AS RN_NURSE
      FROM
          PROFESSION_DATA
      WHERE 
          PROFESSION = 'NURSE'
  )
  -- Combine the data of different professions data into single result set using LEFT JOIN
  SELECT
    E.ENG, D.DOCTOR, N.NURSE
  FROM
    ENG_DATA E
  LEFT JOIN
    DOCTOR_DATA D
    ON E.RN_ENG = D.RN_DOCTOR
  LEFT JOIN
    NURSE_DATA N
    ON E.RN_ENG = N.RN_NURSE;
  ```
</details>