-- JOIN green color result set with green-orange and if the id matches,
-- get green-orange else green
SELECT gc.id, ISNULL(c.color, gc.color) AS color
FROM (
	SELECT id, color
	FROM NamasteSQL.Colors
	WHERE LOWER(color) = 'green'
) gc
LEFT JOIN (
	SELECT id, color
	FROM NamasteSQL.Colors
	WHERE LOWER(color) = 'green-orange'
) c
ON gc.id = c.id;