-- Solution 1
-- Finding the difference of seats between empty seats
WITH empty_seats AS (
    SELECT SEAT_ID, FREE, SEAT_ID - ROW_NUMBER() OVER(ORDER BY SEAT_ID) AS diff
    FROM CINEMA
    WHERE FREE = TRUE
),
-- Finding the two or more consecutive empty seat groups
-- If there is a need to identify more than 2 consecutive empty seats, just update the HAVING clause filter value
conseq_empty_seats AS (
    SELECT diff
    FROM empty_seats
    GROUP BY diff
    HAVING COUNT(*) > 1
)
-- Final SELECT to find the two or more empty consecutive groups
SELECT e.SEAT_ID, e.FREE
FROM conseq_empty_seats c INNER JOIN empty_seats e
ON e.diff = c.diff;


-- Solution 2
-- Finding the Next or Previous empty seat using LEAD & LAG Window functions
WITH empty_seats AS (
    SELECT SEAT_ID, FREE, LEAD(SEAT_ID) OVER(ORDER BY SEAT_ID) - SEAT_ID AS next_empty, SEAT_ID - LAG(SEAT_ID) OVER(ORDER BY SEAT_ID) AS prev_empty
    FROM CINEMA
    WHERE FREE = TRUE
)
SELECT SEAT_ID, FREE
FROM empty_seats
WHERE next_empty = 1 OR prev_empty = 1;


-- Solution 3
-- Snowflake - Finding the Next or Previous empty seat using LEAD & LAG Window functions & QULIFY
SELECT SEAT_ID, FREE
FROM CINEMA
WHERE FREE = TRUE
QUALIFY ( LEAD(SEAT_ID) OVER(ORDER BY SEAT_ID) - SEAT_ID = 1 ) OR ( SEAT_ID - LAG(SEAT_ID) OVER(ORDER BY SEAT_ID) = 1 )
ORDER BY SEAT_ID;