-- SQL to track Product Analysis trends 
-- Disclaimer:I found these questions on a public web page while searching queries for self practice. I solved them myself, so uploading it here to help others
=====================================================================
DROP TABLE IF EXISTS trade_in_transactions;
DROP TABLE IF EXISTS trade_in_payouts;

CREATE TABLE trade_in_transactions
(
  	transaction_id	integer,
	model_id	integer,
	store_id	integer,
	transaction_date	date
);

CREATE TABLE trade_in_payouts
(
 	model_id	integer,
	model_name	string,
	payout_amount	integer
);

INSERT INTO trade_in_transactions VALUES
(1,112,512,'01/01/2022'),
(2,113,512,'01/01/2022');
INSERT INTO trade_in_payouts VALUES
(111,'iPhone 11',200),
(112,'iPhone 12',350),
(113,'iPhone 13',450),
(114,'iPhone 13 Pro Max',650);
========================================================================
-- Write a query of the total revenue from the trade-in. Order the result by the descending order.
  
select SUM(TIP.payout_amount) as payout_total, TIT.store_id as store_id
from trade_in_transactions TIT JOIN trade_in_payouts TIP
ON TIT.model_id = TIP.model_id
group by store_id
ORDER BY payout_total DESC;

=====================================================================
-- Write a query to determine the percentage of buyers who bought AirPods directly after they bought iPhones. Round your answer to a percentage (i.e. 20 for 20%, 50 for 50) with no decimals.
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions
(
  transaction_id	integer,
  customer_id	integer,
  product_name	varchar,
  transaction_timestamp	datetime);
  
INSERT INTO TRANSACTIONS VALUES
(1,101,'iPhone','08/08/2022 00:00:00'),
(2,101,'AirPods','08/08/2022 00:00:00'),
(5,301,'iPhone','09/05/2022 00:00:00'),
(6,301,'iPad','09/06/2022 00:00:00'),
(7,301,'AirPods','09/07/2022 00:00:00');

WITH ConsecutiveTrans AS
(
  select	
  	    customer_id,
  		product_name,
  		LAG(product_name) OVER(partition by customer_id ORDER by transaction_timestamp DESC) AS PreviousProduct
  from TRANSACTIONS),
 ConsecutiveCustomers AS
 (
   select customer_id as airpod_iphone_buyers
   from ConsecutiveTrans WHERE 
   		  LOWER(product_name) = 'airpods' AND
   		  LOWER(PreviousProduct) = 'iphone'
    GROUP BY customer_id)

   select ROUND(count(DISTINCT CC.airpod_iphone_buyers) *100/count(DISTINCT TT.customer_id),2) as percentage_of_buyers 
   from TRANSACTIONS TT, ConsecutiveCustomers CC;*/

=====================================================================
-- Write a SQL query to calculate the monthly average rating for each Product
DROP TABLE IF EXISTS reviews;
  
CREATE TABLE reviews
(
  review_id	integer,
  user_id integer,
  submit_date datetime,
  product_id integer,
  stars integer
 );
 
 INSERT INTO reviews VALUES
 (6171,123,'06/08/2022 00:00:00',50001,4),
 (7802,265,'06/10/2022 00:00:00',69852,4),
 (5293,362,'06/18/2022 00:00:00',50001,3),
 (6352,192,'07/26/2022 00:00:00',69852,3),
 (4517,981,'07/05/2022 00:00:00',69852,2);
 
 select substring(submit_date,1,2) as month, product_id, AVG(stars) as average_rating
 from reviews
 group by month, product_id;*/

=====================================================================
-- Write a SQL query to compute the average quantity of each product sold per month for the year 2021
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales;

CREATE TABLE products
(
  product_id integer,
  product_name string
);

CREATE TABLE Sales
(sales_id integer,product_id integer,date_of_sale datetime,quantity_sold integer);

INSERT INTO products VALUES
(1,'iPhone 12'),
(2,'Apple Watch'),
(3,'MacBook Pro');
INSERT INTO sales VALUES
(1,1,'2021-01-10',100),
(2,1,'2021-01-15',200),
(3,2,'2021-01-20',50),
(4,2,'2021-02-15',75),
(5,3,'2021-02-10',20);

select P.product_id, substring(S.date_of_sale,6,2) as month, AVG(S.quantity_sold) as average_sold
from products P join sales S ON P.product_id = S.product_id
where substring(S.date_of_sale, 1,4) = '2021'
group by month, P.product_id
order by average_sold DESC;

=====================================================================
-- Write a SQL query that calculates the add-to-bag conversion rate: defined as 
-- The number of users who add a product to their bag (cart) after clicking on the product listing, divided by the total number of clicks on the product. Break down the result by product_id. MOST IMPORTANT

DROP TABLE IF EXISTS clicks;
DROP TABLE IF EXISTS bag_adds;

CREATE TABLE clicks
(click_id integer,product_id integer,user_id integer,click_time datetime);

INSERT INTO clicks VALUES
(1,5001,123,'06/08/2022 00:00:00'),
(2,6001,456,'06/10/2022 00:00:00'),
(3,5001,789,'06/18/2022 00:00:00'),
(4,7001,321,'07/26/2022 00:00:00'),
(5,5001,654,'07/05/2022 00:00:00');

create TABLE bag_adds
(add_id	intger, product_id integer,user_id integer,add_time datetime);

INSERT INTO bag_adds VALUES
(1,5001,123,'06/08/2022 00:02:00'),
(2,6001,456,'06/10/2022 00:01:00'),
(3,5001,789,'06/18/2022 00:03:00'),
(4,7001,321,'07/26/2022 00:04:00'),
(5,5001,985,'07/05/2022 00:05:00');

