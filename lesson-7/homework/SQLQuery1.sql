use class7;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);


INSERT INTO Customers VALUES 
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');

select *from Customers
select *from  Orders
select *from  OrderDetails
select *from  Products

--1️ Retrieve All Customers With Their Orders (Include Customers Without Orders)
--Use an appropriate JOIN to list all customers, their order IDs, and order dates.
--Ensure that customers with no orders still appear.

select c.CustomerName,o.OrderID,o.OrderDate
from Customers as c
left join Orders as o
on c.customerid=o.customerid 


--2️ Find Customers Who Have Never Placed an Order
--Return customers who have no orders.

select c.CustomerName,o.OrderID
from Customers as c
left join Orders as o
on c.CustomerID=o.CustomerID 
where o.OrderID is null



--3️ List All Orders With Their Products
--Show each order with its product names and quantity.
select o.OrderID,p.ProductName,o.Quantity
from OrderDetails as o
join products as p
on o.ProductID=p.ProductID


--4️ Find Customers With More Than One Order
--List customers who have placed more than one order.
select c.CustomerName,c.customerid
from customers as c
join orders as o
on c.CustomerID=o.CustomerID 
group by c.CustomerName,c.CustomerID
having count(o.customerID)>=2 

--5️ Find the Most Expensive Product in Each Order

SELECT ProductName, Price
FROM (
    SELECT 
        p.ProductName,
        od.Price,
        ROW_NUMBER() OVER (PARTITION BY od.OrderID ORDER BY od.Price DESC) AS rn
    FROM OrderDetails AS od
    JOIN Products AS p ON od.ProductID = p.ProductID
) AS ranked
WHERE rn = 1;


--6️ Find the Latest Order for Each Customer
select CustomerName, OrderDate
from(
select c.CustomerName,o.OrderDate,
row_number() over(partition by c.customername order by o.orderdate desc) as rn
from Customers as c
join orders as o
on c.CustomerID=o.CustomerID
) as ranked
where rn=1

--7️ Find Customers Who Ordered Only 'Electronics' Products
--List customers who only purchased items from the 'Electronics' category.
select c.CustomerName
from Customers as c
join Orders as o
on c.CustomerID=o.CustomerID
join OrderDetails as ord
on o.OrderID=ord.OrderID
join products as p
on ord.ProductID=p.ProductID 
group by c.CustomerName,c.CustomerID
having count(distinct case when p.Category<>'Electronics' then p.ProductID end)=0 
and count(distinct p.ProductID)>0



--8️ Find Customers Who Ordered at Least One 'Stationery' Product
--List customers who have purchased at least one product from the 'Stationery' category.
select c.CustomerName
from Customers as c
join Orders as o
on c.CustomerID=o.CustomerID
join OrderDetails as ord
on o.OrderID=ord.OrderID
join products as p
on ord.ProductID=p.ProductID 
group by c.CustomerName,c.CustomerID
having count(distinct case when p.Category<>'Electronics' then p.ProductID end)=1
and count(distinct p.ProductID)>0


--9️ Find Total Amount Spent by Each Customer
--Show CustomerID, CustomerName, and TotalSpent.

select c.CustomerID,c.CustomerName,
sum(ord.quantity*ord.price) as TotalSpent
from Customers as c
join Orders as o
on c.CustomerID=o.CustomerID
join OrderDetails as ord
on o.OrderID=ord.OrderID
group by c.customerID,c.customerName


