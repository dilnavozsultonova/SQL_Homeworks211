create table student(
	id int ,
	name nvarchar(50),
	age int 
);

 select *from student

 alter table student
 alter column id int not null;

 create table product(
	product_id int unique,
	product_name nvarchar(max),
	price decimal
  );
   
   alter table product
   add constraint UC_product_id unique(product_id);

  alter table product
  drop constraint UC_product_id;

  create table orders(
	order_id int primary key,
	customer_name nvarchar(50),
	order_date date
  );

  ALTER TABLE [dbo].[orders] DROP CONSTRAINT [PK__orders__465962298D6C8042]

  alter table orders
  add constraint [PK__orders__465962298D6C8042] primary key(order_id);

  create table category(
	category_id int primary key,
	category_name nvarchar(max),
 );

 create table item(
	item_id int primary key,
	item_name nvarchar(max),
	category_id int foreign key references category(category_id)
 
 );


 ALTER TABLE [dbo].[item] DROP CONSTRAINT [FK__item__category_i__49C3F6B7]

 alter table item
 add constraint  [FK__item__category_i__49C3F6B7] foreign key(category_id) references category(category_id);

 create table account(
	account_id int primary key,
	balance decimal check(balance>=0),
	account_type nvarchar(50) check(account_type in ('Saving','Checking'))
 );

 ALTER TABLE [dbo].[account] DROP CONSTRAINT [CK__account__account__4E88ABD4]

 alter table account
 add constraint  [CK__account__account__4E88ABD4] check (balance>=0);

 ALTER TABLE [dbo].[account] DROP CONSTRAINT [CK__account__balance__4D94879B]

ALTER TABLE account
ADD CONSTRAINT [CK__account__balance__4D94879B] 
CHECK (account_type IN ('Saving', 'Checking'));

create table customer(
	customer_id int primary key,
	name nvarchar(50),
	city nvarchar(max) default('Unknown')
);

ALTER TABLE [dbo].[customer] DROP CONSTRAINT [DF__customer__city__534D60F1]

alter table customer
add constraint [DF__customer__city__534D60F1] 
default 'Unknown' for city

 create table invoice(
	 invoice_id INT IDENTITY(1,1) PRIMARY KEY,
	 amount decimal 
  );

 INSERT INTO invoice (amount) VALUES (100.50);
INSERT INTO invoice (amount) VALUES (200.75);
INSERT INTO invoice (amount) VALUES (150.30);
INSERT INTO invoice (amount) VALUES (50.00);
INSERT INTO invoice (amount) VALUES (300.90);


SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id, amount) VALUES (100, 250.00);

SET IDENTITY_INSERT invoice OFF;


create table books(
	book_id int identity primary key,
	title nvarchar(max) not null,
	price decimal check(price>=0),
	genre nvarchar(max) default('Unknown')
);

INSERT INTO books (title, price, genre) 
VALUES ('The Great Gatsby', 10.99, 'Fiction');

INSERT INTO books (title, price, genre) 
VALUES ('1984', 8.49, 'Dystopian');

INSERT INTO books (title, price, genre) 
VALUES ('To Kill a Mockingbird', 12.99, 'Classic');


INSERT INTO books (title, price) 
VALUES ('Moby Dick', 15.99);

INSERT INTO books (title, price) 
VALUES ('War and Peace', 20.00);


create table Book(
	book_id int primary key,
	title nvarchar(255),
	author nvarchar(255),
	published_year int
);
 create table Member(
	member_id int primary key,
	name nvarchar(255),
	email nvarchar(255),
	phone_number nvarchar(max)
 );

 create table Loan(
	loan_id int primary key,
	book_id int foreign key references book(book_id),
	member_id int foreign key references member(member_id),
	loan_date date,
	return_date date null

 
 );

 INSERT INTO Book (book_id, title, author, published_year)
VALUES (1, 'The Great Gatsby', 'F. Scott Fitzgerald', 1925),
       (2, '1984', 'George Orwell', 1949),
       (3, 'To Kill a Mockingbird', 'Harper Lee', 1960);
INSERT INTO Member (member_id, name, email, phone_number)
VALUES (1, 'John Doe', 'john.doe@example.com', '123-456-7890'),
       (2, 'Jane Smith', 'jane.smith@example.com', '987-654-3210');
 INSERT INTO Loan (loan_id, book_id, member_id, loan_date, return_date)
VALUES (1, 1, 1, '2025-05-01', '2025-05-10'),  
       (2, 2, 2, '2025-05-03', NULL),          
       (3, 3, 1, '2025-05-05', '2025-05-12'); 

	   SELECT 
    M.name AS MemberName,
    B.title AS BookTitle,
    L.loan_date,
    L.return_date
FROM Loan L
JOIN Member M ON L.member_id = M.member_id
JOIN Book B ON L.book_id = B.book_id;


SELECT 
    B.title AS BookTitle,
    L.loan_date,
    L.return_date
FROM Loan L
JOIN Member M ON L.member_id = M.member_id
JOIN Book B ON L.book_id = B.book_id
WHERE M.name = 'John Doe';

SELECT 
    M.name AS MemberName,
    B.title AS BookTitle,
    L.loan_date
FROM Loan L
JOIN Member M ON L.member_id = M.member_id
JOIN Book B ON L.book_id = B.book_id
WHERE L.return_date IS NULL;


UPDATE Loan
SET return_date = '2025-05-12'
WHERE loan_id = 2;  


DELETE FROM Loan
WHERE loan_id = 3; 