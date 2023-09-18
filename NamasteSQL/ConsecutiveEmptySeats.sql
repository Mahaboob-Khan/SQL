WITH empty_seats AS (
	SELECT  seat_no, is_empty,
			seat_no - ROW_NUMBER() OVER(ORDER BY seat_no) AS diff
	FROM NamasteSQL.Seats
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