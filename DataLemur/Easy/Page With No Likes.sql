/*
Page With No Likes [Facebook SQL Interview Question]
====================================================
Learnings from the problem: Using Subquery
	1. Get the unique list of page ids SELECT DISTINCT from page likes table i.e. Pages having likes
	2. Use the above result to filter the page table and identify the pages with no likes i.e. Usage of NOT IN
	
Order of execution:
	SubQuery / Inner Query (FROM => SELECT DISTINCT) => FROM => WHERE => SELECT => ORDER BY
*/
SELECT
    page_id
FROM pages
WHERE
    page_id NOT IN (
        SELECT DISTINCT page_id 
          FROM
              page_likes)
ORDER BY page_id;

/*
Learnings from the problem: Using LEFT JOIN
	1. Combinings the pages & page_likes tables using LEFT JOIN on a common key i.e. page_id
	2. As LEFT JOIN returns the common key rows between two tables & Keys that are only on LEFT table (rightside table keys will be NULL)
	3. Filter the combined data with rightside table key is NULL i.e. No page likes
	4. Arrange the result set order by page_id using ORDER BY
	
Order of execution:
	SubQuery / Inner Query (FROM => SELECT DISTINCT) => FROM => WHERE => SELECT => ORDER BY
*/
SELECT
    pages.page_id
FROM
    pages 
LEFT JOIN
    page_likes
ON pages.page_id = page_likes.page_id
WHERE
  page_likes.page_id IS NULL
ORDER BY page_id;