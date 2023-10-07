# SQL Interview Questions
<details>
  <summary>Q1. Get the correct price of each chips type</summary>
  
  #### Problem Statement:
  Write a query to get the listed chips in order of their amounts respectively, if there is no chips mentioned then the amount should be skipped.<br />
    
  #### Table Schema, Sample Input, and output
  
  `Chips` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | Chips         | VARCHAR  |
  | Amt           | VARCHAR  |

  **Table Creation:**
  ```sql
  CREATE TABLE Chips_tbl (
    Chips VARCHAR(500),
    Amount VARCHAR(500)
  );
  
  INSERT INTO Chips_tbl(Chips, Amount) VALUES
  ('lays1, uncle_chips1, kurkure1', '10,20,30'),
  ('wafferrs2', '40,50'),
  ('potatochips3, hotchips3, balaji3', '60,70,80');
  ```
  
  **Sample Input:**
  `Chips`
  
  | Chips    | Amt      |
  | :--- | :--- |
  | lays1, uncle_chips1, kurkure1 | 10,20,30 |
  | wafferrs2 | 40,50 |
  | potatochips3, hotchips3, balaji3 | 60,70,80 |

  **Sample Output:**
  | Chips_List | Amt |
  | :--- | :--- |
  | lays1 | 10  |
  | uncle_chips1 | 20  |
  | kurkure1 |  30 |
  | wafferrs2 | 40  |
  | potatochips3 | 60  |
  | hotchips3 |  70 |
  | balaji3   |  80 |

  ```sql
  -- Split the Chips column into multiple rows by delimiter & CROSS APPLY with Main Table
  WITH CTE_Chips AS (
    SELECT T.Chips, C.Ordinal, TRIM(C.Value) AS Chips_List
    FROM Chips_tbl T
    CROSS APPLY STRING_SPLIT(Chips,',',1) C
  ),
  -- Split the Amount column into multiple rows by delimiter & CROSS APPLY with Main Table
  CTE_Amt AS (
    SELECT T.Chips, A.Ordinal, A.Value AS Amt
    FROM Chips_tbl T
    CROSS APPLY STRING_SPLIT(Amount,',',1) A
  )
  -- JOIN both the CTEs on Main Table Chips Column & Ordinal/Index of each chips to identify the price
  SELECT Chips.Chips_List, Amt.Amt 
  FROM CTE_Chips Chips 
  INNER JOIN CTE_Amt Amt
  	ON Chips.Chips = Amt.Chips 
  	AND Chips.Ordinal = Amt.Ordinal;
  ```
</details>
<details>
  <summary>Q2. Social Platform Users</summary>
  
#### Problem Statement:
  Write a query to get the users who are viewers of both platforms, "*Twitch*" & "*Youtube*", and have *atleast once a minimum of 10mins watch time*.<br />
  
#### Table Schema, Sample Input, and output

  `Platforms` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | user_id       | INT      |
  | session_start | DATETIME |
  | session_end   | DATETIME |
  | platforms     | VARCHAR  |

  **Table Creation:**

  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.tbl_Platform (
  	user_id INT NOT NULL,
  	session_start DATETIME,
  	session_end DATETIME,
  	platforms VARCHAR(20)
  );
  
  INSERT INTO NamasteSQL.tbl_Platform (user_id, session_start, session_end, platforms) VALUES
  (0, '2020-08-11 05:51:31.000', '2020-08-11 05:54:45.000', 'Twitch'),
  (0, '2020-03-11 03:01:40.000', '2020-03-11 03:01:59.000', 'Twitch'),
  (0, '2020-08-11 03:50:45.000', '2020-08-11 03:55:59.000', 'Youtube'),
  (1, '2020-11-19 06:24:24.000', '2020-11-19 07:24:38.000', 'Youtube'),
  (1, '2020-11-20 06:59:57.000', '2020-11-20 07:20:11.000', 'Twitch'),
  (2, '2020-07-11 03:36:54.000', '2020-07-11 03:37:08.000', 'OTT'),
  (2, '2020-11-14 03:36:05.000', '2020-11-14 03:39:19.000', 'Youtube'),
  (2, '2020-07-11 14:32:19.000', '2020-07-11 14:42:33.000', 'Youtube'),
  (3, '2020-11-26 11:41:47.000', '2020-11-26 11:52:01.000', 'Twitch'),
  (3, '2020-10-11 22:15:14.000', '2020-10-11 22:18:28.000', 'Youtube');
  ```

  **Sample Input:**
  `Platforms` 
  | user_id    | session_start      | session_end   | platforms |
  | :--- | :--- | :---| :--- |
  | 0 | 2020-08-11 05:51:31.000 | 2020-08-11 05:54:45.000 | Twitch |
  | 0 | 2020-03-11 03:01:40.000 | 2020-03-11 03:01:59.000 | Twitch |
  | 0 | 2020-08-11 03:50:45.000 | 2020-08-11 03:55:59.000 | Youtube |
  | 1 | 2020-11-19 06:24:24.000 | 2020-11-19 07:24:38.000 | Youtube |
  | 1 | 2020-11-20 06:59:57.000 | 2020-11-20 07:20:11.000 | Twitch |
  | 2 | 2020-07-11 03:36:54.000 | 2020-07-11 03:37:08.000 | OTT |
  | 2 | 2020-11-14 03:36:05.000 | 2020-11-14 03:39:19.000 | Youtube |
  | 2 | 2020-07-11 14:32:19.000 | 2020-07-11 14:42:33.000 | Youtube |
  | 3 | 2020-11-26 11:41:47.000 | 2020-11-26 11:52:01.000 | Twitch |
  | 3 | 2020-10-11 22:15:14.000 | 2020-10-11 22:18:28.000 | Youtube |

  **Sample Output:**
  | user_id |
  | :--- |
  | 1 |
  | 3 |

  
  **Solution:**<br />
  `Method 1`
  ```sql
  -- Approach 1 - Using GROUP BY, CTE & INNER JOIN
  WITH cte_users AS (
  	-- Get the users of two platforms (Twitch & Youtube)
  	SELECT user_id
  	FROM NamasteSQL.tbl_Platform
  	WHERE platforms IN ('Twitch', 'Youtube')
  	GROUP BY user_id
  	HAVING COUNT(DISTINCT platforms) = 2
  ),
  cte_duration AS (
  	-- Get the users who have at least 10mins of watch time on either Twitch or Youtube
  	SELECT user_id
  	FROM NamasteSQL.tbl_Platform
  	WHERE platforms IN ('Twitch', 'Youtube')
  	AND DATEDIFF(MINUTE, session_start, session_end) >= 10
  )
  -- Final query to find the users of both platforms who have at least 10mins of watch time once
  SELECT DISTINCT u.user_id
  FROM cte_users u INNER JOIN cte_duration d
  ON u.user_id = d.user_id;
  ```

  `Method 2`
  ```sql
  -- Approach 2 - Using DENSE_RANK() & INNER JOIN
  SELECT DISTINCT D.user_id
  FROM NamasteSQL.tbl_Platform D
  INNER JOIN (
  	SELECT user_id, DENSE_RANK() OVER(PARTITION BY user_id ORDER BY platforms) AS drank
  	FROM NamasteSQL.tbl_Platform
  	WHERE platforms IN ('Twitch', 'Youtube')
  ) U ON D.user_id = U.user_id
  WHERE DATEDIFF(MINUTE, D.session_start, D.session_end) >= 10
  AND u.drank = 2;
  ``` 
</details>
<details>
  <summary>Q3. Assign the Running Number and reset when Non-Null value is encountered</summary>
  
#### Problem Statement:
  Write a query to get the Running number when the flag encounters a NULL & again reset it for the next subsequent follow-up when it encounters a Non-NULL value.<br />
  
#### Table Schema, Sample Input, and output

  `Log_tbl` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | id            | INT      |
  | date          | DATE     |
  | flag          | INT      |

  **Table Creation:**

  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Log_tbl (
  	id INT,
  	date DATE,
  	flag INT
  );
  
  INSERT INTO NamasteSQL.Log_tbl (id, date, flag) VALUES
  (1, '2019-01-01', null),
  (1, '2019-01-02', null),
  (1, '2019-01-03', null),
  (1, '2019-01-04', 1),
  (1, '2019-01-05', null),
  (1, '2019-01-06', null),
  (1, '2019-01-07', 1),
  (2, '2019-01-02', 1),
  (2, '2019-01-03', null),
  (2, '2019-01-04', 1),
  (2, '2019-01-05', null),
  (2, '2019-01-06', null);
  ```

  **Sample Input:**
  `Log_tbl`
  | id    | date      | flag   |
  | :--- | :--- | :--- |
  |1 | 2019-01-01 | null |
  |1 | 2019-01-02 | null |
  |1 | 2019-01-03 | null |
  |1 | 2019-01-04 | 1 |
  |1 | 2019-01-05 | null |
  |1 | 2019-01-06 | null |
  |1 | 2019-01-07 | 1 |
  |2 | 2019-01-02 | 1 |
  |2 | 2019-01-03 | null |
  |2 | 2019-01-04 | 1 |
  |2 | 2019-01-05 | null |
  |2 | 2019-01-06 | null |

  **Sample Output:**
  | id   | date | flag | running_num |
  | :--- | :--- | :--- | :--- |
  |1 | 2019-01-01 | null | 1 |
  |1 | 2019-01-02 | null | 2 |
  |1 | 2019-01-03 | null | 3 |
  |1 | 2019-01-04 | 1 | null |
  |1 | 2019-01-05 | null | 1 |
  |1 | 2019-01-06 | null | 2 |
  |1 | 2019-01-07 | 1 | null |
  |2 | 2019-01-02 | 1 | null |
  |2 | 2019-01-03 | null | 1 |
  |2 | 2019-01-04 | 1 | null |
  |2 | 2019-01-05 | null | 1 |
  |2 | 2019-01-06 | null | 2 |

  **Solution**
  ```sql
	-- Assigning the row number for each record, and row number order by date for partitions (with & without flag value NULL)
	-- Perform rnum1 - rnum2 to get the different value assigned to each group of NULL records and add new row number to get running number
	WITH cte_data AS (
		SELECT 
			 id
			,date
			,flag
			,ROW_NUMBER() OVER(ORDER BY date, id) AS rnum1
			,ROW_NUMBER() OVER(PARTITION BY id, (CASE WHEN flag IS NULL THEN 1 ELSE 0 END) ORDER BY date) AS rnum2
		FROM NamasteSQL.Log_tbl
	)

	SELECT 
		 id
		,date
		,flag
		,CASE
			WHEN flag IS NULL THEN
	  			ROW_NUMBER() OVER(PARTITION BY id, rnum1-rnum2 ORDER BY id, date)
			ELSE NULL
		 END AS running_num
	FROM cte_data
	ORDER BY id, date;
  ```
