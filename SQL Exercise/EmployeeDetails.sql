-- THESE QUERIES ARE SOME COMMON QUERIES AROUND EMPLOYEE DATA
===================================================================================
-- DROP tables if they exist
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Create employees table 
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    hire_date DATE,
    gender VARCHAR(1), -- "M"/"F" (male/female)
    salary INT,
    department_id INT
);

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO departments VALUES(1, 'Sales');
INSERT INTO departments VALUES(2, 'Marketing');
INSERT INTO departments VALUES(3, 'IT');
INSERT INTO departments VALUES(4, 'Customer Relation');
INSERT INTO departments VALUES(5, 'Human Resources');

INSERT INTO employees VALUES (501559, 'Carson', 'Mosconi', 'cmosconi0@census.gov', '2015/08/29', 'M', 32973, 1);
INSERT INTO employees VALUES (144108, 'Khalil', 'Corr', 'kcorr1@github.io', '2014/04/23', 'M', 52802, 2);
INSERT INTO employees VALUES (782284, 'Vilhelmina', 'Rayman', 'vrayman2@jigsy.com', '2015/08/17', 'F', 57855, 2);
INSERT INTO employees VALUES (225709, 'Eleen', 'Tarpey', 'etarpey3@devhub.com', '2016/09/14', 'F', 48048, 3);
INSERT INTO employees VALUES (614903, 'Hamel', 'Grocock', 'hgrocock4@nasa.gov', '2016/03/27', 'M', 66566, 3);
INSERT INTO employees VALUES (590293, 'Frazier', 'Balls', 'fballs5@nydailynews.com', '2021/12/22', 'M', 15235, 3);
INSERT INTO employees VALUES (243999, 'Jeremy', 'Whitlam', 'jwhitlam6@nydailynews.com', '2014/01/21', 'M', 41159, 4);
INSERT INTO employees VALUES (599230, 'Webb', 'Hevey', 'whevey7@wikia.com', '2010/04/27', 'M', 48477, 4);
INSERT INTO employees VALUES (758331, 'Katharine', 'Sexcey', 'ksexcey8@harvard.edu', '2014/07/03', 'F', 23772, 5);
INSERT INTO employees VALUES (561012, 'Barton', 'Lillow', 'blillow9@cam.ac.uk', '2015/08/17', 'M', 15083, 5);
INSERT INTO employees VALUES (938560, 'Samantha', 'Newall', 'snewalla@comsenz.com', '2013/08/10', 'F', 10223, 2);
INSERT INTO employees VALUES (746871, 'Joshua', 'Winscum', 'jwinscumb@sciencedirect.com', '2022/12/29', 'M', 28232, 2);
INSERT INTO employees VALUES (75097, 'Wally', 'Huebner', 'whuebnerc@dmoz.org', '2020/08/30', 'F', 57731, 4);
INSERT INTO employees VALUES (659627, 'Austen', 'Waterhouse', 'awaterhoused@infoseek.co.jp', '2011/06/25', 'M', 32946, 1);
INSERT INTO employees VALUES (755091, 'Clem', 'Kitchingman', 'ckitchingmane@pinterest.com', '2014/07/23', 'M', 46818, 4);
INSERT INTO employees VALUES (925779, 'Pavel', 'Butchard', 'pbutchardf@opera.com', '2016/09/21', 'M', 35003, 5);
INSERT INTO employees VALUES (510410, 'Tarra', 'Rolin', 'troling@omniture.com', '2019/03/21', 'F', 27191, 4);
INSERT INTO employees VALUES (353657, 'Brigham', 'Boucher', 'bboucherh@army.mil', '2016/03/09', 'M', 38899, 2);
INSERT INTO employees VALUES (877425, 'Horten', 'Byre', NULL, '2022/05/21', 'M', 40458, 5);
INSERT INTO employees VALUES (608868, 'Annabelle', 'Ottiwill', 'aottiwillj@wordpress.com', '2016/07/19', 'F', 54857, 5);
INSERT INTO employees VALUES (593979, 'Rockie', 'Meriot', 'rmeriotk@usda.gov', '2011/07/29', 'M', 45651, 4);
INSERT INTO employees VALUES (649417, 'Terese', 'Monshall', 'tmonshalll@miibeian.gov.cn', '2010/02/09', 'F', 13829, 1);
INSERT INTO employees VALUES (125157, 'Bartolomeo', 'Gossage', 'bgossagem@squarespace.com', '2019/03/31', 'M', 17474, 4);

