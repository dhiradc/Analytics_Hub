💡 Medium Level:
1️⃣ Write a query to find the second highest salary in an employee table.
/*
create table Employees
(
  Employee_ID integer,
  Employee_Name string,
  Employee_Salary integer
);

insert into Employees values (1,'JOHN', 7000), (2,'SARAH', 9000), (3,'JOSE', 5000), (4, 'MAX', 6000);

select Employees.Employee_ID, Employees.Employee_Name from Employees ORDER BY Employees.Employee_Salary DESC  LIMIT 1 OFFSET 1;*/
/*this is if there are no duplicate salaries. If there is a duplicate then we have to use DENSE_RANK() function.*/
2️⃣ Fetch all employees whose names contain the letter “a” exactly twice.
/*
WITH CountofEmployees AS
(SELECT 
    first_name,
    (LENGTH(first_name) - LENGTH(REPLACE(first_name, 'a', ''))) AS occurrence_count
FROM 
    employees)
    
select E.first_name, E.last_name from employees E
JOIN CountofEmployees CE ON CE.first_name = E.first_name
where CE.occurrence_count = 2;
*/
3️⃣ How do you retrieve only duplicate records from a table?
/*Create TABLE Duplicates
(
  ID integer,
  Name string,
  Profession string
);

INSERT INTO Duplicates VALUES (1, 'Joe','Teacher'), (2, 'Sally', 'Lawyer'), (3, 'Hans', 'Doctor'), (4, 'Joe', 'Teacher'), (5, 'Rick', 'Doctor'), 
							  (6, 'Kim', 'Police'), (7, 'Riche', 'Lawyer'),(8, 'Sally', 'Lawyer'), (9, 'Harry', 'Actor'), (10, 'Megan', 'Business Woman'),
							  (11, 'Olga','Teacher'), (12, 'Sam', 'Doctor'), (13, 'Yedi', 'Doctor'), (14, 'Patrick', 'Teacher'), (15, 'Larry', 'Police'), 
                              (16, 'Kim', 'Police'), (17, 'Riche', 'Lawyer'),(18, 'Kiden', 'Lawyer'), (19, 'Merisa', 'Actor'), (20, 'Heather', 'Business Woman');

WITH DUP as 
(select ID, Name, Profession, DENSE_RANK() OVER(PARTITION BY Name, Profession ORDER BY ID ASC) as DRN
from Duplicates)

select ID, Name, Profession from DUP where DRN >= 2;*/
4️⃣ Write a query to calculate the running total of sales by date.
/*CREATE TABLE Sales
(
	sale_id	integer,
    product_id integer,
    sale_date datetime,
    sales_amount integer
 ); 
 INSERT INTO Sales VALUES
 (1,101,'2023-01-01',100), (2,101,'2023-01-15',100), (3,101,'2023-02-01',100), (4,102,'2023-01-05',250),(5,102,'2023-02-10',250),
 (6,102,'2023-01-01',250), (7,105,'2023-01-15',200), (8,104,'2023-02-01',250), (9,103,'2023-01-05',150),(10,101,'2023-02-10',100),
 (11,105,'2023-01-01',300), (12,104,'2023-01-15',250), (13,103,'2023-02-01',150), (14,104,'2023-01-05',250),(15,105,'2023-02-10',300),
 (16,103,'2023-01-01',150), (17,103,'2023-01-15',150), (18,102,'2023-02-01',250), (19,101,'2023-01-05',100),(20,104,'2023-02-10',250);
 
 SELECT 
    sale_date,
    SUM(sales_amount) AS daily_sales,
    SUM(SUM(sales_amount)) OVER(ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Sales
GROUP BY sale_date
ORDER BY sale_date;*/
5️⃣ Find employees who earn more than the average salary in their department.
/*With AVGSalaryDept as
(
  select department_id,
  		 AVG(salary) as AVGDeptSalary
  from employees
  group by department_id
)

select E.employee_id, E.first_name || ' ' || E.last_name AS EmployeeName, E.salary as EmployeeSalary, E.department_id, ASD.AVGDeptSalary as Department_AVG_Salary
from employees E JOIN AVGSalaryDept ASD
ON E.department_id = ASD.department_id
WHERE E.salary > ASD.AVGDeptSalary
ORDER BY E.department_id;*/
6️⃣ Write a query to find the most frequently occurring value in a column.
/* This query can be changed to find second most, third mosrt or any number as its using DENSE_RANK() function which ranks each group uniquely. Using a LIMIT keyword will only return one result which might not be correct
if the table can contain duplicate values for count of value occuring in the column count.
Here, I have used the same employee table and tried to find the most frequently occuring department_id for the column department_id
WITH GROUPEDOCCURANCE AS
(SELECT department_id, 
 		COUNT(department_id) as frequency,
		DENSE_RANK() OVER(ORDER BY COUNT(department_id) DESC) as DRN
FROM employees
GROUP by department_id)

select department_id,frequency from GROUPEDOCCURANCE where DRN = 1;*/
7️⃣ Fetch records where the date is within the last 7 days from today.
/*CREATE TABLE PurchasesToday
(
	purchase_id	integer,
    product_id integer,
    sale_date datetime,
    sales_amount integer
 ); 
INSERT INTO PurchasesToday VALUES
(1,101,'2025-02-01',100),
(2,102,'2025-02-02',110),
(3,103,'2025-02-03',115),
(4,104,'2025-02-04',123),
(5,105,'2025-02-05',250),
(6,106,'2025-02-06',223),
(7,107,'2025-02-07',201),
(8,101,'2025-02-08',100),
(9,102,'2025-02-09',110),
(10,103,'2025-02-10',115),
(11,104,'2025-02-11',123),
(12,105,'2025-02-12',250),
(13,106,'2025-02-13',223),
(14,107,'2025-02-14',201),
(15,101,'2025-02-15',100),
(16,102,'2025-02-16',110),
(17,103,'2025-02-17',115),
(18,104,'2025-02-18',123),
(19,105,'2025-02-19',250),
(20,106,'2025-02-20',223),
(21,107,'2025-03-01',201),
(22,101,'2025-03-02',100),
(23,102,'2025-03-03',110),
(24,103,'2025-03-04',115),
(25,104,'2025-03-05',123),
(26,105,'2025-03-06',250),
(27,106,'2025-03-07',223),
(28,107,'2025-03-08',201),
(29,101,'2025-03-09',100),
(30,102,'2025-03-10',110);

select * from PurchasesToday where sale_date BETWEEN DATE(format(date(),'mm/dd/yyyy'), '-7 days') AND format(date(),'mm/dd/yyyy') ;*/
8️⃣ Write a query to count how many Customers share the same expenditure.
/*create table CustomerExpenditure
 (order_id integer,
 customer_id integer, 
 order_date datetime,
 amount integer);
 
 insert into CustomerExpenditure values
 (101,1,'2024-01-10',250),
 (102,2,'2024-01-12',300),
 (103,1,'2024-01-15',150),
 (104,3,'2024-01-18',250),
 (105,2,'2024-01-20',100),
 (106,1,'2024-01-22',200),
 (107,4,'2024-01-25',300),
 (108,5,'2024-01-28',600),
 (109,4,'2024-01-30',250),
 (110,5,'2024-02-02',200);
 
  select count(customer_id) as numberOfCustomer, amount as Expenditure from CustomerExpenditure group by amount;*/