</details>
<details>
  <summary>Q4. Swimmers who only won gold medals</summary>
  
#### Problem Statement:
  Write a query to find the *no of gold medals per swimmer for swimmer who ONLY won gold medals*.<br />
  
#### Table Schema, Sample Input, and output

  `Players` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | id     | INT      |
  | event  | VARCHAR  |
  | year   | SMALLINT |
  | gold   | VARCHAR  |
  | silver | VARCHAR  |
  | bronze | VARCHAR  |

  **Table Creation:**

  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Players(
	id INT,
	event VARCHAR(200),
	year SMALLINT,
	gold VARCHAR(25),
	silver VARCHAR(25),
	bronze VARCHAR(25)
  );
  
  INSERT INTO NamasteSQL.Players(id, event, year, gold, silver, bronze) VALUES
  (1, '100m', '2016', 'Amthhew', 'Donald', 'Barbara'),
  (2, '200m', '2016', 'Nichole', 'Alvaro', 'janet'),
  (3, '500m', '2016', 'Charles', 'Nichole', 'Susana'),
  (4, '100m', '2016', 'Ronald', 'maria', 'paula'),
  (5, '200m', '2016', 'Alfred', 'carol', 'Steven'),
  (6, '500m', '2016', 'Nichole', 'Alfred', 'Brandon'),
  (7, '100m', '2016', 'Charles', 'Dennis', 'Susana'),
  (8, '200m', '2016', 'Thomas', 'Dawn', 'catherine'),
  (9, '500m', '2016', 'Thomas', 'Dennins', 'paula'),
  (10, '100m', '2016', 'Charles', 'Dennis', 'Susana'),
  (11, '200m', '2016', 'jessica', 'Donald', 'Stefeney'),
  (12, '500m', '2016', 'Thomas', 'Steven', 'Catherine');
  ```

  **Sample Input:** <br />
  `Players`
  
  | id    | event  | year  | gold  |  silver  |  bronze |
  | :---  | :---   | :---  | :---  | :---     | :---    |
  |1 | 100m | 2016 | Amthhew | Donald | Barbara |
  |2 | 200m | 2016 | Nichole | Alvaro | janet |
  |3 | 500m | 2016 | Charles | Nichole | Susana |
  |4 | 100m | 2016 | Ronald | maria | paula |
  |5 | 200m | 2016 | Alfred | carol | Steven |
  |6 | 500m | 2016 | Nichole | Alfred | Brandon |
  |7 | 100m | 2016 | Charles | Dennis | Susana |
  |8 | 200m | 2016 | Thomas | Dawn | catherine |
  |9 | 500m | 2016 | Thomas | Dennins | paula |
  |10 | 100m | 2016 | Charles | Dennis | Susana |
  |11 | 200m | 2016 | jessica | Donald | Stefeney |
  |12 | 500m | 2016 | Thomas | Steven | Catherine |

  **Sample Output:**
  | player | no_of_gold |
  | :---   | :---       |
  | Amthhew | 1 |
  | Charles | 3 |
  | jessica | 1 |
  | Ronald  | 1 |
  | Thomas  | 3 |

  **Solution:**<br />
  `Method 1`
  ```sql
  -- Using LEFT JOIN & GROUP BY
  SELECT g.gold AS name, COUNT(*) AS no_of_gold
  FROM NamasteSQL.Players g
  LEFT JOIN NamasteSQL.Players s
    ON LOWER(g.gold) = LOWER(s.silver)
  LEFT JOIN NamasteSQL.Players b
    ON LOWER(g.gold) = LOWER(b.bronze)
  WHERE s.silver IS NULL AND b.bronze IS NULL
  GROUP BY g.gold;
  ```

  `Method 2`
  ```sql
  -- Using UNION ALL & CTE
  WITH silver_bronze_players AS (
	SELECT DISTINCT silver AS name
	FROM NamasteSQL.Players
	UNION ALL
	SELECT DISTINCT bronze AS name
	FROM NamasteSQL.Players
  )
  SELECT gold AS player, COUNT(*) AS no_of_gold
  FROM NamasteSQL.Players
  WHERE LOWER(gold) NOT IN (
	SELECT LOWER(name)
	FROM silver_bronze_players
  )
  GROUP BY gold;
  ``` 
</details>
<details>
  <summary>Q5. Find 3 or more consecutive empty seats</summary>
  
#### Problem Statement:
  Write a query to get the *list of 3 or more Consecutive empty seats*.<br />
  
#### Table Schema, Sample Input, and output

  `Seats` **Table**
  
  | Column Name | Type   |
  | :-------- |:-------  |
  | seat_no   | SMALLINT |
  | is_empty  | CHAR     |

  **Table Creation:**

  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Seats (
	seat_no SMALLINT,
	is_empty CHAR(1)
  );
  
  INSERT INTO NamasteSQL.Seats(seat_no, is_empty) VALUES
  (1, 'N'),
  (2, 'Y'),
  (3, 'N'),
  (4, 'Y'),
  (5, 'Y'),
  (6, 'Y'),
  (7, 'N'),
  (8, 'Y'),
  (9, 'Y'),
  (10, 'Y'),
  (11, 'Y'),
  (12, 'N'),
  (13, 'Y'),
  (14, 'Y');
  ```

  **Sample Input:** <br />
  `Seats` 
  | seat_no | is_empty |
  | :---    | :---     |
  |1 | N |
  |2 | Y |
  |3 | N |
  |4 | Y |
  |5 | Y |
  |6 | Y |
  |7 | N |
  |8 | Y |
  |9 | Y |
  |10 | Y |
  |11 | Y |
  |12 | N |
  |13 | Y |
  |14 | Y |

  **Sample Output:**
  | seat_no | is_empty |
  | :---    | :---     |
  |4 | Y |
  |5 | Y |
  |6 | Y |
  |8 | Y |
  |9 | Y |
  |10 | Y |
  |11 | Y |

  **Solution**
  ```sql
  WITH empty_seats AS (
	SELECT 
		 seat_no
		,is_empty
		,seat_no - ROW_NUMBER() OVER(ORDER BY seat_no) AS diff
	FROM NamasteSQL.Seats
	WHERE is_empty='Y'
  )

  SELECT
	 seat_no
	,is_empty
  FROM empty_seats empty
  INNER JOIN (
	SELECT diff
	FROM empty_seats
	GROUP BY diff
	HAVING COUNT(*) >= 3 ) empty3
  ON empty.diff = empty3.diff;
  ```
