create database class6;
go 
use class6;


-- Table: Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);



-- Table: Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


-- Table: Projects
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    EmployeeID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Insert values into Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Insert values into Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000.00),
(2, 'Bob', 102, 70000.00),
(3, 'Charlie', 101, 65000.00),
(4, 'David', 103, 72000.00),
(5, 'Eva', NULL, 68000.00);

-- Insert values into Projects
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);


select * from Departments
select* from Employees
select* from Projects

--INNER JOIN

--Write a query to get a list of employees along with their department names.
Select 
e.EmployeeId,
e.Name as EmpName,
d.DepartmentName
from Employees as e
join Departments as d
on e.DepartmentID=d.DepartmentId

--LEFT JOIN

--Write a query to list all employees, including those who are not assigned to any department.
Select e.Name,e.employeeid,e.DepartmentID,d.departmentName,d.DepartmentID
from employees as e
left join departments as d
on e.DepartmentID=d.DepartmentID


--RIGHT JOIN

--Write a query to list all departments, including those without employees.
Select e.Name,e.EmployeeID,d.DepartmentName,d.DepartmentID
from employees as e
right join departments as d
on e.DepartmentID=d.DepartmentID


--FULL OUTER JOIN

--Write a query to retrieve all employees and all departments, even if there’s no match between them.
Select e.Name,e.EmployeeID,e.DepartmentID,e.Salary,d.DepartmentName,d.DepartmentID
from employees as e
full outer join departments as d
on e.DepartmentID=d.DepartmentID


--JOIN with Aggregation

--Write a query to find the total salary expense for each department.
SELECT d.DepartmentName, SUM(e.Salary) AS TotalSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;



--CROSS JOIN

--Write a query to generate all possible combinations of departments and projects.
select * from Departments,Projects


--MULTIPLE JOINS

--Write a query to get a list of employees with their department names and assigned project names. Include employees even if they don’t have a project.

select e.EmployeeID,e.Name,d.DepartmentName,p.ProjectName
from employees as e
join departments as d
on e.DepartmentID=d.DepartmentID
left join projects as p
on e.EmployeeID=p.EmployeeID
