-- Using CHARINDEX & SUBSTRING
SELECT
    COUNT(id) AS gmail_accounts
   ,MAX(signup_date) AS latest_signup_date
   ,MIN(signup_date) AS first_signup_date
   ,DATEDIFF(day, MIN(signup_date), MAX(signup_date)) AS diff_in_days
FROM NamasteSQL.email_signup
WHERE LOWER(SUBSTRING(email_id, CHARINDEX('@',email_id)+1,9)) = 'gmail.com';