</details>
<details>
  <summary>Q6. Employees who were only promoted & never demoted</summary>
  
#### Problem Statement:
  Write a query to print only those employee names who were *only promoted & never demoted*.<br />
  
#### Table Schema, Sample Input, and output

  `Employee_tbl` **Table**
  
  | Column Name    | Type     |
  | :------------  |:---------|
  | emp_name       | VARCHAR  |
  | promotion_date | DATE     |
  | position       | VARCHAR  |

  `Designation_tbl` **Table**
  
  | Column Name    | Type     |
  | :------------  |:---------|
  | designation_order | SMALLINT |
  | designation       | VARCHAR  |
  
  **Table Creation:**

  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Employee_tbl(
	emp_name VARCHAR(20),
	promotion_date DATE,
	position VARCHAR(20)
  );
  
  INSERT INTO NamasteSQL.Employee_tbl(emp_name, promotion_date, position) VALUES
  ('A', '1999-10-10', 'Clerk'),
  ('A', '1999-12-10', 'Agent'),
  ('A', '2000-02-01', 'Clerk'),
  ('B', '2000-01-01', 'Agent'),
  ('B', '2000-02-02', 'Assistant Manager'),
  ('B', '2000-05-15', 'Manager'),
  ('C', '2000-05-01', 'Assistant Manager'),
  ('C', '2000-05-06', 'Agent'),
  ('D', '2000-02-01', 'Agent'),
  ('D', '2000-05-10', 'Assistant Manager'),
  ('D', '2000-06-15', 'Head Manager');
  
  CREATE TABLE NamasteSQL.Designaton_tbl(
	designation_order SMALLINT,
	designation VARCHAR(20)
  );
  
  INSERT INTO NamasteSQL.Designaton_tbl(designation_order, designation) VALUES
  (1, 'Clerk'),
  (2, 'Agent'),
  (3, 'Assistant Manager'),
  (4, 'Manager'),
  (5, 'Head Manager');
  ```

  **Sample Input:**
  
  `Employee_tbl`
  
  | emp_name | promotion_date | position |
  | :---     | :---           | :---     |
  | A | 1999-10-10 | Clerk |
  | A | 1999-12-10 | Agent |
  | A | 2000-02-01 | Clerk |
  | B | 2000-01-01 | Agent |
  | B | 2000-02-02 | Assistant Manager |
  | B | 2000-05-15 | Manager |
  | C | 2000-05-01 | Assistant Manager |
  | C | 2000-05-06 | Agent |
  | D | 2000-02-01 | Agent |
  | D | 2000-05-10 | Assistant Manager |
  | D | 2000-06-15 | Head Manager |
  
  `Designaton_tbl`
  | designation_order | designation |
  | :---              | :---        |
  | 1 | Clerk |
  | 2 | Agent |
  | 3 | Assistant Manager |
  | 4 | Manager |
  | 5 | Head Manager |

  **Sample Output:**
  | emp_name |
  | :--- |
  | B |
  | D |

  **Solution:**
  ```sql
  WITH emp_position AS (
	SELECT 
	   e.emp_name
	  ,e.promotion_date
	  ,e.position
	  ,d.designation_order
	  ,ROW_NUMBER() OVER(PARTITION BY e.emp_name ORDER BY e.promotion_date) AS pro_num
	  ,ROW_NUMBER() OVER(PARTITION BY e.emp_name ORDER BY d.designation_order) AS pos_num
	FROM NamasteSQL.Employee_tbl e
	LEFT JOIN NamasteSQL.Designaton_tbl d
	ON e.position = d.designation
  )
  SELECT DISTINCT emp_name
  FROM emp_position
  WHERE pro_num - pos_num = 0;
  ```
</details>
<details>
  <summary>Q7. Clean the Names table</summary>
  
#### Problem Statement:
  Write a query to clean the input table - Names and provide the First name & Last name as shown in the sample output.<br />
  
#### Table Schema, Sample Input, and output

  `Names` **Table**
  
  | Column Name | Type     |
  | :--------   |:---------|
  | name        | VARCHAR  |
  
  **Table Creation:**

  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Names(
    name VARCHAR(20)
  );
  
  INSERT INTO NamasteSQL.Names VALUES
  ('AsHiSh dEv'),
  ('KuMar SinGh'),
  ('JohN dOe'),
  ('VaibHAVi IYER'),
  ('kiRAn RaO');
  ```

  **Sample Input:** 
  
  `Names`  
  | name |
  | :--- |
  | AsHiSh dEv |
  | KuMar SinGh |
  | JohN dOe |
  | VaibHAVi IYER |
  | kiRAn RaO |

  **Sample Output:**
  | first_name | last_name |
  | :---       | :---      |
  | Ashish | Dev |
  | Kumar | Singh |
  | John | Doe |
  | Vaibhavi | Iyer |
  | Kiran | Rao |

  **Solution:**<br />
  `Approach1`
  ```sql
  -- Using PARSENAME, REPLACE, LOWER, UPPER, LEFT, RIGHT, and LEN
  WITH cte_names AS (
    SELECT
       LOWER(PARSENAME(REPLACE(name,' ','.'),2)) AS fname
      ,LOWER(PARSENAME(REPLACE(name,' ','.'),1)) AS lname
    FROM NamasteSQL.Names
  )

  SELECT 
     UPPER(LEFT(fname,1))+RIGHT(fname,LEN(fname)-1) AS first_name
    ,UPPER(LEFT(lname,1))+RIGHT(lname,LEN(lname)-1) AS last_name
  FROM cte_names;
  ```
  
  `Approach2`
  ```sql
  -- Using CHARINDEX, SUBSTRING, LOWER, UPPER, and LEN
  WITH cte_names AS (
    SELECT
       LOWER(SUBSTRING(name, 1, CHARINDEX(' ', name)-1)) AS fname
      ,LOWER(SUBSTRING(name, CHARINDEX(' ', name)+1, LEN(name) - CHARINDEX(' ', name))) AS lname
    FROM NamasteSQL.Names)

  SELECT 
     UPPER(SUBSTRING(fname,1,1))+SUBSTRING(fname,2,LEN(fname)-1) AS first_name
    ,UPPER(SUBSTRING(lname,1,1))+SUBSTRING(lname,2,LEN(lname)-1) AS last_name
  FROM cte_names;
  ```
