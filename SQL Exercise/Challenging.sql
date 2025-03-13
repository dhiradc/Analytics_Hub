💡 Medium Level:
1️⃣ Write a query to find the second highest salary in an employee table.
create table Employees
(
  Employee_ID integer,
  Employee_Name string,
  Employee_Salary integer
);

insert into Employees values (1,'JOHN', 7000), (2,'SARAH', 9000), (3,'JOSE', 5000), (4, 'MAX', 6000);

select Employees.Employee_ID, Employees.Employee_Name from Employees ORDER BY Employees.Employee_Salary DESC  LIMIT 1 OFFSET 1;
/*this is if there are no duplicate salaries. If there is a duplicate then we have to use DENSE_RANK() function.*/

2️⃣ Fetch all employees whose names contain the letter “a” exactly twice.
WITH CountofEmployees AS
(SELECT 
    first_name,
    (LENGTH(first_name) - LENGTH(REPLACE(first_name, 'a', ''))) AS occurrence_count
FROM 
    employees)
    
select E.first_name, E.last_name from employees E
JOIN CountofEmployees CE ON CE.first_name = E.first_name
where CE.occurrence_count = 2;

3️⃣ How do you retrieve only duplicate records from a table?
Create TABLE Duplicates
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
select ID, Name, Profession from DUP where DRN >= 2;

4️⃣ Write a query to calculate the running total of sales by date.
CREATE TABLE Sales
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
ORDER BY sale_date;

5️⃣ Find employees who earn more than the average salary in their department.
/* I have used the employees table created above for this query too*/
With AVGSalaryDept as
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
ORDER BY E.department_id;

6️⃣ Write a query to find the most frequently occurring value in a column.
/* This query can be changed to find second most, third mosrt or any number as its using DENSE_RANK() function which ranks each group uniquely. Using a LIMIT keyword will only return one result which might not be correct
if the table can contain duplicate values for count of value occuring in the column count.
Here, I have used the same employee table and tried to find the most frequently occuring department_id for the column department_id*/

WITH GROUPEDOCCURANCE AS
(SELECT department_id, 
 		COUNT(department_id) as frequency,
		DENSE_RANK() OVER(ORDER BY COUNT(department_id) DESC) as DRN
FROM employees
GROUP by department_id)

select department_id,frequency from GROUPEDOCCURANCE where DRN = 1;

7️⃣ Fetch records where the date is within the last 7 days from today.
CREATE TABLE PurchasesToday
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

select * from PurchasesToday where sale_date BETWEEN DATE(format(date(),'mm/dd/yyyy'), '-7 days') AND format(date(),'mm/dd/yyyy') ;

8️⃣ Write a query to count how many Customers share the same expenditure.
create table CustomerExpenditure
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
 
  select count(customer_id) as numberOfCustomer, amount as Expenditure from CustomerExpenditure group by amount;
  
9️⃣ How do you fetch the top 2 records for each group in a table?
/* I have resued the employees table and grouped by department_id and found employees who have the TOP 2 salaries. You can use this for any number associated to detecting the TOP<number> */
With RANKS AS
(
  select employee_id,salary,department_id, DENSE_RANK() OVER(PARTITION by department_id ORDER BY salary DESC) as DRN from employees
)

select employee_id,salary,department_id from RANKS where DRN <=2;

🔟 Retrieve products that were never sold.
CREATE TABLE Products
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
 WHERE O.order_id IS NULL;
 
💡 Challenging Level:
1️⃣ Retrieve customers who made their first purchase in the last 6 months.
create table Customers
(
  customer_id integer,
  name string,
  email string,
  join_date date
);

create table Purchases
(
  purchase_id integer,
  customer_id integer,
  purchase_date date,
  amount integer
);

insert into Customers values (1,'Alice Smith','alice@email.com','2023-08-15'),(2,'Bob Johnson','bob@email.com','2023-10-20'),(3,'Charlie Lee','charlie@email.com','2024-01-05'),
						(4,'David Brown','david@email.com','2024-02-18'),(5,'Alice Rock','R_Alice@email.com','2024-08-15'),(6,'Bob Marley','bob_marley@email.com','2024-10-20');
