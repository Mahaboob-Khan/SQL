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
  
  `Chips` **Example Input:**
  
  | Chips    | Amt      |
  | :--- | :--- |
  | lays1, uncle_chips1, kurkure1 | 10,20,30 |
  | wafferrs2 | 40,50 |
  | potatochips3, hotchips3, balaji3 | 60,70,80 |

  `Example` **Output:**
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

  `Platforms` **Example Input:**
  
  | user_id    | session_start      | session_end   | platforms        |
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

  `Example` **Output:**
  | user_id |
  | :--- |
  | 1 |
  | 3 |

  **Approach 1**
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

  **Approach 2**
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

  `Log_tbl` **Example Input:**
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

  `Log_tbl` **Output:**
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

  `Players` **Example Input:**
  
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

  `Example` **Output:**
  | player | no_of_gold |
  | :---   | :---       |
  | Amthhew | 1 |
  | Charles | 3 |
  | jessica | 1 |
  | Ronald  | 1 |
  | Thomas  | 3 |

  **Approach 1**
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

  **Approach 2**
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

  `Players` **Sample Input:**  
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
	SELECT seat_no, is_empty,
	seat_no - ROW_NUMBER() 
	OVER(ORDER BY seat_no) AS diff
	FROM seats
	WHERE is_empty='Y'
  )

  SELECT seat_no, is_empty
  FROM empty_seats empty
  INNER JOIN (
	SELECT diff
	FROM empty_seats
	GROUP BY diff
	HAVING COUNT(*) >= 3 ) empty3
  ON empty.diff = empty3.diff;
  ```
</details>