</details>
<details>
  <summary>Q8. Get Manager's Manager name of Employees</summary>
  
#### Problem Statement:
  Write a query to get the the Manager's - N+1 names mapped from the table, also display only those records whose length of Employee names is greater than or
  equal to their N+2 names.<br />
  
  `Refer below mapping:` <br />
  - Employee -> Manager = N+1
  - Employee -> Manager's -> Manager = N+2
	 
#### Table Schema, Sample Input, and output

  `Employee_mapping` **Table**
  
  | Column Name | Type     |
  | :--------   |:---------|
  | id          | SMALLINT |
  | emp_name    | VARCHAR  |
  | manager_id  | SMALLINT |
  
  **Table Creation:**

  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Employee_mapping(
    id smallint,
    emp_name VARCHAR(20),
    manager_id smallint
  );
  
  INSERT INTO NamasteSQL.Employee_mapping VALUES
  (1, 'ajay', 3),
  (2, 'shalini', 1),
  (3, 'vikas', 2),
  (4, 'akshay', 5),
  (5, 'pooja', 6),
  (6, 'ritvik', 4);
  ```

  **Sample Input:** <br />  
  `Employee_mapping`  
  | id   | emp_name | manager_id |
  | :--- | :---     | :---       |
  | 1 | ajay | 3 |
  | 2 | shalini | 1 |
  | 3 | vikas | 2 |
  | 4 | akshay | 5 |
  | 5 | pooja | 6 |
  | 6 | ritvik | 4 |

  **Sample Output:**
  | emp_name | managers_manager |
  | :---     | :---    |
  | shalini  |	vikas  |
  | vikas	 |  ajay   |
  | akshay   |	ritvik |
  | ritvik   |	pooja  |

  **Solution:**
  ```sql
  -- Using JOIN to get Manager's Manager name of an employee
  SELECT
     e.emp_name
    ,m2.emp_name AS managers_manager
  FROM NamasteSQL.Employee_mapping e
  LEFT JOIN NamasteSQL.Employee_mapping m
    ON e.manager_id = m.id
  LEFT JOIN NamasteSQL.Employee_mapping m2
    ON m.manager_id = m2.id
  WHERE LEN(e.emp_name) >= LEN(m2.emp_name);
  ```
</details>
<details>
  <summary>Q9. No of New & Repeated Customers on each Order Date</summary>
  
#### Problem Statement:
  Write a query to find the total customers, new customers, and repeted customers for each order date.<br />
	 
#### Table Schema, Sample Input, and output

  `Orders` **Table** <br />  
  | Column Name  | Type          |
  | :--------    |:---------     |
  | order_id     | INT, IDENTITY |
  | customer_id  | INT           |
  | order_date   | DATE          |
  | order_amount | INT           |
  
  **Table Creation:** <br />
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Orders(
	order_id INT IDENTITY(1,1),
	customer_id INT,
	order_date DATE,
	order_amount INT
  );
  
  INSERT INTO NamasteSQL.Orders(customer_id, order_date, order_amount) VALUES
  (100, '2022-01-01', 2000),
  (200, '2022-01-01', 2500),
  (300, '2022-01-01', 2100),
  (100, '2022-01-02', 2000),
  (400, '2022-01-02', 2200),
  (500, '2022-01-02', 2700),
  (100, '2022-01-03', 3000),
  (400, '2022-01-03', 1000),
  (600, '2022-01-03', 3000);
  ```

  **Sample Input:** <br />  
  `Orders`  
  | order_id   | customer_id | order_date | order_amount |
  | :---       | :---        | :---       | :---         |
  | 1 | 100 | 2022-01-01 | 2000 |
  | 2 | 200 | 2022-01-01 | 2500 |
  | 3 | 300 | 2022-01-01 | 2100 |
  | 4 | 100 | 2022-01-02 | 2000 |
  | 5 | 400 | 2022-01-02 | 2200 |
  | 6 | 500 | 2022-01-02 | 2700 |
  | 7 | 100 | 2022-01-03 | 3000 |
  | 8 | 400 | 2022-01-03 | 1000 |
  | 9 | 600 | 2022-01-03 | 3000 |

  **Sample Output:**
  | order_date | total_customers | new_customers | repeated_customers |
  | :---       | :---            | :---          | :---               |
  | 2022-01-01 | 3 | 3 | 0 |
  | 2022-01-02 | 3 | 2 | 1 |
  | 2022-01-03 | 3 | 1 | 2 |

  **Solution:** <br />
  `Method 1`
  ```sql
  -- Using JOIN & GROUP BY
  WITH first_order AS (
    SELECT
       customer_id
	  ,MIN(order_date) AS first_order_date
    FROM NamasteSQL.Orders
    GROUP BY customer_id
  )
  SELECT
    o.order_date
    ,COUNT(o.customer_id) AS total_customers
    ,SUM( CASE WHEN o.order_date = f.first_order_date THEN 1 ELSE 0 END ) AS new_customers
    ,SUM( CASE WHEN o.order_date > f.first_order_date THEN 1 ELSE 0 END ) AS repeated_customers
  FROM NamasteSQL.Orders o
  LEFT JOIN first_order f
  ON o.customer_id = f.customer_id
  GROUP BY o.order_date;
  ```
  
  `Method 2`
  ```sql
  -- Using ROW_NUMBER() & GROUP BY
  WITH order_entry AS (
    SELECT
       customer_id
      ,order_date
      ,ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS order_no
    FROM NamasteSQL.Orders
  )
  SELECT
     order_date
    ,COUNT( customer_id ) AS total_customers
    ,SUM( CASE WHEN order_no = 1 THEN 1 ELSE 0 END ) AS new_customers
    ,SUM( CASE WHEN order_no > 1 THEN 1 ELSE 0 END ) AS repeated_customers
  FROM order_entry
  GROUP BY order_date;
  ```
