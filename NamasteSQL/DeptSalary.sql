-- Using SUBSTRING, CHARINDEX, LEN, GROUP BY
SELECT 
   SUBSTRING(id_deptname, CHARINDEX('-', id_deptname)+1, LEN(id_deptname) - CHARINDEX('-', id_deptname)) AS dept_name
  ,SUM(salary) AS total_salary
FROM NamasteSQL.Dept_tbl
GROUP BY SUBSTRING(id_deptname, CHARINDEX('-', id_deptname)+1, LEN(id_deptname) - CHARINDEX('-', id_deptname));

-- Using RIGHT, CHARINDEX, LEN, GROUP BY
SELECT 
   RIGHT(id_deptname, LEN(id_deptname) - CHARINDEX('-', id_deptname)) AS dept_name
  ,SUM(salary) AS total_salary
FROM NamasteSQL.Dept_tbl
GROUP BY RIGHT(id_deptname, LEN(id_deptname) - CHARINDEX('-', id_deptname));

-- Using PARSENAME, REPLACE, GROUP BY
SELECT 
   PARSENAME(REPLACE(id_deptname, '-', '.'),1) AS dept_name
  ,SUM(salary) AS total_salary
FROM NamasteSQL.Dept_tbl
GROUP BY PARSENAME(REPLACE(id_deptname, '-', '.'),1);