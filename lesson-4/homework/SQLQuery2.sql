CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

select *
from TestMultipleZero
where A!=0 or B!=0 or C!=0 or D!=0

CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

Select *from TestMax
SELECT
    CASE
        WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1
        WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2
        WHEN Max3 >= Max1 AND Max3 >= Max2 THEN Max3
        ELSE                                        Max1
    END AS TheGreatestValue
	from TestMax


SELECT [Year1],
  (SELECT Max(v) 
   FROM (VALUES (Max1), (Max2), (Max3)) AS value(v)) as [MaxNum]
FROM [TestMax]

CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1),
	EmpName VARCHAR(50),
    BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
values
('Pawan' , '04-12-1983'),
('Zuzu' , '28-11-1986'),
('Parveen', '07-05-1977'),
('Mahesh', '13-01-1983'),
 ('Ramesh', '09-05-1983');

 truncate table empbirth

 select * from EmpBirth


SELECT EmpName,BirthDate
from empbirth
where
	MONTH(birthdate)=5 and DAY(birthdate) between 7 and 15


create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

  select * from letters

SELECT letter
FROM letters
ORDER BY 
    CASE WHEN letter = 'b' THEN 0 ELSE 1 END,  -- b comes first
    letter;

SELECT letter
FROM letters
ORDER BY 
    CASE WHEN letter = 'b' THEN 1 ELSE 0 END,  -- b comes last
    letter;