insert into Purchases values (101,1,'2023-09-01',50),(102,2,'2023-11-05',100),(103,3,'2024-01-10',75),(104,4,'2024-02-20',200),
					   (105,1,'2023-10-01',50),(106,2,'2023-12-05',100),(107,3,'2024-10-10',75),(108,4,'2024-05-20',200),
                                     (109,1,'2024-09-30',200), (110,2, '2025-01-01',500),(111,5,'2024-10-01',50),(112,5,'2024-11-05',100),(113,6,'2025-01-10',75),(114,6,'2025-02-20',200);

select customer_id, MIN(purchase_date) as first_purchase_date from Purchases 
group by customer_id
HAVING MIN(purchase_date) BETWEEN DATE(format(date(),'mm/dd/yyyy'), '-6 months') AND format(date(),'mm/dd/yyyy');

2️⃣ How do you pivot a table to convert rows(horizontal) into columns(vertical)?
CREATE TABLE ProductsRows
(
  product_id integer,
  store1 integer,
  store2 integer,
  store3 integer
);

INSERT INTO ProductsRows VALUES (0,95,100,105), (1,70,null,80); 

select product_id as Product,
	   'store1' as store,
	   store1 as price
from ProductsRows
UNION
select product_id as Product,
	   'store2' as store,
	   store2 as price
from ProductsRows
UNION
select product_id as Product,
	   'store3' as store,
	   store3 as price
from ProductsRows;

3️⃣ Write a query to calculate the percentage change in sales month-over-month.
CREATE TABLE monthly_sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sale_date DATE NOT NULL,
    sales_amount NUMERIC NOT NULL
);

INSERT INTO monthly_sales (sale_date, sales_amount) VALUES
('2024-01-01', 10000),
('2024-02-01', 12000),
('2024-03-01', 9000),
('2024-04-01', 15000),
('2024-05-01', 17000),
('2024-06-01', 16000),
('2024-07-01', 19550),
('2024-08-01', 20000),
('2024-09-01', 21020),
('2024-10-01', 22400),
('2024-11-01', 23550),
('2024-12-01', 37000);

WITH CHANGEPERMONTH AS
(
  SELECT strftime('%m', sale_date) as month, 
  		 sales_amount as CurrentMonthSales,
  		 LAG(sales_amount) OVER(ORDER BY sale_date) AS One_month_before
  from monthly_sales
),
percentageChange AS
(
  select month,
  		 CurrentMonthSales,
  		 ROUND(((CurrentMonthSales - One_month_before) * 100.0) / One_month_before, 2) as percentage_change
  from CHANGEPERMONTH
 )

SELECT * from percentageChange;

4️⃣ Find the median salary of employees in a table.
create table Employees
(
  Employee_ID integer,
  Employee_Name string,
  Employee_Salary integer
);

insert into Employees values (1,'JOHN', 7000), (2,'SARAH', 9000), (3,'JOSE', 5000), (4, 'MAX', 6000);
WITH CTE AS
(select *,
		ROW_NUMBER() OVER(ORDER BY Employee_Salary ASC) as RN_ASC,
        	ROW_NUMBER() OVER(ORDER BY Employee_Salary DESC) as RN_DESC        
from Employees)

select AVG(Employee_Salary) from CTE WHERE ABS(RN_ASC - RN_DESC) <= 1;
/* this query will work for both even number of records as well as odd number of records*/

5️⃣ Fetch all users who logged in consecutively for 3 days
CREATE TABLE user_logins (
    user_id INTEGER NOT NULL,
    login_date DATE NOT NULL
);

INSERT INTO user_logins (user_id, login_date) VALUES
(1, '2024-03-01'),
(1, '2024-03-02'),
(1, '2024-03-03'),
(1, '2024-03-05'),
(2, '2024-03-01'),
(2, '2024-03-02'),
(2, '2024-03-04'),
(3, '2024-03-10'),
(3, '2024-03-11'),
(3, '2024-03-12'),
(3, '2024-03-13'),
(4, '2024-03-01'),
(4, '2024-03-02');

WITH consLogins as
 (
   select 
   user_id,
   login_date,
   LAG(login_date) OVER(PARTITION BY user_id order by login_date) as Prev_Login,
   LEAD(login_date) OVER(PARTITION BY user_id order by login_date) as Next_Login
 from user_logins)
 
select user_id from consLogins
where  julianday(login_date) - julianday(Prev_Login) = 1 AND julianday(Next_Login) - julianday(login_date) = 1 group by user_id;

6️⃣ Write a query to delete duplicate rows while keeping one occurrence(the first one is maintained).
Create TABLE Duplicates
(
  ID integer,
  Name string,
  Profession string
);

