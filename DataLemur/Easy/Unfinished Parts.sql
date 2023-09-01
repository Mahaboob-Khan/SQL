/*
Unfinished Parts [Tesla SQL Interview Question]
================================================
Learnings from the problem
	1. SELECT the data from the table and apply the flter on finish date column to identify the unfinished parts
	
Order of Execution:
	=> FROM => WHERE => SELECT
*/
SELECT
     part
    ,assembly_step
FROM 
    parts_assembly
WHERE
    finish_date IS NULL;