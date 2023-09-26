-- SELF JOIN the table on Manager_Id = Employee_Id and 
-- find the no of reportees & average age
SELECT
    r.emp_id
   ,r.emp_name
   ,COUNT(m.emp_id) AS reportee_Count
   ,CAST(ROUND(AVG(1.0*m.age),0) AS INT) AS avg_age
FROM NamasteSQL.Reportee_tbl r
INNER JOIN NamasteSQL.Reportee_tbl m
ON m.reports_to=r.emp_id
GROUP BY r.emp_id, r.emp_name;