</details>
<details>
  <summary>Q10. No of GMAIL accounts, Signup dates, & difference between Signup dates</summary>
  
#### Problem Statement:
  Write a query to find the *No of GMAIL accounts, Latest & First Signup date, difference between Latest & First Signup date*.<br />
	 
#### Table Schema, Sample Input, and output

  `email_signup` **Table** <br />  
  | Column Name | Type    |
  | :--------   |:------- |
  | id          | INT     |
  | email_id    | VARCHAR |
  | signup_date | DATE    |
  
  **Table Creation:** <br />
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.email_signup (
	id INT,
	email_id VARCHAR(100),
	signup_date DATE
  );

  INSERT INTO NamasteSQL.email_signup(id, email_id, signup_date) VALUES
  (1, 'Rajesh@Gmail.com', '2022-02-01'),
  (2, 'Rakesh_gmail@rediffmail.com', '2023-01-22'),
  (3, 'Hitest@Gmail.com', '2020-09-08'),
  (4, 'Salil@Gmmail.com', '2019-07-05'),
  (5, 'Himanshu@Yahoo.com', '2023-05-09'),
  (6, 'Hitesh@Twitter.com', '2015-01-01'),
  (7, 'Rakesh@facebook.com', null);
  ```

  **Sample Input:** <br />  
  `email_signup`  
  | id   | email_id | signup_date |
  | :--- | :---     | :---        |
  | 1 | Rajesh@Gmail.com | 2022-02-01 |
  | 2 | Rakesh_gmail@rediffmail.com | 2023-01-22 |
  | 3 | Hitest@Gmail.com | 2020-09-08 |
  | 4 | Salil@Gmmail.com | 2019-07-05 |
  | 5 | Himanshu@Yahoo.com | 2023-05-09 |
  | 6 | Hitesh@Twitter.com | 2015-01-01 |
  | 7 | Rakesh@facebook.com | null |

  **Sample Output:**
  | gmail_accounts | latest_signup_date | first_signup_date | diff_in_days |
  | :---           | :---               | :---              | :---         |
  | 2              | 2022-02-01         | 2020-09-08        | 511          |

  **Solution:**<br />
  `Method 1`
  ```sql
  -- Using CHARINDEX & SUBSTRING
  SELECT
     COUNT(id) AS gmail_accounts
    ,MAX(signup_date) AS latest_signup_date
    ,MIN(signup_date) AS first_signup_date
    ,DATEDIFF(day, MIN(signup_date), MAX(signup_date)) AS diff_in_days
  FROM NamasteSQL.email_signup
  WHERE LOWER(SUBSTRING(email_id, CHARINDEX('@',email_id)+1,9)) = 'gmail.com';
  ```
  
  `Method 2`
  ```sql
  -- Using LOWER
  SELECT
     COUNT(id) AS gmail_accounts
    ,MAX(signup_date) AS latest_signup_date
    ,MIN(signup_date) AS first_signup_date
    ,DATEDIFF(day, MIN(signup_date), MAX(signup_date)) AS diff_in_days
  FROM NamasteSQL.email_signup
  WHERE LOWER(email_id) LIKE '%gmail.com';
  ```
  
  `Optional`<br />
  *If the requirement is to find the data across each email domain, then we may use below query.*<br />
  ```sql
  SELECT
     RIGHT(email_id, LEN(email_id) - CHARINDEX('@',email_id)) AS email_domain
    ,COUNT(id) AS email_accounts
    ,MAX(signup_date) AS latest_signup_date
    ,MIN(signup_date) AS first_signup_date
    ,DATEDIFF(day, MIN(signup_date), MAX(signup_date)) AS diff_in_days
  FROM NamasteSQL.email_signup
  GROUP BY RIGHT(email_id, LEN(email_id) - CHARINDEX('@',email_id));
  ```
</details>
<details>
  <summary>Q11. Total Salary in each department</summary>
  
#### Problem Statement:
  Write a query to print *The total salary for each department*.<br />
	 
#### Table Schema, Sample Input, and output

  `Dept_tbl` **Table** <br />  
  | Column Name | Type    |
  | :--------   |:------- |
  | id_deptname | VARCHAR |
  | emp_name    | VARCHAR |
  | salary      | INT     |
  
  **Table Creation:** <br />
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Dept_tbl(
	id_deptname VARCHAR(20),
	emp_name VARCHAR(25),
	salary INT
  );

  INSERT INTO NamasteSQL.Dept_tbl(id_deptname, emp_name, salary) VALUES
  ('1111-MATH', 'RAHUL', 10000),
  ('1111-MATH', 'RAKESH', 20000),
  ('2222-SCIENCE', 'AKASH', 10000),
  ('222-SCIENCE', 'ANDREW', 10000),
  ('22-CHEM', 'ANKIT', 25000),
  ('3333-CHEM', 'SONIKA', 12000),
  ('4444-BIO', 'HITESH', 2300),
  ('44-BIO', 'AKSHAY', 10000);
  ```

  **Sample Input:**  
  `Dept_tbl`  
  | id_deptname | emp_name | salary |
  | :---        | :---     | :---   |
  | 1111-MATH | RAHUL | 10000 |
  | 1111-MATH | RAKESH | 20000 |
  | 2222-SCIENCE | AKASH | 10000 |
  | 222-SCIENCE | ANDREW | 10000 |
  | 22-CHEM | ANKIT | 25000 |
  | 3333-CHEM | SONIKA | 12000 |
  | 4444-BIO | HITESH | 2300 |
  | 44-BIO | AKSHAY | 10000 |

  **Sample Output:**
  | dept_name | total_salary |
  | :---      | :---         |
  | BIO |	12300 |
  | CHEM | 37000 |
  | MATH | 30000 |
  | SCIENCE | 20000 |

  **Solution:**<br />
  `Method 1`
  ```sql
  -- Using SUBSTRING, CHARINDEX, LEN, GROUP BY
  SELECT 
     SUBSTRING(id_deptname, CHARINDEX('-', id_deptname)+1, LEN(id_deptname) - CHARINDEX('-', id_deptname)) AS dept_name
    ,SUM(salary) AS total_salary
  FROM NamasteSQL.Dept_tbl
  GROUP BY SUBSTRING(id_deptname, CHARINDEX('-', id_deptname)+1, LEN(id_deptname) - CHARINDEX('-', id_deptname));
  ```
  
  `Method 2`
  ```sql
  -- Using RIGHT, CHARINDEX, LEN, GROUP BY
  SELECT 
     RIGHT(id_deptname, LEN(id_deptname) - CHARINDEX('-', id_deptname)) AS dept_name
    ,SUM(salary) AS total_salary
  FROM NamasteSQL.Dept_tbl
  GROUP BY RIGHT(id_deptname, LEN(id_deptname) - CHARINDEX('-', id_deptname));
  ```
  
  `Method 3`
  ```sql
  -- Using PARSENAME, REPLACE, GROUP BY
  SELECT 
     PARSENAME(REPLACE(id_deptname, '-', '.'),1) AS dept_name
    ,SUM(salary) AS total_salary
  FROM NamasteSQL.Dept_tbl
  GROUP BY PARSENAME(REPLACE(id_deptname, '-', '.'),1);  
  ```
  
  `Method 4`
  ```sql
  -- Using STRING_SPLIT, GROUP BY
  SELECT 
     value AS dept_name
    ,SUM(salary) AS total_salary
  FROM Dept_tbl 
  CROSS APPLY STRING_SPLIT(id_deptname, '-', 1)
  WHERE ordinal = 2
  GROUP BY value;  
  ```
