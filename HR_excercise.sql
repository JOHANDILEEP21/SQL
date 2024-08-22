USE hr_database;

SHOW TABLES;

SELECT * FROM employees;

-- ------------------------------------------------------------------------------------------------------------------------------
-- Q1 -Employees table has employee IDs as well as manager IDs, Can you display employee names with their reporting manager name. 
-- ------------------------------------------------------------------------------------------------------------------------------

Select e1.employee_id, E1.first_name, e2.manager_id, E2.first_name as Mgrname
from Employees E1
LEFT Join Employees E2 ON E1.manager_id= E2.employee_id
WHERE e2.employee_id IS NULL;
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT e.employee_id, e.first_name, e.manager_id, mr.employee_id, mr.first_name
FROM employees e
JOIN employees mr ON (e.manager_id=mr.employee_id);

-- ------------------------------------------------------------------------------------------------------------------------------
--  Q2 - There are 1000 records in the source and loaded only 999 records into the target, How can we know which record is missing without using Minus Query 
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT e.employee_id, e.manager_id FROM employees e
WHERE e.manager_id IS NULL;

-- ------------------------------------------------------------------------------------------------------------------------------
--  Q3 - Table A and Table B has deptno. Can you find which deptno is not in table A which exists in table B? 
-- ------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM employees e
JOIN employees mr ON (e.employee_id=mr.manager_id);

-- ------------------------------------------------------------------------------------------------------------------------------
--  Q4- Dept wise max salary by not including deptno 10 and having max salary > 10000 order by deptno 
-- ------------------------------------------------------------------------------------------------------------------------------

SELECT e.employee_id, e.department_id,
d.department_name, MAX(e.salary) AS Max_salary
FROM employees e
JOIN departments d ON (e.department_id=d.department_id)
WHERE e.department_id<>10
GROUP BY e.employee_id
HAVING MAX(e.salary)>10000
ORDER BY Max_salary;

-- ------------------------------------------------------------------------------------------------------------------------------
-- Q5- Find total salary by department wise:
-- ------------------------------------------------------------------------------------------------------------------------------

SELECT d.department_name, SUM(e.salary) AS Salary
FROM employees e
JOIN departments d ON (e.department_id=d.department_id)
GROUP BY d.department_id
ORDER BY d.department_name, Salary;

-- ------------------------------------------------------------------------------------------------------------------------------
--  Q6- Find the Duplicate records in Employees table: 
-- ------------------------------------------------------------------------------------------------------------------------------

SELECT e.employee_id, COUNT(*)
FROM employees e
GROUP BY e.employee_id
HAVING COUNT(*)>1;
-- ------------------------------------------------------------------------------------------------------------------------------
--  Q7- Find the count of unique records in the dept column in Employees table: 
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT e.employee_id, COUNT(*)
FROM employees e
GROUP BY e.employee_id
HAVING COUNT(*)=1;

-- ------------------------------------------------------------------------------------------------------------------------------
-- Q8 - Find the employees whose salary is equal to the average of max and min salaries: 
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM employees e
WHERE e.salary = (SELECT (MIN(e1.salary)+MAX(e1.salary))/2 FROM employees e1);
-- ------------------------------------------------------------------------------------------------------------------------------
--  Q9 -List the depts where at least 2 employees working in each group: 
-- ------------------------------------------------------------------------------------------------------------------------------

SELECT e.department_id, COUNT(e.employee_id) AS Employee_count
FROM employees e
GROUP BY e.department_id
HAVING COUNT(e.employee_id)>3;

-- ------------------------------------------------------------------------------------------------------------------------------
-- Q10 - What output you will get here - Count (*) / Count (0) / count (1) / count (2) / count (-1) / count (10000)
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(e.manager_id) FROM employees e; -- 39 manager_id counts
SELECT COUNT(e.employee_id) FROM employees e; -- 40 Employee_id counts

SELECT COUNT(e.employee_id)-COUNT(e.manager_id) FROM employees e;


-- ------------------------------------------------------------------------------------------------------------------------------
-- 11 	With in employees table who is the 2nd highest salary
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM employees e
ORDER BY e.salary DESC
LIMIT 1 OFFSET 1; -- Employee_id: 102, Lex de haan 

-- ------------------------------------------------------------------------------------------------------------------------------
-- 12 within sales department, 2nd highest salary
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM departments;

SELECT *
FROM employees e
WHERE e.department_id=8
ORDER BY e.salary DESC
LIMIT 1 OFFSET 1;

SELECT *
FROM employees e
WHERE e.department_id=8
ORDER BY e.salary DESC;

-- Same answer using Rank FUNCTION
SELECT vt.first_name
FROM (
	SELECT *, RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) AS Rnk
	FROM employees e) AS vt
WHERE vt.department_id=8
AND vt.Rnk=2;

-- ------------------------------------------------------------------------------------------------------------------------------
-- Query the 2nd highest salary in every department
-- ------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM (SELECT *, DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS Rnk
	FROM employees e) AS vt
WHERE vt.rnk=2;

SELECT *
FROM employees e
ORDER BY e.salary DESC;


SELECT e.employee_id, e.first_name, mr.employee_id, mr.first_name
FROM employees e
LEFT JOIN employees mr ON (e.manager_id=mr.employee_id);
