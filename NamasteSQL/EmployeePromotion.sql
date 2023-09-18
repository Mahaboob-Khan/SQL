WITH emp_position AS (
  SELECT 
     e.emp_name
	,e.promotion_date
	,e.position
	,d.designation_order
	,ROW_NUMBER() OVER(PARTITION BY e.emp_name ORDER BY e.promotion_date) AS pro_num
	,ROW_NUMBER() OVER(PARTITION BY e.emp_name ORDER BY d.designation_order) AS pos_num
  FROM NamasteSQL.Employee_tbl e
  LEFT JOIN NamasteSQL.Designaton_tbl d
  ON e.position = d.designation
)
SELECT DISTINCT emp_name
FROM emp_position
WHERE pro_num - pos_num = 0;