</details>
<details>
  <summary>Q12. Two consecutive window seats for both Gender, M & F.</summary>
  
#### Problem Statement:
  Write a query to get *The two consecutive window seats for both Gender, "M" & "F", also assign Ranks from the Highest Seat no. to the Lowest Seat no*.<br />
	 
#### Table Schema, Sample Input, and output

  `Seats_tbl` **Table** <br />  
  | Column Name | Type     |
  | :--------   |:-------  |
  | gender      | CHAR     |
  | window_seat | SMALLINT |
  
  **Table Creation:** <br />
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Seats_tbl(
    gender CHAR(1),
    window_seat SMALLINT
  );
  
  INSERT into NamasteSQL.seats_tbl values
  ('M', 1),
  ('F', 2),
  ('M', 3),
  ('M', 4),
  ('F', 5),
  ('F', 6),
  ('M', 7);
  ```

  **Sample Input:**  
  `Seats_tbl`  
  | gender | window_seat |
  | :---   | :---        |
  | M | 1 |
  | F | 2 |
  | M | 3 |
  | M | 4 |
  | F | 5 |
  | F | 6 |
  | M | 7 |

  **Sample Output:**
  | gender | window_seat | rnk  |
  | :---   | :---        | :--- |
  | M	| 3	| 2 |
  | M	| 4	| 1 |
  | F	| 5	| 2 |
  | F	| 6	| 1 |

  **Solution:**<br />
  ```sql
  -- Assign the ROW_NUMBER for each seat occupied PARTITION BY gender.
  -- Calculate the difference between Seat_No & ROW_NUMBER
  WITH window_seats AS (
    SELECT
      gender
     ,window_seat
     ,window_seat - ROW_NUMBER() OVER(PARTITION BY gender ORDER BY window_seat) AS diff
    FROM NamasteSQL.Seats_tbl
  ),
  -- If the diff is same i.e window seats occupied consecutively
  conseq_seats AS (
    SELECT
      gender
     ,diff
    FROM window_seats
    GROUP BY gender, diff
    HAVING COUNT(*) >= 2)
  -- Join Window Seats with Consecutive Seats to identify the result
  SELECT
     w.gender
    ,w.window_seat
    ,ROW_NUMBER() OVER(PARTITION BY w.gender ORDER BY window_seat DESC) AS rnk
  FROM window_seats w
  INNER JOIN conseq_seats c
     ON w.diff = c.diff AND w.gender = c.gender
  ORDER BY w.window_seat;
  ```
</details>
<details>
  <summary>Q13. Difference of amount between apples & oranges for each day.</summary>
  
#### Problem Statement:
  Write a query to get *The difference of amount between apples & oranges for each day*.<br />
	 
#### Table Schema, Sample Input, and output

  `Sales_tbl` **Table** <br />  
  | Column Name | Type     |
  | :--------   |:-------  |
  | sales_date  | DATE     |
  | fruits      | VARCHAR  |
  | sold_num    | SMALLINT |
  
  **Table Creation:** <br />
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Sales_tbl(
	sales_date DATE,
	fruits VARCHAR(25),
	sold_num SMALLINT
  );

  INSERT INTO NamasteSQL.Sales_tbl(sales_date, fruits, sold_num) VALUES
  ('2020-05-01', 'apples', 10),
  ('2020-05-01', 'oranges', 8),
  ('2020-05-02', 'apples', 15),
  ('2020-05-02', 'oranges', 15),
  ('2020-05-03', 'apples', 20),
  ('2020-05-03', 'oranges', 0),
  ('2020-05-04', 'apples', 15),
  ('2020-05-04', 'oranges', 16);
  ```

  **Sample Input:**  
  `Sales_tbl`  
  | sales_date | fruits | sold_num |
  | :---       | :---   | :---     |
  | 2020-05-01 | apples | 10 |
  | 2020-05-01 | oranges | 8 |
  | 2020-05-02 | apples | 15 |
  | 2020-05-02 | oranges | 15 |
  | 2020-05-03 | apples | 20 |
  | 2020-05-03 | oranges | 0 |
  | 2020-05-04 | apples | 15 |
  | 2020-05-04 | oranges | 16 |

  **Sample Output:**
  | sales_date | diff | 
  | :---       | :--- |
  | 2020-05-01 | 2 |
  | 2020-05-02 | 0 |
  | 2020-05-03 | 20 |
  | 2020-05-04 | -1 |

  **Solution:**<br />  
  `Method 1`
  ```sql
  -- Using CTE for each fruit type and JOIN
  WITH apple_sales AS (
	SELECT sales_date, sold_num
	  FROM NamasteSQL.Sales_tbl
	 WHERE fruits = 'apples'
  ),
  orange_sales AS (
	SELECT sales_date, sold_num
	  FROM NamasteSQL.Sales_tbl
	 WHERE fruits = 'oranges'
  )
  SELECT a.sales_date, a.sold_num - o.sold_num AS diff
  FROM apple_sales a 
  LEFT JOIN orange_sales o
    ON a.sales_date = o.sales_date
  ORDER BY a.sales_date;
  ```
  
  `Method 2`
  ```sql
  -- Using CASE WHEN to generate the Fruit Sold_num as columns and
  -- CTE, GROUP BY for difference calculation 
  WITH fruit_Sales AS (
    SELECT 
	    sales_date
	   ,CASE WHEN fruits = 'apples' THEN sold_num ELSE 0 END AS apple_sales
	   ,CASE WHEN fruits = 'oranges' THEN sold_num ELSE 0 END AS orange_sales
    FROM NamasteSQL.Sales_tbl
  )
  SELECT
     sales_date
	,SUM(apple_sales) - SUM(orange_sales) AS diff
  FROM fruit_Sales
  GROUP BY sales_date
  ORDER BY sales_date;
  ```
  
  `Method 3`
  ```sql
  -- Simple CASE WHEN & GROUP BY
  SELECT
     Sales_date
	,SUM(CASE 
		  WHEN fruits = 'apples' THEN sold_num
		  WHEN fruits = 'oranges' THEN -sold_num
		 END
		) AS diff
  FROM NamasteSQL.Sales_tbl
  GROUP BY sales_date
  ORDER BY sales_date;  
  ```
