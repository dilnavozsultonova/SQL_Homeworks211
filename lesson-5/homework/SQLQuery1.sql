create database class5;
go
use class5;

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Jack', 'HR', 52000, '2021-03-29');

select * from Employees

--Assign a Unique Rank to Each Employee Based on Salary

--Find Employees Who Have the Same Salary Rank

--Identify the Top 2 Highest Salaries in Each Department

--Find the Lowest-Paid Employee in Each Department

--Calculate the Running Total of Salaries in Each Department

--Find the Total Salary of Each Department Without GROUP BY

--Calculate the Average Salary in Each Department Without GROUP BY

--Find the Difference Between an Employee’s Salary and Their Department’s Average

--Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)

--Find the Sum of Salaries for the Last 3 Hired Employees

--Calculate the Running Average of Salaries Over All Previous Employees

--Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After

--Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary



-- 1. Assign a Unique Rank to Each Employee Based on Salary
SELECT *,
       RANK() OVER (ORDER BY Salary DESC) AS salary_rank
FROM Employees;


-- 2. Find Employees Who Have the Same Salary Rank
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS salary_rank
    FROM Employees
) AS ranked
WHERE salary_rank IN (
    SELECT salary_rank
    FROM (
        SELECT DENSE_RANK() OVER (ORDER BY Salary DESC) AS salary_rank, COUNT(*) AS cnt
        FROM Employees
        GROUP BY Salary
    ) AS r
    WHERE cnt > 1
);


-- 3. Identify the Top 2 Highest Salaries in Each Department
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rn
    FROM Employees
) AS ranked
WHERE rn <= 2;


-- 4. Find the Lowest-Paid Employee in Each Department
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rn
    FROM Employees
) AS ranked
WHERE rn = 1;


-- 5. Calculate the Running Total of Salaries in Each Department
SELECT *,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS running_total
FROM Employees;


-- 6. Find the Total Salary of Each Department Without GROUP BY
SELECT *,
       SUM(Salary) OVER (PARTITION BY Department) AS total_salary
FROM Employees;


-- 7. Calculate the Average Salary in Each Department Without GROUP BY
SELECT *,
       AVG(Salary) OVER (PARTITION BY Department) AS avg_salary
FROM Employees;


-- 8. Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT *,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS salary_diff_from_avg
FROM Employees;


-- 9. Calculate the Moving Average Salary Over 3 Employees (Current, Previous, and Next)
SELECT *,
       AVG(Salary) OVER (ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_3
FROM Employees;


-- 10. Find the Sum of Salaries for the Last 3 Hired Employees (SQL Server version)
SELECT SUM(Salary) AS last_3_hires_total
FROM (
    SELECT TOP 3 Salary
    FROM Employees
    ORDER BY HireDate DESC
) AS last3;


-- 11. Calculate the Running Average of Salaries Over All Previous Employees
SELECT *,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM Employees;


-- 12. Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
SELECT *,
       MAX(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS sliding_max
FROM Employees;


-- 13. Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary
SELECT *,
       CAST((Salary * 100.0 / SUM(Salary) OVER (PARTITION BY Department)) AS DECIMAL(5,2)) AS salary_pct_of_dept
FROM Employees;