INSERT INTO Duplicates VALUES (1, 'Joe','Teacher'), (2, 'Sally', 'Lawyer'), (3, 'Hans', 'Doctor'), (4, 'Joe', 'Teacher'), (5, 'Rick', 'Doctor'), 
							  (6, 'Kim', 'Police'), (7, 'Riche', 'Lawyer'),(8, 'Sally', 'Lawyer'), (9, 'Harry', 'Actor'), (10, 'Megan', 'Business Woman'),
							  (11, 'Olga','Teacher'), (12, 'Sam', 'Doctor'), (13, 'Yedi', 'Doctor'), (14, 'Patrick', 'Teacher'), (15, 'Larry', 'Police'), 
                              (16, 'Kim', 'Police'), (17, 'Riche', 'Lawyer'),(18, 'Kiden', 'Lawyer'), (19, 'Merisa', 'Actor'), (20, 'Heather', 'Business Woman');*/

WITH DUP as 
(select ID, Name, Profession, DENSE_RANK() OVER(PARTITION BY Name, Profession ORDER BY ID ASC) as DRN
from Duplicates)
DELETE from Duplicates where ID IN (select ID from DUP where DRN >= 2);

7️⃣ Create a query to calculate the ratio of sales between two categories.
CREATE TABLE sales_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    sales_amount NUMERIC NOT NULL
);

INSERT INTO sales_data (category, sales_amount) VALUES
('Electronics', 50000),
('Furniture', 30000),
('Electronics', 60000),
('Furniture', 40000),
('Electronics', 55000),
('Furniture', 35000),
('Electronics',25000),
('Furniture', 60000),
('Electronics',15000),
('Furniture', 23000);

WITH RATIOCOUNT AS
(select category, 
 		SUM(sales_amount) as TotalSales,
 		ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS RN
 from sales_data group by category)
SELECT ROUND((SELECT TotalSales from RATIOCOUNT where RN = 1)*1.0/(SELECT TotalSales from RATIOCOUNT where RN = 2),2) as Sales_Ratio;
/* This query is very generic provided there are only two categories of products in the master data table. You dont need to know the category names as you are applying row number to the two rows of summation achieved.*/

8️⃣ How would you implement a recursive query to generate a hierarchical structure?
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    manager_id INTEGER REFERENCES employees(id)
);

INSERT INTO employees (id, name, manager_id) VALUES
(1, 'Alice', NULL), 
(2, 'Bob', 1), 
(3, 'Carol', 1), 
(4, 'Dave', 2), 
(5, 'Eve', 2), 
(6, 'Frank', 3);
WITH RECURSIVE employee_hierarchy AS (
    -- Base case: Select the top-level manager (CEO)
    SELECT 
        id, 
        name, 
        manager_id, 
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: Find employees reporting to the previous level
    SELECT 
        e.id, 
        e.name, 
        e.manager_id, 
        eh.level + 1 AS level
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.id
)
SELECT * FROM employee_hierarchy ORDER BY level, id;

9️⃣ Write a query to find gaps in sequential numbering within a table.
CREATE TABLE SeqItems (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

INSERT INTO SeqItems (id, name) VALUES (1, 'Item A');
INSERT INTO SeqItems (id, name) VALUES (2, 'Item B');
INSERT INTO SeqItems (id, name) VALUES (3, 'Item C');

-- Introduce a gap by skipping id 4
INSERT INTO SeqItems (id, name) VALUES (5, 'Item D');

-- Alternatively, insert and delete a row to create a gap
INSERT INTO SeqItems (name) VALUES ('Item E'); -- Auto-assigns id 6
DELETE FROM SeqItems WHERE id = 6;

-- now carry on with few more insertions
INSERT INTO SeqItems (id, name) VALUES (7, 'Item F');
INSERT INTO SeqItems (id, name) VALUES (8, 'Item G');
INSERT INTO SeqItems (id, name) VALUES (9, 'Item H');
INSERT INTO SeqItems (id, name) VALUES (10, 'Item I');

WITH Sequential AS
(select 
 		id as Current_Value,
		LAG(id) OVER(ORDER BY ID ASC) as Prev_Value
from SeqItems),
RecursiveMissing AS (
    -- Base case: Select the first missing number
    SELECT Prev_Value + 1 AS MissingNumber, Current_Value
    FROM Sequential
    WHERE Prev_Value IS NOT NULL AND Current_Value - Prev_Value > 1

    UNION ALL

    -- Recursive case: Increment MissingNumber until it reaches Current_Value - 1
    SELECT MissingNumber + 1, Current_Value
    FROM RecursiveMissing
    WHERE MissingNumber + 1 < Current_Value
)
SELECT MissingNumber FROM RecursiveMissing;

🔟 Split FULL NAME in first name and last name
CREATE TABLE UserName
(
  id integer,
  fullname string
 );
 
 INSERT INTO UserName values
 (1, 'JOHN DOE'),
 (2, 'SARAH SMITH'),
 (3, 'JOE HANK');

SELECT 
SUBSTRING(fullname, 1, CHARINDEX(' ', fullname) - 1) AS FirstName, 
SUBSTRING(fullname, CHARINDEX(' ', fullname) + 1, length(fullname)) AS LastName
FROM UserName;

💡 Advanced Problem-Solving:
1️⃣ Rank products by sales in descending order for each region.
CREATE TABLE product_sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    region TEXT NOT NULL,
    product_name TEXT NOT NULL,
    sales_amount NUMERIC NOT NULL
);

