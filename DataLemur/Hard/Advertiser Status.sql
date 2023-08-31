/*
Advertiser Status [Facebook SQL Interview Question]
====================================================
Learning from the problem:
	1. Applying the FULL JOIN to find whether the advertisers paid or not paid
	2. Applying CASE statement to categorize them based on their existing status & if they paid to contune the advertisement
*/
SELECT
  COALESCE(adv.user_id, pay.user_id) AS user_id
  ,CASE
    WHEN pay.paid IS NULL THEN
      'CHURN'
    WHEN adv.status = 'CHURN' AND pay.paid IS NOT NULL THEN
      'RESURRECT'
    WHEN adv.status IS NULL AND pay.paid IS NOT NULL THEN
      'NEW'
    WHEN adv.status IN ('NEW', 'EXISTING', 'RESURRECT') AND pay.paid IS NOT NULL THEN
      'EXISTING'
  END AS new_status
FROM
  advertiser adv
FULL OUTER JOIN
  daily_pay pay
ON adv.user_id = pay.user_id
ORDER BY
  user_id;