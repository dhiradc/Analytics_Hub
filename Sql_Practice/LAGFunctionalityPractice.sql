-- THESE QUERIES ARE RELATED TO LAG FUNCTIONALITY - you can use these to practice LAG KEYWORD in SQL - code is suited for SqliteViz
-- Write a query to find the previous sales amount for each employee for each sale date
==========================================================================================================
CREATE TABLE EmployeeSales
(
  	employee_id	integer,
    sale_date datetime,
    sales_amount integer
);

insert into EmployeeSales values
(101,'2023-01-01',500),
(101,'2023-01-05',700),
(101,'2023-01-10',400),
(102,'2023-01-01',300),
(102,'2023-01-04',600);

WITH previousSales AS
(
  select employee_id,
		sale_date,
  		sales_amount,
		LAG(sales_amount) OVER(PARTITION by employee_id order by sale_date) as prev_sale
  from EmployeeSales)
  
  select * from previousSales;

==========================================================================================================
-- Write a query to find the status change for each order. Your result should include the order_id, status_date, the current status, and the previous status.
CREATE TABLE OrderStatus
(
  order_id integer,
  status string,
  status_date datetime);
  
 INSERT INTO OrderStatus VALUES
 (1,'Pending','2023-01-01'),
 (1,'Shipped','2023-01-03'),
 (1,'Delivered','2023-01-05'),
 (2,'Pending','2023-01-02'),
 (2,'Cancelled','2023-01-04');
 
 WITH statusChange as
 (
   select order_id,
   		status_date,
   		status,
   		LAG(status) OVER(partition by order_id order by status_date) as previous_status
   from OrderStatus)
   
   select order_id, status_date, status as currentStatus, previous_status as previousStatus from statusChange;
==========================================================================================================   
-- Write a query to calculate the day-over-day price difference for each stock.
CREATE TABLE StockPrices
(
  stock_symbol string,
  trade_date datetime,
  closing_price ineger);
  
 INSERT INTO StockPrices values
 ('AAPL','2023-01-01',150),
 ('AAPL','2023-01-02',155),
 ('AAPL','2023-01-03',152),
 ('MSFT','2023-01-01',230),
 ('MSFT','2023-01-02',232);
 
 WITH consPrice AS
 (
   select stock_symbol, trade_date, closing_price,
   LAG(closing_price) OVER(partition by stock_symbol order by trade_date) as previousPrice
   FROM StockPrices)
   
 select stock_symbol, trade_date, closing_price, previousPrice, (closing_price - previousPrice)  as day_over_day from consPrice;
 ==========================================================================================================
 -- Write a query to calculate the time difference (in hours) between consecutive logins for each user.
 CREATE TABLE UserLogins
 (
   user_id integer,
   login_time datetime
 );
   
 insert into UserLogins values
 (1,'2023-01-01 08:00:00'),
 (1,'2023-01-01 15:00:00'),
 (1,'2023-01-02 10:00:00'),
 (2,'2023-01-01 09:00:00'),
 (2,'2023-01-03 11:00:00');
 
 WITH consLogins as
 (
   select 
   user_id,
   login_time,
   LAG(login_time) OVER(PARTITION BY user_id order by login_time) as Prev_Login
 from UserLogins)
 
 SELECT 
   user_id,
   login_time,
   Prev_Login,
   CAST((JulianDay(login_time) - JulianDay(Prev_Login)) * 24 AS INTEGER) AS time_difference_in_hours
FROM consLogins;
==========================================================================================================
-- Write a query to rank the players based on their scores for each game date. Then use the LAG function to calculate the rank change for each player over time.
CREATE TABLE PlayerScores
(
  player_id	integer,
  game_date datetime,
  score integer 
);

insert into PlayerScores values
(1,'2023-01-01',80),
(1,'2023-01-02',85),
(1,'2023-01-03',90),
(2,'2023-01-01',70),
(2,'2023-01-02',75),
(2,'2023-01-03',95);

WITH Ranked AS(
	select 
	player_id,
  	game_date,
	RANK() OVER(partition by game_date order by score DESC) as PlayerRank
	from PlayerScores),
   RankChange AS
    (select 
     player_id,
     game_date,
     PlayerRank as latestRank, 
     LAG(PlayerRank) Over(PARTITION BY player_id order by game_date) as previousRank
     from Ranked)
     
  select player_id,game_date, latestRank, COALESCE(latestRank - previousRank, 0) AS ChangeOfRank from RankChange;
  ==========================================================================================================
  -- Write a query to calculate the cumulative sales for each region on each day. Additionally, include the sales amount from the previous day in the result.
  CREATE TABLE SalesData
  (
    region string,
    sale_date datetime,
    sales_amount integer);
    
  INSERT INTO SalesData values
  ('North','2023-01-01',500),
  ('North','2023-01-02',600),
  ('North','2023-01-03',550),
  ('South','2023-01-01',300),
  ('South','2023-01-02',400);
  
 WITH previousDaySale AS
 (
   select region,sale_date, sales_amount, LAG(sales_amount) OVER(PARTITION BY region ORDER BY sale_date) as previousSaleRecord 
   from SalesData)

select region,sale_date, SUM(sales_amount+previousSaleRecord) as TotalSales from previousDaySale group by region, sale_date;
==========================================================================================================
-- Write a query to detect gaps between consecutive sessions for each user. Return the user_id, session_start, session_end, and the gap in minutes.
CREATE TABLE WebSessions
(
  user_id integer,
  session_start	datetime,
  session_end datetime
);

INSERT INTO WebSessions VALUES
(1,'2023-01-01 10:00:00','2023-01-01 11:00:00'),
(1,'2023-01-01 12:00:00','2023-01-01 13:00:00'),
(1,'2023-01-01 15:00:00','2023-01-01 16:00:00'),
(2,'2023-01-01 09:00:00','2023-01-01 09:30:00'),
(2,'2023-01-01 10:00:00','2023-01-01 10:15:00');

WITH consecutiveSessions AS
(
  select user_id, session_start, session_end, lag(session_end) over(PARTITION BY user_id order by session_end) AS LastSessionEnd from WebSessions)
  
select user_id, session_start, session_end, (strftime('%s', session_start) - strftime('%s', LastSessionEnd))/60 AS time_difference_in_mins from consecutiveSessions;
==========================================================================================================
-- Write a query to calculate the revenue difference between the current and previous quarter for each company
CREATE TABLE QuarterlyRevenue
(
  company_id integer,
  quarter varchar,
  revenue integer
 );
 
 INSERT INTO QuarterlyRevenue VALUES
 (1,'Q1-2023',1000),
 (1,'Q2-2023',1200),
 (1,'Q3-2023',1100),
 (2,'Q1-2023',1500),
 (2,'Q2-2023',1600);
 
 WITH lastQuarter AS
 (
   select company_id, quarter, revenue, LAG(revenue) OVER(PARTITION BY company_id ORDER BY quarter) AS LastQuarterRevenue from QuarterlyRevenue)
   
 select company_id, quarter, revenue as CurrentRevenue, LastQuarterRevenue, (revenue - LastQuarterRevenue) as difference_between_revenues from lastQuarter where LastQuarterRevenue IS NOT NULL;
  
   
 
 







