# DataLemur Easy SQL Questions
<details>
  <summary> Q1. Teams Power Users [Microsoft SQL Interview Question] </summary>
  Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.<br /><br />
  
  Assumption:
  - No two users have sent the same number of messages in August 2022.<br />
  
  `messages` **Table**
  
  | Column Name   | Type         |
  | :------------ |:-------------|
  | message_id    | integer      |
  | sender_id     | integer      |
  | receiver_id   | integer      |
  | content       | varchar      |
  | sent_date     | datetime     |

  `messages` **Example Input:**
  
  | message_id    | sender_id      | receiver_id   | content        | sent_date |
  | :--- | :--- | :---| :--- | :--- |
  | 901 |	3601 | 4500	| You up? |	08/03/2022 00:00:00 |
  | 902 |	4500 | 3601 |	Only if you're buying |	08/03/2022 00:00:00 |
  | 743 |	3601 | 8752 |	Let's take this offline |	06/14/2022 00:00:00 |
  | 922 |	3601 | 4500	| Get on the call	| 08/10/2022 00:00:00 |

  `Example` **Output:**
  | sender_id |	message_count |
  | :--- | :--- |
  | 3601 |	2   |
  | 4500 |	1   |

  Question Source: [Teams Power Users - Microsoft SQL Interview Question](https://datalemur.com/questions/teams-power-users) <br />
  Solution: [Teams-Power-Users](https://github.com/Mahaboob-Khan/SQL/blob/main/DataLemur/Easy/Teams-Power-Users.sql)
</details>
<details>
  <summary> Q2. Cities With Completed Trades [Robinhood SQL Interview Question] </summary>
  Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.<br />
  Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order.
  Output the city name and the corresponding number of completed trade orders.<br /><br />
  
  `trades` **Table**
  
  | Column Name   | Type         |
  | :------------ |:-------------|
  | order_id    | integer |
  | user_id     | integer |
  | price   | decimal |
  | quantity       | integer |
  | status     | string('Completed' ,'Cancelled') |
  | timestamp | datetime |

  `users` **Table**
  
  | Column Name   | Type         |
  | :------------ |:-------------|
  | user_id    | integer |
  | city     | string |
  | email   | string |
  | signup_date | datetime |

  Question Source: [Cities With Completed Trades - Robinhood SQL Interview Question](https://datalemur.com/questions/completed-trades) <br />
  Solution: [Cities-With-Completed-Trades](https://github.com/Mahaboob-Khan/SQL/blob/main/DataLemur/Easy/Cities-With-Completed-Trades.sql)
</details>
