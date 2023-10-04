-- CTE - Identified the Employees having maximum & minimum salary
-- GROUP BY on dep_id and MAX of emp_name to identify the employee names
WITH max_min_salary AS (
SELECT
   dep_id
  ,CASE
      WHEN salary=MAX(salary) OVER(PARTITION BY dep_id) THEN emp_name
   END AS max_salary_emp
  ,CASE
      WHEN salary=MIN(salary) OVER(PARTITION BY dep_id) THEN emp_name
   END AS min_salary_emp
FROM Employee)

SELECT
   dep_id
  ,MAX(max_salary_emp) AS max_salary_emp
  ,MAX(min_salary_emp) AS min_salary_emp
FROM max_min_salary
GROUP BY dep_id;