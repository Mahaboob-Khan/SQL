# Social Platform Usage
#### Problem Statement:
  Write a query to get the users who are viewers of both platforms, "*Twitch*" & "*Youtube*", and have *atleast once a minimum of 10mins watch time*.<br />
  
#### Table Schema, Sample Input, and output
Table creation script available [here](https://github.com/Mahaboob-Khan/SQL/blob/main/NamasteSQL/Social%20Platform%20Usage/TableSchema.sql)

  `Platforms` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | user_id       | INT      |
  | session_start | DATETIME |
  | session_end   | DATETIME |
  | platforms     | VARCHAR  |

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

  Solution: [Social Platform Usage](https://github.com/Mahaboob-Khan/SQL/blob/main/NamasteSQL/Social%20Platform%20Usage/Solution.sql)
</details>
