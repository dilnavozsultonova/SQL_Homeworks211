
CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

select * from Employees


 ;WITh EmployeeHierarchy AS (
   
    SELECT 
        EmployeeID,
        Jobtitle,
        ManagerID,
        0 AS Depth
    FROM Employees 
    WHERE ManagerID IS NULL

    UNION ALL

   
	 SELECT 
        e.EmployeeID,
        e.JobTitle,
        e.ManagerID,
        Depth + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)

SELECT *
FROM EmployeeHierarchy
ORDER BY Depth, ManagerID, EmployeeID;




declare @nums int=10

;with cte as 
(
select 1 as num,1 as factorial
union all

select 
num+1, 
factorial*(num+1) 
from cte
where num+1<=@nums
)
select * from cte




declare @number int=10

;with fibonacci_num as
(
	select 
	 1 as n,
	 1 as Fibonacci_Number,
	 0 as previous
	 union all

	 select 
	 n+1,
	 Fibonacci_Number+previous,
	 Fibonacci_Number
	 from fibonacci_num
	 where n+1<=@number
)
select n,Fibonacci_Number from fibonacci_num