</details>
<details>
  <summary>Q14. Green-Orange if Green exists for same id</summary>
  
#### Problem Statement:
  Write a query to get *Green-Orange if Green exists for same ids if not then display the respective color if its only Green*.<br />
	 
#### Table Schema, Sample Input, and output

  `Colors` **Table** <br />  
  | Column Name | Type     |
  | :--------   |:-------  |
  | id          | SMALLINT |
  | color       | VARCHAR  |
  
  **Table Creation:**
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Colors(
    id SMALLINT,
    color VARCHAR(20)
  );

  INSERT INTO NamasteSQL.Colors(id, color) VALUES
  (1, 'Green'),
  (1, 'Green-Orange'),
  (2, 'Black'),
  (3, 'Blue'),
  (4, 'Red'),
  (5, 'Green'),
  (5, 'Green-Orange'),
  (6, 'Green'),
  (7, 'Green'),
  (8, 'Green'),
  (8, 'Green-Orange'),
  (9, 'Green'),
  (10, 'Green');
  ```

  **Sample Input:**  
  `Colors`  
  | id   | color    | 
  | :--- | :---     |
  | 1 | Green |
  | 1 | Green-Orange |
  | 2 | Black |
  | 3 | Blue |
  | 4 | Red |
  | 5 | Green |
  | 5 | Green-Orange |
  | 6 | Green |
  | 7 | Green |
  | 8 | Green |
  | 8 | Green-Orange |
  | 9 | Green |
  | 10 | Green |

  **Sample Output:**
  | id   | color |
  | :--- | :---  |
  | 1 | Green-Orange |
  | 5 | Green-Orange |
  | 6 | Green |
  | 7 | Green |
  | 8 | Green-Orange |
  | 9 | Green |
  | 10 | Green |

  **Solution:**
  ```sql
  -- JOIN green color result set with green-orange and if the id matches,
  -- get green-orange else green
  SELECT gc.id, ISNULL(c.color, gc.color) AS color
  FROM (
	SELECT id, color
	FROM NamasteSQL.Colors
	WHERE LOWER(color) = 'green'
  ) gc
  LEFT JOIN (
	SELECT id, color
	FROM NamasteSQL.Colors
	WHERE LOWER(color) = 'green-orange'
  ) c
  ON gc.id = c.id;
  ```
</details>
<details>
  <summary>Q15. No of Employees reporting to each manager & average age of reporting employees</summary>
  
#### Problem Statement:
  Write a query to report *The ids and the names of all managers, the no of employees who report directly to them, <br />
  and the average age of the reports rounded to the nearest integer*.<br />
	 
#### Table Schema, Sample Input, and output

  `Reportee_tbl` **Table** <br />  
  | Column Name | Type     |
  | :--------   |:-------  |
  | emp_id      | INT      |
  | emp_name    | VARCHAR  |
  | reports_to  | INT      |
  | age         | TINYINT  |
  
  **Table Creation:**
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Reportee_tbl(
	emp_id INT,
	emp_name VARCHAR(30),
	reports_to INT,
	age TINYINT
  );

  INSERT INTO NamasteSQL.Reportee_tbl(emp_id, emp_name, reports_to, age) VALUES
  (9, 'Henry', null, 43),
  (6, 'Alice', 9, 41),
  (4, 'Bob', 9, 36),
  (2, 'Winston', null, 37);
  ```

  **Sample Input:**  
  `Reportee_tbl`  
  | emp_id | emp_name | reports_to | age  |
  | :---   | :---     | :---       | :--- |
  | 9 | Henry | null | 43 |
  | 6 | Alice | 9 | 41 |
  | 4 | Bob | 9 | 36 |
  | 2 | Winston | null | 37 |

  **Sample Output:**
  | emp_id | emp_name | reportee_Count | avg_age |
  | :---   | :---     | :---           | :---    | 
  | 9	   | Henry    |	2              | 39      |

  **Solution:**
  ```sql
  -- SELF JOIN the table on Manager_Id = Employee_Id and 
  -- find the no of reportees & average age
  SELECT
     r.emp_id
    ,r.emp_name
    ,COUNT(m.emp_id) AS reportee_Count
    ,CAST(ROUND(AVG(1.0*m.age),0) AS INT) AS avg_age
  FROM NamasteSQL.Reportee_tbl r
  INNER JOIN NamasteSQL.Reportee_tbl m
  ON m.reports_to=r.emp_id
  GROUP BY r.emp_id, r.emp_name;
  ```
</details>
<details>
  <summary>Q16. No of Unique customers, total transactions, difference between first & last transaction time</summary>
  
#### Problem Statement:
  Write a query to get the no of *unique names, no of transactions, and the difference between the first & last transaction occured on 02-01-2023.*
	 
