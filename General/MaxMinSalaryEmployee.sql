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

-- Using FIRST_VALUE
SELECT DISTINCT 
   dep_id
  ,FIRST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC) AS max_salary_emp
  ,FIRST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary) AS min_salary_emp
FROM Employee;

-- Using LAST_VALUE - We need to change the default window frame (UNBOUNDED PRECEDING AND CURRENT ROW) to consider all
SELECT DISTINCT 
   dep_id
  ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS max_salary_emp
  ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS min_salary_emp
FROM Employee;

SELECT DISTINCT
   dep_id
  ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_salary_emp
  ,LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_salary_emp
FROM Employee;