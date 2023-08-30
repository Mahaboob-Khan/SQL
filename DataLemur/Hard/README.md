# DataLemur Hard SQL Questions
<details>
  <summary>Q1. Active User Retention [Facebook SQL Interview Question]</summary>
  <br />Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".
<br />
  
**Hint:**
  - An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.
  <br />
  
`user_actions` **Table:**
| Column Name |	Type |
| :--- | :--- |
|user_id|integer|
|event_id|integer|
|event_type|string ("sign-in, "like", "comment")|
|event_date|datetime|

Question Source: [Active User Retention - Facebook SQL Interview Question](https://datalemur.com/questions/user-retention) <br />
Solution: [Active User Retention](https://github.com/Mahaboob-Khan/SQL/blob/main/DataLemur/Hard/Active%20User%20Retention.sql)
</details>
