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

Question Source: DataLemur Hard SQL Question - Active User Retention - Facebook SQL Interview Question<br />
Solution: [Active User Retention](https://github.com/Mahaboob-Khan/SQL/blob/main/DataLemur/Hard/Active%20User%20Retention.sql)
</details>
<details>
  <summary>Q2. Advertiser Status [Facebook SQL Interview Question]</summary>
  <br />You're provided with two tables: the advertiser table contains information about advertisers and their respective payment status, and the daily_pay table contains the current payment information for advertisers, and it only includes advertisers who have made payments.

Write a query to update the payment status of Facebook advertisers based on the information in the daily_pay table. The output should include the user ID and their current payment status, sorted by the user id.
  <br />
  
`advertiser` **Table:**
| Column Name |	Type |
| :--- | :--- |
|user_id|string|
|status|string|

`daily_pay` **Table:**
| Column Name |	Type |
| :--- | :--- |
|user_id|string|
|paid|decimal|

Question Source: DataLemur Hard SQL Question - Advertiser Status - Facebook SQL Interview Question<br />
Solution: [Advertiser Status](https://github.com/Mahaboob-Khan/SQL/blob/main/DataLemur/Hard/Advertiser%20Status.sql)
</details>
