--Method1
SELECT g.gold AS name, COUNT(*) AS no_of_gold
FROM NamasteSQL.Players g
LEFT JOIN NamasteSQL.Players s
   ON LOWER(g.gold) = LOWER(s.silver)
LEFT JOIN NamasteSQL.Players b
   ON LOWER(g.gold) = LOWER(b.bronze)
WHERE s.silver IS NULL AND b.bronze IS NULL
GROUP BY g.gold;

--Method2
WITH silver_bronze_players AS (
	SELECT DISTINCT silver AS name
	FROM NamasteSQL.Players
	UNION ALL
	SELECT DISTINCT bronze AS name
	FROM NamasteSQL.Players
)
SELECT gold AS player, COUNT(*) AS no_of_gold
FROM NamasteSQL.Players
WHERE LOWER(gold) NOT IN (
	SELECT LOWER(name)
	FROM silver_bronze_players
)
GROUP BY gold;