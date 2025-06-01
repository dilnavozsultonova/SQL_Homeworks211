
-- ==============================================================
--                          Puzzle 1 DDL                         
-- ==============================================================
drop table if exists employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);

drop table if exists #EmployeesTransfers
CREATE TABLE #EmployeesTransfers (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO #EmployeesTransfers	 (EmployeeID, Name, Department, Salary)
select employeeid,
       name ,
	   case 
		when department='HR' then 'IT'
		when department='IT' then 'Sales'
		when department='Sales' then 'HR'
		else Department
		end as Department,
		Salary
		from Employees

select * from #EmployeesTransfers

--Create a temporary table #EmployeeTransfers with the same structure as Employees.
--Swap departments for each employee in a circular manner:
--HR → IT → Sales → HR
--Example: Alice (HR) moves to IT, Bob (IT) moves to Sales, Charlie (Sales) moves to HR.
--Insert the updated records into #EmployeeTransfers.
--Retrieve all records from #EmployeeTransfers.



-- ==============================================================
--                          Puzzle 2 DDL
-- ==============================================================

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);

select * from Orders_DB1 
select * from Orders_DB2 

--Declare a table variable @MissingOrders with the same structure as Orders_DB1.
--Insert all orders that exist in Orders_DB1 but not in Orders_DB2 into @MissingOrders.
--Retrieve the missing orders.

declare  @MissingOrders table(
	OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO @MissingOrders (CustomerName, Product, Quantity, OrderID)
SELECT 
    CustomerName,
    Product,
    Quantity,
    OrderID
FROM Orders_DB1
WHERE OrderID NOT IN (SELECT OrderID FROM Orders_DB2);

 select * from @MissingOrders
   

-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);

select * from WorkLog

--Create a view vw_MonthlyWorkSummary that calculates:
--EmployeeID, EmployeeName, Department, TotalHoursWorked (SUM of hours per employee).
--Department, TotalHoursDepartment (SUM of all hours per department).
--Department, AvgHoursDepartment (AVG hours worked per department).
--Retrieve all records from vw_MonthlyWorkSummary.

create View vw_MonthlyWorkSummary 
as select distinct EmployeeID,EmployeeName,Department,
sum(HoursWorked)over(partition by EmployeeName )As TotalHoursWorked,
sum(HoursWorked)over(partition by department) as TotalHoursDepartment,
avg(HoursWorked)over(partition by department) as AvgHoursDepartment
from WorkLog

select * from vw_MonthlyWorkSummary