create database class2;
go 
use class2;

drop table if exists test_identity;
create table test_identity(
	id int identity(1,1) primary  key,
	value nvarchar(50)
);

insert into test_identity(value)
values
	('First'),
	('Second'),
	('Third'),
	('Fourth'),
	('Fifth');

select * from test_identity

drop table test_identity;

drop table if exists test_identity;
create table test_identity(
	id int identity(1,1) primary  key,
	value nvarchar(50)
);

insert into test_identity(value)
values
	('First'),
	('Second'),
	('Third'),
	('Fourth'),
	('Fifth');

delete  from test_identity  where id=7;

drop table if exists test_identity;
create table test_identity(
	id int identity(1,1) primary  key,
	value nvarchar(50)
);

insert into test_identity(value)
values
	('First'),
	('Second'),
	('Third'),
	('Fourth'),
	('Fifth');
truncate table test_identity;

create table data_types_demo(
	id int,
	name nvarchar(50),
	birthday date,
	lovely_time time
);

insert into data_types_demo(id,name,birthday,lovely_time)
	values
		(240445,'Dilnavoz','2006-12-22','19:00:00'),
		(240004,'Zilola','2007-02-02','10:00:00'),
		(240005,'Gulhayo','2006-06-06','20:00:00')

select * from data_types_demo

create table photos(
	id  uniqueidentifier,
	photo varbinary(max)
);

insert into photos
select  * from openrowset(
	bulk 'C:\Users\user\documents\waterfall.jpg', single_blob
	) as img;


CREATE TABLE student (
	id INT PRIMARY KEY,              
	name VARCHAR(100),               
	classes INT,                     
	tuition_per_class DECIMAL(10, 2),
	total_tuition AS (classes * tuition_per_class)
);

truncate table student;

INSERT INTO student (id, name, classes, tuition_per_class)
VALUES (1, 'Alice Johnson', 4, 250.00);


INSERT INTO student (id, name, classes, tuition_per_class)
VALUES (2, 'Brian Smith', 6, 180.00);


INSERT INTO student (id, name, classes, tuition_per_class)
VALUES (3, 'Carla Reyes', 3, 300.00);

 select * from student;


 drop table if exists worker;
create table worker
(
	id int primary key identity(1,1),
	name varchar(100)
);

BULK INSERT worker
FROM 'C:\Users\user\documents\workers.csv'
WITH (
	firstrow=2,
	fieldterminator=',',
	rowterminator='\n'
);

select * from worker;