===================================================================================
-- WHERE clause + AND & OR
select * from employees where salary > 50000;
select * from employees where department_id = 1;
select * from employees where department_id = 2 AND salary > 20000;
select * from employees where department_id = 2 OR gender = 'M';

===================================================================================
-- IN, NOT IN, IS NULL, BETWEEN
select * from employees where department_id IN (1,2);
select * from employees where salary BETWEEN 35000 AND 50000;
select * from employees where first_name NOT IN ('Eleen', 'Horten');
select * from employees where email IS NULL;

===================================================================================
-- ORDER BY, LIMIT, DISTINCT, Renaming columns
select * from employees ORDER BY salary DESC;
select * from employees ORDER BY salary LIMIT 5;	This query works if there are no duplicates, if there are duplicates and you want to retieve TOP 5 employees by salary then the query would be different
select DISTINCT department_id from employees;
select employee_id as ID, hire_date as JoiningDate from employees;

===================================================================================
-- MIN, MAX, AVG, SUM, COUNT
select employee_id, MIN(salary) from employees;
select employee_id, MAX(salary) from employees;
select AVG(salary) from employees WHERE department_id = 1;
select SUM(salary) from employees WHERE department_id = 5;
select COUNT(*) as number_of_employees from employees WHERE department_id = 4;

===================================================================================
-- GROUP BY, ORDER BY & HAVING
-- Return the number of employees for each department
select count(employee_id) as NoOfEmployees, department_id as DEPT from employees GROUP BY department_id;

-- Return the total salaries for each department adn order them in descending order
select SUM(salary) as total_salary, department_id as Dept from employees GROUP by department_id ORDER BY total_salary DESC;

-- After GROUP BY, return only the departments with a minimum salary of less than 15k
SELECT
	department_id, 
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
    MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY department_id
HAVING MIN(salary) < 15000
ORDER BY num_of_emp DESC; 
===================================================================================
-- CASE If pay is less than 50k, then low pay, otherwise high pay
select  employee_id,
		salary,
		CASE 
        WHEN salary < 50000 THEN 'Low Pay'
        WHEN salary >= 50000 THEN 'High Pay'
		ELSE 'No Pay'
        END as Category
from employees;
===================================================================================
-- Return the number of employees in each pay category
WITH PayCategory AS
(
  select  employee_id,
		salary,
		CASE 
        WHEN salary < 50000 THEN 'Low Pay'
        WHEN salary >= 50000 THEN 'High Pay'
		ELSE 'No Pay'
        END as Category
from employees
)
select count(employee_id) as Number_Of_Emmployees, Category from PayCategory Group by Category;

-- SOME ADVANCED QUERIES
===================================================================================
-- Find the second highest salary for each departement
WITH DeptRankSalary AS
(
  select department_id, salary, DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as RankedSalary
  from employees 
)
select department_id, salary as SecondHighest from DeptRankSalary WHERE RankedSalary = 2 GROUP BY department_id ;

--  Write a query to find the second highest salary in an employee table
WITH SalaryRanking AS
(
  select employee_id, salary,
  		 DENSE_RANK() OVER(ORDER BY salary DESC) as SalaryRank
  from employees
)
select employee_id, salary as SecondHighest from SalaryRanking WHERE SalaryRank = 2;

===================================================================================
-- Find employees whose salary is above the average salary of their department.
WITH AVGDept AS (
    SELECT 
        department_id, 
        AVG(salary) AS average
    FROM employees
    GROUP BY department_id
)