#### Table Schema, Sample Input, and output

  `Transaction_tbl` **Table** <br />  
  | Column Name | Type     |
  | :--------   |:-------  |
  | name        | CHAR     |
  | trans_id    | INT      |
  | date_time   | DATETIME |
  
  **Table Creation:**
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Transaction_tbl (
    name CHAR(1),
    trans_id INT,
    date_time DATETIME
  );

  INSERT INTO NamasteSQL.Transaction_tbl(name, trans_id, date_time) VALUES
  ('D', 8888, '2023-01-01 08:22:13.053'),
  ('A', 55, '2023-01-02 16:12:18.023'),
  ('D', 22, '2023-01-03 14:02:13.053'),
  ('R', 77, '2023-01-04 20:22:33.053'),
  ('H', 33, '2023-01-02 19:30:10.015'),
  ('H', 789, '2023-01-02 10:22:13.053'),
  ('I', 654, '2023-01-03 00:12:13.023'),
  ('P', 4489, '2023-01-04 00:22:15.013'),
  ('A', 2145, '2023-01-02 15:22:13.053');
  ```

  **Sample Input:**  
  `Transaction_tbl`  
  | name | trans_id | date_time |
  | :--- | :---     | :---      |
  | D    | 8888     | 2023-01-01 08:22:13.053 |
  | A    | 55       | 2023-01-02 16:12:18.023 |
  | D    | 22       | 2023-01-03 14:02:13.053 |
  | R    | 77       | 2023-01-04 20:22:33.053 |
  | H    | 33       | 2023-01-02 19:30:10.017 |
  | H    | 789      | 2023-01-02 10:22:13.053 |
  | I    | 654      | 2023-01-03 00:12:13.023 |
  | P    | 4489     | 2023-01-04 00:22:15.013 |
  | A    | 2145     | 2023-01-02 15:22:13.053 |

  **Sample Output:**
  | unique_names | trans | diff_in_mins |
  | :---         | :---  | :---         |
  | 2 | 4 | 548  |

  **Solution:**
  ```sql
  -- Applying COUNT DISTINCT in identifying the unique customers
  --  COUNT in identifying the total transactions
  --  MIN & MIX in identifying the first & last transaction time
  --  DATEDIFF to calculate the difference between first & last transaction time
  SELECT 
     COUNT(DISTINCT name) AS unique_names
    ,COUNT(trans_id) AS trans
    ,DATEDIFF(MINUTE, MIN(date_time), MAX(date_time)) AS diff_in_mins
  FROM NamasteSQL.Transaction_tbl
  WHERE CAST(date_time AS DATE) = '2023-01-02';
  ```
</details>
<details>
  <summary>Q17. Generate Transaction Summary Report</summary>
  
#### Problem Statement:
  Write a query to *Generate the transaction summary report as shown in the sample output.*
	 
#### Table Schema, Sample Input, and output

  `Transactions_tbl` **Table** <br />  
  | Column Name | Type     |
  | :--------   |:-------  |
  | id          | INT      |
  | country     | CHAR     |
  | state       | VARCHAR  |
  | amount      | INT      |
  | trans_date  | DATE     |
  
  **Table Creation:**
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE NamasteSQL.Transactions_tbl(
	id INT,
	country CHAR(2),
	state VARCHAR(15),
	amount INT,
	trans_date DATE
  );

  INSERT INTO NamasteSQL.Transactions_tbl(id, country, state, amount, trans_date) VALUES
  (121, 'US', 'approved', 1000, CAST('2018-12-18' AS DATE)),
  (122, 'US', 'declined', 2000, CAST('2018-12-19' AS DATE)),
  (123, 'US', 'approved', 2000, CAST('2019-01-01' AS DATE)),
  (124, 'DE', 'approved', 2000, CAST('2019-01-07' AS DATE));
  ```

  **Sample Input:**  
  `Transactions_tbl`  
  | id   | country | state | amount | trans_date |
  | :--- | :---    | :---  | :---   | :---       |
  | 121 | US | approved | 1000 | 2018-12-18 | 
  | 122 | US | declined | 2000 | 2018-12-19 | 
  | 123 | US | approved | 2000 | 2019-01-01 | 
  | 124 | DE | approved | 2000 | 2019-01-07 | 

  **Sample Output:**
  | year_month | country | trans_count | approved_count | declined_count | trans_total_amount | approved_total_amount |
  | :---       | :---    | :---        | :---           | :---           | :---               | :---                  |
  | 2018-12    | US | 2 | 1 | 1 | 3000 | 1000 |
  | 2019-01    | US | 1 | 1 | 0 | 2000 | 2000 |
  | 2019-01    | DE | 1 | 1 | 0 | 2000 | 2000 |

  **Solution:**
  ```sql
  -- Using GROUP BY, CASE WHEN along with SUM aggregation
  SELECT
     FORMAT(trans_date, 'yyyy-MM') AS year_month
    ,country
    ,COUNT(Id) AS trans_count
    ,SUM(CASE WHEN LOWER(state)='approved' THEN 1 ELSE 0 END) AS approved_count
    ,SUM(CASE WHEN LOWER(state)='declined' THEN 1 ELSE 0 END) AS declined_count
    ,SUM(amount) AS trans_total_amount
    ,SUM(CASE WHEN LOWER(state)='approved' THEN amount ELSE 0 END) AS approved_total_amount 
  FROM NamasteSQL.transactions_tbl 
  GROUP BY FORMAT(trans_date, 'yyyy-MM'), country
  ORDER BY year_month, trans_total_amount DESC;
  ```
</details>
<details>
  <summary>Q18. No of different products sold on each day and their names</summary>
  
#### Problem Statement:
  Write a query to *Find for each date the number od different products sold and their names.*
	 
#### Table Schema, Sample Input, and output

  `Products` **Table** <br />  
  | Column Name | Type     |
  | :--------   |:-------  |
  | sell_date   | DATE     |
  | product     | VARCHAR  |
  
  **Table Creation:**
  ```sql
  -- DDL Script for Table creation & loading the data
  CREATE TABLE Products(
	sell_date DATE,
	product VARCHAR(25)
  );

  INSERT INTO Products(sell_date, product) VALUES
  (CAST('2020-05-30' AS DATE), 'Headphones'),
  (CAST('2020-06-01' AS DATE), 'Pencil'),
  (CAST('2020-06-02' AS DATE), 'Mask'),
  (CAST('2020-05-30' AS DATE), 'Basketball'),
  (CAST('2020-06-01' AS DATE), 'Book'),
  (CAST('2020-06-02' AS DATE), 'Mask'),
  (CAST('2020-05-30' AS DATE), 'T-Shirt');
  ```

  **Sample Input:**  
  `Products`  
  | sell_date | product |
  | :---      | :---    |
  | 2020-05-30 | Headphones |
  | 2020-06-01 | Pencil |
  | 2020-06-02 | Mask |
  | 2020-05-30 | Basketball |
  | 2020-06-01 | Book |
  | 2020-06-02 | Mask |
  | 2020-05-30 | T-Shirt | 

  **Sample Output:**
  | sell_date | num_sold | product_list | 
  | :---      | :---     | :---         |
  | 2020-05-30 | 3 | Basketball, Headphones, T-Shirt |
  | 2020-06-01 | 2 | Book, Pencil |
  | 2020-06-02 | 1 | Mask |

  **Solution:**
  ```sql
  -- Selected the list of unique products sold on each date as 
  -- DISTINCT keyword is not supported on MS SQL
  WITH uniq_prod AS (
    SELECT DISTINCT 
	   sell_date,
	   product
    FROM Products )
  SELECT
    sell_date,
    COUNT(product) AS num_sold, 
    STRING_AGG(product, ', ') WITHIN GROUP (ORDER BY product) AS product_list
  FROM uniq_prod
  GROUP BY sell_date
  ORDER BY sell_date;
  ```
  
  `Snowflake`
  ```sql
  -- Using LISTAGG
  SELECT
    sell_date,
    COUNT( DISTINCT product) AS num_sold,
    LISTAGG(DISTINCT product, ', ') WITHIN GROUP (ORDER BY product) AS product_list
  FROM Products
  GROUP BY sell_date
  ORDER BY sell_date;
  ```
</details>