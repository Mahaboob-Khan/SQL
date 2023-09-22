-- Using CHARINDEX & SUBSTRING
SELECT
    COUNT(id) AS gmail_accounts
   ,MAX(signup_date) AS latest_signup_date
   ,MIN(signup_date) AS first_signup_date
   ,DATEDIFF(day, MIN(signup_date), MAX(signup_date)) AS diff_in_days
FROM NamasteSQL.email_signup
WHERE LOWER(SUBSTRING(email_id, CHARINDEX('@',email_id)+1,9)) = 'gmail.com';

-- Using LOWER
SELECT
    COUNT(id) AS gmail_accounts
   ,MAX(signup_date) AS latest_signup_date
   ,MIN(signup_date) AS first_signup_date
   ,DATEDIFF(day, MIN(signup_date), MAX(signup_date)) AS diff_in_days
FROM NamasteSQL.email_signup
WHERE LOWER(email_id) LIKE '%gmail.com';

-- If the requirement is to find the data across each email domain
SELECT
    RIGHT(email_id, LEN(email_id) - CHARINDEX('@',email_id)) AS email_domain
   ,COUNT(id) AS email_accounts
   ,MAX(signup_date) AS latest_signup_date
   ,MIN(signup_date) AS first_signup_date
   ,DATEDIFF(day, MIN(signup_date), MAX(signup_date)) AS diff_in_days
FROM NamasteSQL.email_signup
GROUP BY RIGHT(email_id, LEN(email_id) - CHARINDEX('@',email_id));