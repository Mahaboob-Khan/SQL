-- Using JOIN to get Manager's Manager name of an employee
SELECT
  e.emp_name
 ,m2.emp_name AS managers_manager
FROM NamasteSQL.Employee_mapping e
LEFT JOIN NamasteSQL.Employee_mapping m
ON e.manager_id = m.id
LEFT JOIN NamasteSQL.Employee_mapping m2
ON m.manager_id = m2.id
WHERE LEN(e.emp_name) >= LEN(m2.emp_name);