select E.employee_id, E.first_name || ' ' || E.last_name AS full_name, E.department_id from employees E
JOIN AVGDept A ON E.department_id = A.department_id
WHERE E.salary > A.average;

===================================================================================
-- Find the average salary difference between male and female employees within each department. Return the department name, average male salary, average female salary, and the difference.
SELECT 
    d.department_name,
    ROUND(AVG(CASE WHEN e.gender = 'M' THEN e.salary END), 2) AS avg_male_salary,
    ROUND(AVG(CASE WHEN e.gender = 'F' THEN e.salary END), 2) AS avg_female_salary,
    ROUND(ABS(
        COALESCE(AVG(CASE WHEN e.gender = 'M' THEN e.salary END), 0) - 
        COALESCE(AVG(CASE WHEN e.gender = 'F' THEN e.salary END), 0)
    ), 2) AS salary_difference
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY salary_difference DESC;

===================================================================================
-- Identify the department(s) where the difference between the highest-paid and lowest-paid employee is the greatest. Return the department name, highest salary, lowest salary, and the difference.
select 
	d.department_name,
    MAX(salary) as maximum_dept_salary,
    MIN(salary) as minimum_dept_salary,
    ROUND(ABS(MAX(salary) - MIN(salary)),2) as salary_difference
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY salary_difference DESC;

-- Assign a rank to each employee based on their salary within their department. If two employees have the same salary, they should have the same rank.
select  employee_id,
		first_name || '' || last_name as employee_name,
        salary,
        department_id,
        DENSE_RANK() OVER(PARTITION BY department_id ORDER by salary DESC) as RankedSalary	-- I have user DENSE RANK because when the data set contains duplicate, the same rank will be given and no skipping of ranks will also be done
 from employees;

===================================================================================
DROP TABLE IF EXISTS EmployeeProjects;
DROP TABLE IF EXISTS Projects;

--Create the tables and insert values
CREATE TABLE EmployeeProjects
(
  employee_id integer,
  project_id integer
);

CREATE TABLE Projects
(project_id integer);

INSERT INTO EmployeeProjects VALUES
(1,101),(1,102),(1,103),(1,104),(1,105),(1,106),(1,107),(1,108),(1,109),(1,110),
(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),
(3,101),(3,103),(3,105),(3,107),(3,109),
(4,101),(4,105),(4,108),(4,110),
(5,101),(5,102),(5,103),
(6,101),(6,102),(6,105),(6,107),(6,109),
(7,105),(7,104),(7,103),(7,102),(7,101),
(8,101),(8,104),(8,106),(8,107),(8,108),
(9,101),(9,102),(9,103),(9,104),(9,105),(9,106),(9,107),(9,108),(9,109),(9,110),
(10,101),(10,102),(10,103),(10,104);

INSERT INTO Projects VALUES(101),(102),(103),(104),(105),(106),(107),(108),(109),(110);

===================================================================================
-- Identify employees who work on all the available projects
select EmployeeProjects.employee_id from EmployeeProjects
group by EmployeeProjects.employee_id
HAVING COUNT(DISTINCT project_id) = (select COUNT(DISTINCT project_id) from Projects);

===================================================================================
-- Retrieve the employee IDs of employees who are assigned to more than five project.
select EmployeeProjects.employee_id from EmployeeProjects
group by EmployeeProjects.employee_id
HAVING COUNT(DISTINCT project_id) > 5;

===================================================================================
-- Detect Employees Working on Consecutive Project IDs
WITH ConsProjects AS
(
  select 
  		employee_id,
  		project_id,
  		LEAD(project_id) OVER(PARTITION by employee_id order by project_id) as later_project
  from EmployeeProjects
 )
 
 select employee_id, project_id, later_project from ConsProjects where later_project - project_id = 1 group by employee_id;

===================================================================================
 -- Assign a rank to employees based on the number of projects they are working on, with employees working on the most projects ranked highest.
 select employee_id,
 		COUNT(DISTINCT project_id) as NumberOfAssignedProjects,
        DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT project_id) DESC) as Employee_Rank
 from EmployeeProjects
 group by employee_id;
 





 