9️⃣ How do you fetch the top 2 records for each group in a table?
/* I have resued the employees table and grouped by department_id and found employees who have the TOP 2 salaries
With RANKS AS
(
  select employee_id,salary,department_id, DENSE_RANK() OVER(PARTITION by department_id ORDER BY salary DESC) as DRN from employees
)

select employee_id,salary,department_id from RANKS where DRN <=2;*/
🔟 Retrieve products that were never sold.
/*CREATE TABLE Products
(
  product_id integer,
  product_name string
);

CREATE TABLE Orders
(
  order_id integer,
  product_id integer,
  order_date datetime
 );
 
 INSERT INTO Products VALUES (1, 'Table'),(2, 'Chair'),(3, 'Sofa'),(4, 'Bed'),(5, 'Mobile'),(6, 'Knife'),(7, 'Plate'),(8, 'Cup'),(9, 'TV'),(10, 'Laptop');
 INSERT INTO Orders VALUES (1,1,'2023-01-10'),(2,2,'2023-01-15'),(3,3,'2023-03-10'),(4,5,'2023-04-15'),(5,5,'2023-05-10'),(6,2,'2023-05-15'),(7,1,'2023-06-10'),(8,6,'2023-06-15'),(9,7,'2023-07-10'),(10,8,'2023-07-15');
 
 select P.product_name from Products P LEFT JOIN Orders O
 ON P.product_id = O.product_id
 WHERE O.order_id IS NULL;*/
💡 Challenging Level:
1️⃣ Retrieve customers who made their first purchase in the last 6 months.
2️⃣ How do you pivot a table to convert rows into columns?
3️⃣ Write a query to calculate the percentage change in sales month-over-month.
4️⃣ Find the median salary of employees in a table.
5️⃣ Fetch all users who logged in consecutively for 3 days or more.
6️⃣ Write a query to delete duplicate rows while keeping one occurrence.
7️⃣ Create a query to calculate the ratio of sales between two categories.
8️⃣ How would you implement a recursive query to generate a hierarchical structure?
9️⃣ Write a query to find gaps in sequential numbering within a table.
🔟 Split a comma-separated string into individual rows using SQL.

💡 Advanced Problem-Solving:
1️⃣ Rank products by sales in descending order for each region.
2️⃣ Fetch all employees whose salaries fall within the top 10% of their department.
3️⃣ Identify orders placed during business hours (e.g., 9 AM to 6 PM).
4️⃣ Write a query to get the count of users active on both weekdays and weekends.
5️⃣ Retrieve customers who made purchases across at least three different categories.