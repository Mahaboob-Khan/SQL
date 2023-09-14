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