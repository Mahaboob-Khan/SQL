# Chips List
#### Problem Statement:
  Write a query to get the listed chips in order of their amounts respectively, if there is no chips mentioned then the amount should be skipped.<br />
  
#### Table Schema, Sample Input, and output
Table creation script available [here](https://github.com/Mahaboob-Khan/SQL/blob/main/NamasteSQL/Chips%20List/TableSchema.sql)

  `Chips` **Table**
  
  | Column Name   | Type     |
  | :------------ |:---------|
  | Chips         | VARCHAR    |
  | Amt           | VARCHAR    |

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

  Solution: [Chips List](https://github.com/Mahaboob-Khan/SQL/blob/main/NamasteSQL/Chips%20List/Solution.sql)