INSERT INTO product_sales (region, product_name, sales_amount) VALUES
('North', 'Laptop', 50000),('North', 'Smartphone', 75000),('North', 'Tablet', 40000),('North', 'Headphones', 25000),('North', 'Smartwatch', 30000),('South', 'Laptop', 60000),('South', 'Smartphone', 80000),
('South', 'Tablet', 45000),('South', 'Headphones', 20000),('South', 'Smartwatch', 35000),('East', 'Laptop', 70000),('East', 'Smartphone', 85000),('East', 'Tablet', 42000),('East', 'Headphones', 30000),
('East', 'Smartwatch', 32000),('West', 'Laptop', 65000),('West', 'Smartphone', 90000),('West', 'Tablet', 48000),('West', 'Headphones', 28000),('West', 'Smartwatch', 34000);

select region, product_name, sales_amount,
  		 DENSE_RANK() OVER(PARTITION BY region Order by sales_amount DESC) as RankedProducts
from product_sales;

2️⃣ Fetch all employees whose salaries fall within the top 10% of their department.
CREATE TABLE EmployeesDepartment
(
  employee_id integer,
  department_id integer,
  salary integer
);

INSERT INTO EmployeesDepartment values
(1,1,17000),(2,1,18000),(3,1,17000),(4,1,28000),(5,1,19000),(6,1,18500),(7,1,25000),(8,1,15500),(9,1,70000),(10,1,20000),
(11,2,16000),(12,2,17500),(13,2,25000),(14,2,21500),(15,2,26000),(16,2,37500),(17,2,46000),(18,2,20000),(19,2,36000),(20,2,37500),
(21,3,90000),(22,3,70000),(23,3,80000),(24,3,30000),(25,3,20000),(26,3,14000),(27,3,23000),(28,3,34000),(29,3,60000),(30,3,54000),(31,3,67000);

WITH SalaryRank AS (
select employee_id, department_id, salary, 
  RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank,
  COUNT(*) OVER (PARTITION BY department_id) AS total_employees from EmployeesDepartment
)
SELECT employee_id, department_id, salary
FROM SalaryRank
WHERE salary_rank <= (0.10*total_employees);

3️⃣ Identify orders placed during business hours (e.g., 9 AM to 6 PM).
CREATE TABLE OrdersPlaced (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    order_datetime DATETIME NOT NULL
);

INSERT INTO OrdersPlaced (customer_id, order_datetime) VALUES
(101, '2024-03-01 08:30:00'), -- Before business hours
(102, '2024-03-01 09:15:00'), -- Business hours
(103, '2024-03-01 10:45:00'), -- Business hours
(104, '2024-03-01 12:30:00'), -- Business hours
(105, '2024-03-01 14:00:00'), -- Business hours
(106, '2024-03-01 17:55:00'), -- Business hours
(107, '2024-03-01 18:05:00'), -- After business hours
(108, '2024-03-01 20:45:00'), -- After business hours
(109, '2024-03-02 09:30:00'), -- Business hours
(110, '2024-03-02 15:15:00'), -- Business hours
(111, '2024-03-02 16:45:00'), -- Business hours
(112, '2024-03-02 18:10:00'), -- After business hours
(113, '2024-03-02 07:50:00'), -- Before business hours
(114, '2024-03-02 11:25:00'), -- Business hours
(115, '2024-03-02 14:35:00'), -- Business hours
(116, '2024-03-02 17:50:00'), -- Business hours
(117, '2024-03-02 21:30:00'), -- After business hours
(118, '2024-03-03 10:10:00'), -- Business hours
(119, '2024-03-03 12:05:00'), -- Business hours
(120, '2024-03-03 19:20:00'); -- After business hours 

