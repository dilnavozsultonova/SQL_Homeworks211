create database class8;
go
use class8;
DROP TABLE IF EXISTS Groupings;

CREATE TABLE Groupings
(
StepNumber  INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NOT NULL,
[Status]    VARCHAR(100) NOT NULL
);
INSERT INTO Groupings (StepNumber, TestCase, [Status]) 
VALUES
(1,'Test Case 1','Passed'),
(2,'Test Case 2','Passed'),
(3,'Test Case 3','Passed'),
(4,'Test Case 4','Passed'),
(5,'Test Case 5','Failed'),
(6,'Test Case 6','Failed'),
(7,'Test Case 7','Failed'),
(8,'Test Case 8','Failed'),
(9,'Test Case 9','Failed'),
(10,'Test Case 10','Passed'),
(11,'Test Case 11','Passed'),
(12,'Test Case 12','Passed');

-----------------------------------------

DROP TABLE IF EXISTS [dbo].[EMPLOYEES_N];

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
)
 
INSERT INTO [dbo].[EMPLOYEES_N]
VALUES
	(1001,'Pawan','1975-02-21'),
	(1002,'Ramesh','1976-02-21'),
	(1003,'Avtaar','1977-02-21'),
	(1004,'Marank','1979-02-21'),
	(1008,'Ganesh','1979-02-21'),
	(1007,'Prem','1980-02-21'),
	(1016,'Qaue','1975-02-21'),
	(1155,'Rahil','1975-02-21'),
	(1102,'Suresh','1975-02-21'),
	(1103,'Tisha','1975-02-21'),
	(1104,'Umesh','1972-02-21'),
	(1024,'Veeru','1975-02-21'),
	(1207,'Wahim','1974-02-21'),
	(1046,'Xhera','1980-02-21'),
	(1025,'Wasil','1975-02-21'),
	(1052,'Xerra','1982-02-21'),
	(1073,'Yash','1983-02-21'),
	(1084,'Zahar','1984-02-21'),
	(1094,'Queen','1985-02-21'),
	(1027,'Ernst','1980-02-21'),
	(1116,'Ashish','1990-02-21'),
	(1225,'Bushan','1997-02-21');

	select * from [dbo].[EMPLOYEES_N]

drop table if exists groupings

--Find all the year-based intervals from 1975 up to current when the company did not hire employees.

select * from Groupings

SELECT 
    MIN(StepNumber) AS [MinStepNumber],
    MAX(StepNumber) AS [MaxStepNumber],
    [Status],
    COUNT(*) AS [Consecutive Count]
FROM (
    SELECT 
        StepNumber,
        [Status],
        StepNumber - ROW_NUMBER() OVER (PARTITION BY [Status] ORDER BY StepNumber) AS GroupID
    FROM Groupings
) AS t
GROUP BY GroupID, [Status]
ORDER BY MinStepNumber;




SELECT * 
FROM (
    SELECT 
        HireYear,
        NextYear,
        IntervalYear,
        CASE 
            WHEN IntervalYear < 2 OR HireYear < 1975 THEN NULL
            WHEN IntervalYear >= 2 AND NextYear IS NOT NULL THEN 
                CAST(HireYear + 1 AS NVARCHAR) + '-' + CAST(NextYear - 1 AS NVARCHAR)
            WHEN NextYear IS NULL THEN 
                CAST(HireYear + 1 AS NVARCHAR) + '-' + CAST(YEAR(GETDATE()) AS NVARCHAR)
        END AS Years
    FROM (
        SELECT 
            CAST(YEAR(Hire_Date) AS INT) AS HireYear,
            LEAD(CAST(YEAR(Hire_Date) AS INT)) OVER (ORDER BY Hire_Date) AS NextYear,
            LEAD(CAST(YEAR(Hire_Date) AS INT)) OVER (ORDER BY Hire_Date) 
                - CAST(YEAR(Hire_Date) AS INT) AS IntervalYear
        FROM Employees_N
    ) AS t
) AS t2
WHERE Years IS NOT NULL
ORDER BY HireYear;
