-- Assign the ROW_NUMBER for each seat occupied PARTITION BY gender.
-- Calculate the difference between Seat_No & ROW_NUMBER
WITH window_seats AS (
  SELECT
      gender
     ,window_seat
     ,window_seat - ROW_NUMBER() OVER(PARTITION BY gender ORDER BY window_seat) AS diff
  FROM NamasteSQL.Seats_tbl
),
-- If the diff is same i.e window seats occupied consecutively
conseq_seats AS (
  SELECT
      gender
     ,diff
  FROM window_seats
  GROUP BY gender, diff
  HAVING COUNT(*) >= 2)
-- Join Window Seats with Consecutive Seats to identify the result
SELECT
   w.gender
  ,w.window_seat
  ,ROW_NUMBER() OVER(PARTITION BY w.gender ORDER BY window_seat DESC) AS rnk
FROM window_seats w
INNER JOIN conseq_seats c
   ON w.diff = c.diff AND w.gender = c.gender
ORDER BY w.window_seat;