SELECT * FROM OrdersPlaced
WHERE strftime('%H', order_datetime) BETWEEN '09' AND '17';

4️⃣ Write a query to get the count of users active on both weekdays and weekends.
CREATE TABLE UserLoginData (
    login_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    login_datetime DATETIME NOT NULL
);

INSERT INTO UserLoginData (user_id, login_datetime) VALUES
(1, '2024-03-01 08:15:00'), -- Weekday
(1, '2024-03-02 09:00:00'), -- Weekend
(1, '2024-03-03 18:30:00'), -- Weekend
(2, '2024-03-01 09:00:00'), -- Weekday
(2, '2024-03-02 14:00:00'), -- Weekend
(2, '2024-03-03 08:45:00'), -- Weekend
(3, '2024-03-01 08:00:00'), -- Weekday
(3, '2024-03-03 10:30:00'), -- Weekend
(3, '2024-03-04 11:00:00'), -- Weekday
(4, '2024-03-01 16:15:00'), -- Weekday
(4, '2024-03-02 15:30:00'), -- Weekend
(4, '2024-03-03 13:00:00'), -- Weekend
(5, '2024-03-01 07:45:00'), -- Weekday
(5, '2024-03-05 09:30:00'), -- Weekday
(6, '2024-03-01 17:00:00'), -- Weekday
(6, '2024-03-04 19:15:00'), -- Weekday
(7, '2024-03-02 20:00:00'), -- Weekend
(7, '2024-03-03 21:30:00'), -- Weekend
(8, '2024-03-02 11:00:00'), -- Weekend
(8, '2024-03-03 12:00:00'); -- Weekend

WITH detect AS
(
select 	user_id, 
		login_datetime, 
		case when strftime('%w', login_datetime) in ('0', '6') then 1 else 0 end as is_weekend -- here 1 means its weekend, 0 means its weekday
from UserLoginData
),
loginBothDays AS(
select user_id,
		SUM(CASE WHEN is_weekend = 1 THEN 1 ELSE 0 END) as CNTWE,
        	SUM(CASE WHEN is_weekend = 0 THEN 1 ELSE 0 END) as CNTWD
from detect
group by user_id)

select COUNT(DISTINCT user_id) from loginBothDays where CNTWE > 0 AND CNTWD > 0;

5️⃣ Retrieve customers who made purchases across at least three different categories.
create table CustomerSales(
sale_id INTEGER PRIMARY KEY,
customer_id INTEGER,
product_id INTEGER,
sale_date DATE);
create table Products
(
  product_id integer,
  product_name string,
  product_category string
);

INSERT INTO CustomerSales (sale_id, customer_id, product_id, sale_date) VALUES
(1, 1, 101, '2024-01-01'),
(2, 1, 102, '2024-01-02'),
(3, 1, 103, '2024-01-03'),
(4, 2, 101, '2024-01-04'),
(5, 2, 102, '2024-01-05'),
(6, 3, 101, '2024-01-06'),
(7, 3, 102, '2024-01-07'),
(8, 3, 103, '2024-01-08'),
(9, 3, 104, '2024-01-09'),
(10, 4, 101, '2024-01-10'),
(11, 4, 102, '2024-01-11'),
(12, 4, 103, '2024-01-12'),
(13, 5, 102, '2024-01-11'),
(14, 5, 101, '2024-01-12'),
(15, 6, 102, '2024-02-11');

insert into Products values (101,'IPhone16', 'Smartphone'),(102, 'IPad', 'Tablet'),(103, '13"M2', 'Macbook'),(104, 'DellWasher', 'Washer');

WITH CustomerPurchaseCategory AS(
select C.customer_id, C.product_id, P.product_category as ProductCategory
from CustomerSales C JOIN Products P ON C.product_id = P.product_id),
DetectCategoryCount AS
( select customer_id, COUNT(DISTINCT ProductCategory) as ProductsPurchased from CustomerPurchaseCategory group by customer_id)

select customer_id from DetectCategoryCount where ProductsPurchased >= 3;