WITH AddFromClick AS(
SELECT 
c.product_id,
c.user_id,
sum(case when a.add_id is not null then 1 else 0 end)  as added_to_bag
FROM clicks c
LEFT JOIN bag_adds a ON a.product_id = c.product_id AND a.user_id = c.user_id
GROUP BY c.product_id)

select AF.product_id, AF.user_id, AF.added_to_bag, COUNT(click_id) as clicksDone, AF.added_to_bag/COUNT(click_id) AS Conversion_Rate from clicks C
JOIN AddFromClick AF ON C.product_id = AF.product_id GROUP By C.product_id;

=====================================================================
-- Write a SQL query to determine the percentage of buyers who bought AirPods directly after they bought iPhones. 
  
WITH lag_products AS (
  SELECT
  customer_id,
  product_name,
  LAG(product_name)
    OVER(PARTITION BY customer_id
    ORDER BY transaction_timestamp) AS prev_prod
  FROM transactions
  GROUP BY
  customer_id,
  product_name,
  transaction_timestamp
),
interested_users AS (
  SELECT customer_id AS airpod_iphone_buyers
  FROM lag_products
  WHERE LOWER(product_name) = 'iphone'
    AND LOWER(prev_prod) = 'airpods'
  GROUP BY customer_id
)

SELECT
  COUNT(DISTINCT iu.airpod_iphone_buyers)*100  / COUNT(DISTINCT transactions.customer_id) AS follow_up_percentage
FROM transactions
LEFT JOIN interested_users AS iu
  ON iu.airpod_iphone_buyers = transactions.customer_id;

=====================================================================
-- Calculate the contribution of each product sales to the company’s total revenue
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Sales;

create table Products
(
  	product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    price DECIMAL(10,2)
);
INSERT INTO Products (product_id, product_name, price) VALUES
(1, 'Laptop', 1000.00),
(2, 'Smartphone', 800.00),
(3, 'Tablet', 500.00),
(4, 'Headphones', 200.00),
(5, 'Smartwatch', 300.00);

CREATE TABLE Sales (
    sale_id INTEGER PRIMARY KEY,
    product_id INTEGER,
    quantity INTEGER,
    sale_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Sales (sale_id, product_id, quantity, sale_date) VALUES
(1, 1, 10, '2024-02-01'),
(2, 2, 15, '2024-02-02'),
(3, 3, 20, '2024-02-03'),
(4, 4, 30, '2024-02-04'),
(5, 5, 25, '2024-02-05');

WITH TOTALSALES AS(
select P.product_id, SUM(S.quantity*P.price) as Product_Revenue from Products P 
JOIN Sales S ON P.product_id = S.product_id group by P.product_id
)

select product_id, Product_Revenue, (Product_Revenue*100.00/(select SUM(Product_Revenue) from TOTALSALES)) as ContributionPercentage
from TOTALSALES;

=====================================================================
-- Calculate total sales per department and filter out departments with sales below a specific threshold say 10000.
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS RetailSales;

create table Department
(
  department_id integer,
  department_name string
);
insert into Department VALUES (1,'PhoneSales'), (2, 'TVSales'), (3,'WasherSales'),(4,'ACSAles');
create table RetailSales
(
  department_id integer,
  sales_amount integer,
  sale_date datetime
);
insert into RetailSales VALUES (1, 2000, '2024-01-01'),(1,3000, '2024-01-20'),(1,7000, '2024-02-10'),(2,7000, '2024-01-10'),
(2,3000, '2024-01-15'),(3,300, '2024-01-05'),(4,3000, '2024-01-12'),(4,6000, '2024-02-20'),(4,3000, '2024-02-24');

WITH SalePerDept AS
(select S.department_id, SUM(S.sales_amount) as TotalSalesByDept from RetailSales S GROUP BY S.department_id)

select D.department_id, D.department_name from Department D JOIN SalePerDept PD ON D.department_id = PD.department_id 
WHERE PD.TotalSalesByDept >=10000 order by PD.TotalSalesByDept DESC;

=====================================================================
-- List all customers, highlighting who placed orders and who didn’t.
DROP TABLE IF EXISTS OrdersPlaced;

CREATE TABLE OrdersPlaced
(
  order_id integer,
  customer_id integer,
  total_amount integer
);

insert into OrdersPlaced VALUES (1,1,1000),(2,2,500);

select DISTINCT C.customer_id,
	CASE WHEN OP.order_id IS NULL THEN 'NoOrdersPlaced' ELSE 'OrderPlaced' END as OrderStatus
from Customers C LEFT JOIN OrdersPlaced OP ON C.customer_id = OP.customer_id;*/

=====================================================================
-- Write a query to calculate the average sales amount over a 2-day period for each product_id
-- If your data has sequential rows (like sales transactions, stock prices, or rankings) → Use ROWS BETWEEN
-- If you need a rolling period based on actual date/time or numeric ranges → Use RANGE BETWEEN
DROP TABLE IF EXISTS SalesDataMovingAvg;

create table SalesDataMovingAvg
(
  	sale_id INTEGER,
	sale_date DATE,
	product_id INTEGER,
	sales_amount INTEGER);
    
Insert into SalesDataMovingAvg VALUES (1, '2024-02-10', 1, 500), (2, '2024-02-11', 1, 700),(3, '2024-02-12', 1, 900),(4, '2024-02-10', 2, 1000),(5, '2024-02-11', 2, 1200);

select sale_date, product_id, AVG(sales_amount) OVER(PARTITION BY product_id ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as AvgSalePast2Days FROM SalesDataMovingAvg;



  
  
