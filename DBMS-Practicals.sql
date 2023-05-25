-- 1) que
-- a)

create table BOOK (Book_id int , Title varchar(50), Publisher_Name varchar(50), Pub_Year int, No_of_copies int);
create table BOOK_AUTHORS (Book_id int, Author_Name varchar(50));
create table PUBLISHER (Name varchar(50), Address varchar(50), Phone int);

INSERT INTO BOOK (Book_id, Title, Publisher_Name, Pub_Year, No_of_copies)
VALUES (1, 'dbms', 'gobal', 2021, 500);
INSERT INTO BOOK (Book_id, Title, Publisher_Name, Pub_Year, No_of_copies)
VALUES (2, 'sql', 'sanju', 2022, 500);

INSERT INTO BOOK_AUTHORS values (1,'gobal');
INSERT INTO BOOK_AUTHORS values (2,'sanju');

insert into PUBLISHER  value ('gobal','dharapuram',1234567);
insert into PUBLISHER  value ('sanju','coimbatore',745613333);

SELECT b.Book_id, b.Title, b.Pub_Year, b.No_of_copies, ba.Author_Name, p.Name AS Publisher_Name
FROM BOOK b
JOIN BOOK_AUTHORS ba ON b.Book_id = ba.Book_id
JOIN PUBLISHER p ON b.Publisher_Name = p.Name;

-- b) (ERROR)

SELECT BORROWER.*
FROM BORROWER
JOIN BORROWED_BOOKS ON BORROWER.Borrower_id = BORROWED_BOOKS.Borrower_id
WHERE BORROWED_BOOKS.Borrow_Date >= '2017-01-01'
  AND BORROWED_BOOKS.Borrow_Date <= '2017-06-30'
GROUP BY BORROWER.Borrower_id, BORROWER.Name
HAVING COUNT(*) > 3;

-- c)
DELETE FROM BOOK WHERE Book_id = 1;
DELETE FROM BOOK_AUTHORS WHERE Book_id = 2;

-- d
CREATE VIEW AvailableBooks AS
SELECT B.Book_id, B.Title, B.No_of_copies
FROM BOOK B
WHERE B.No_of_copies > 0;

-- e) (ERROR)

CREATE OR REPLACE PROCEDURE DisplayBookDetailsByAuthor(
  author_name IN VARCHAR2
) AS
BEGIN
  FOR book IN (
    SELECT B.Book_id, B.Title, P.Name AS Publisher_Name
    FROM BOOK B
    JOIN BOOK_AUTHORS BA ON B.Book_id = BA.Book_id
    JOIN PUBLISHER P ON B.Publisher_Name = P.Name
    WHERE BA.Author_Name = author_name
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Book ID: ' || book.Book_id);
    DBMS_OUTPUT.PUT_LINE('Title: ' || book.Title);
    DBMS_OUTPUT.PUT_LINE('Publisher Name: ' || book.Publisher_Name);
    DBMS_OUTPUT.PUT_LINE('-------------------------');
  END LOOP;
END;

--------------------------------------------------------------------------

-- 3) que

CREATE TABLE Employee (
    Emp_no INT,
    Emp_name VARCHAR(100),
    Emp_dept VARCHAR(100),
    Job VARCHAR(100),
    Mgr VARCHAR(100),
    Sal DECIMAL(10, 2)
);

INSERT INTO Employee (Emp_no, Emp_name, Emp_dept, Job, Mgr, Sal)
VALUES
    (1, 'John Doe', 'Finance', 'Accountant', 'Manager A', 5000.00),
    (2, 'Jane Smith', 'HR', 'HR Manager', 'Manager B', 6000.00),
    (3, 'Mike Johnson', 'IT', 'Software Engineer', 'Manager C', 7000.00);

SELECT Emp_name, Sal 
FROM Employee
WHERE Emp_dept = 'IT'
GROUP BY Emp_name, Sal;

SELECT Emp_dept, Emp_name, Job, Mgr, Sal
FROM Employee
WHERE (Emp_dept, Sal) IN (
    SELECT Emp_dept, MIN(Sal)
    FROM Employee
    GROUP BY Emp_dept
);

SELECT Emp_name
FROM Employee
ORDER BY Emp_name DESC;

ALTER TABLE Employee
RENAME COLUMN Emp_no TO Employee_no;

CREATE TRIGGER insert_employee
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO Employee (Emp_no, Emp_name, Emp_dept, Job, Mgr, Sal)
    VALUES (1, 'gojo', 'cse', 'software','ghhvh', 500000);
END;

-- select * from Employee;

--------------------------------------------------------------------------

-- 5)que


-- a)
CREATE TABLE Event (
    eventid INT PRIMARY KEY,
    name VARCHAR(100),
    description VARCHAR(100),
    city VARCHAR(100)
);


CREATE TABLE Participant (
    playerid INT PRIMARY KEY,
    name VARCHAR(100),
    eventid INT,
    gender VARCHAR(10),
    year INT,
    FOREIGN KEY (eventid) REFERENCES Event(eventid)
);


CREATE TABLE Prizes (
    prizeid INT PRIMARY KEY,
    prize_money DECIMAL(10, 2),
    eventid INT,
    rank INT,
    year INT,
    FOREIGN KEY (eventid) REFERENCES Event(eventid)
);


CREATE TABLE Winners (
    prizeid INT,
    playerid INT,
    FOREIGN KEY (prizeid) REFERENCES Prizes(prizeid),
    FOREIGN KEY (playerid) REFERENCES Participant(playerid),
    PRIMARY KEY (prizeid, playerid)
);

-- b)
ALTER TABLE Participant
ADD CONSTRAINT playerid_check CHECK (playerid LIKE '%[0-9]%');

-- c)
SELECT e.name
FROM Event e
WHERE NOT EXISTS (
    SELECT *
    FROM Winners w
    INNER JOIN Participant p ON w.playerid = p.playerid
    WHERE w.prizeid IN (
        SELECT prizeid
        FROM Prizes
        WHERE eventid = e.eventid
    ) AND p.gender != 'Female'
);

-- d)
CREATE VIEW FirstPrizeWinners AS
SELECT p.name AS participant_name, e.name AS event_name
FROM Winners w
INNER JOIN Participant p ON w.playerid = p.playerid
INNER JOIN Prizes pr ON w.prizeid = pr.prizeid AND pr.rank = 1
INNER JOIN Event e ON pr.eventid = e.eventid;

-- e)
CREATE TRIGGER CreatePrizes
AFTER INSERT ON Event
FOR EACH ROW
BEGIN
    INSERT INTO Prizes (prizeid, prize_money, eventid, rank, year)
    VALUES
        (NEW.eventid * 10 + 1, 1500.00, NEW.eventid, 1, YEAR(CURRENT_DATE)),
        (NEW.eventid * 10 + 2, 1000.00, NEW.eventid, 2, YEAR(CURRENT_DATE)),
        (NEW.eventid * 10 + 3, 500.00, NEW.eventid, 3,

-------------------------------------------------------------------------

-- 5)  Que

-- Create the Event table
CREATE TABLE Event (
    eventid INT PRIMARY KEY,
    name VARCHAR(100),
    description VARCHAR(100),
    city VARCHAR(100)
);

-- Insert values into the Event table
INSERT INTO Event (eventid, name, description, city)
VALUES
    (1, 'Event1', 'Description1', 'City1'),
    (2, 'Event2', 'Description2', 'City2'),
    (3, 'Event3', 'Description3', 'City3');

-- Create the Participant table
CREATE TABLE Participant (
    playerid VARCHAR(100) PRIMARY KEY CHECK (playerid ~ '[0-9]+'),
    name VARCHAR(100),
    eventid INT,
    gender VARCHAR(10),
    year INT,
    FOREIGN KEY (eventid) REFERENCES Event(eventid)
);

-- Insert values into the Participant table
INSERT INTO Participant (playerid, name, eventid, gender, year)
VALUES
    ('P1', 'Participant1', 1, 'Female', 2021),
    ('P2', 'Participant2', 1, 'Male', 2021),
    ('P3', 'Participant3', 2, 'Female', 2022),
    ('P4', 'Participant4', 2, 'Female', 2022),
    ('P5', 'Participant5', 2, 'Male', 2022),
    ('P6', 'Participant6', 3, 'Female', 2023),
    ('P7', 'Participant7', 3, 'Male', 2023);

-- Create the Prizes table
CREATE TABLE Prizes (
    prizeid INT PRIMARY KEY,
    prize_money DECIMAL(10, 2),
    eventid INT,
    rank INT,
    year INT,
    FOREIGN KEY (eventid) REFERENCES Event(eventid)
);

-- Insert values into the Prizes table
INSERT INTO Prizes (prizeid, prize_money, eventid, rank, year)
VALUES
    (1, 1500, 1, 1, 2021),
    (2, 1000, 1, 2, 2021),
    (3, 500, 1, 3, 2021),
    (4, 1500, 2, 1, 2022),
    (5, 1000, 2, 2, 2022),
    (6, 500, 2, 3, 2022),
    (7, 1500, 3, 1, 2023),
    (8, 1000, 3, 2, 2023),
    (9, 500, 3, 3, 2023);

-- Create the Winners table
CREATE TABLE Winners (
    prizeid INT,
    playerid VARCHAR(100),
    FOREIGN KEY (prizeid) REFERENCES Prizes(prizeid),
    FOREIGN KEY (playerid) REFERENCES Participant(playerid)
);

-- Insert values into the Winners table
INSERT INTO Winners (prizeid, playerid)
VALUES
    (1, 'P1'),
    (2, 'P2'),
    (4, 'P3'),
    (6, 'P4'),
    (9, 'P6');

-- a)
  
Here are the appropriate primary keys and foreign keys for the tables:

Event:

Primary Key: eventid
Participant:

Primary Key: playerid
Foreign Key: eventid (references Event)
Prizes:

Primary Key: prizeid
Foreign Key: eventid (references Event)
Winners:

Foreign Key: prizeid (references Prizes)
Foreign Key: playerid (references Participant)

--b)
CREATE TABLE Participant (
    playerid VARCHAR(100) PRIMARY KEY CHECK (playerid ~ '[0-9]+'),
    name VARCHAR(100),
    eventid INT,
    gender VARCHAR(10),
    year INT,
    FOREIGN KEY (eventid) REFERENCES Event(eventid)
);

-- c)
SELECT e.name
FROM Event e
WHERE NOT EXISTS (
    SELECT *
    FROM Winners w
    INNER JOIN Participant p ON w.playerid = p.playerid
    WHERE w.prizeid IN (
        SELECT prizeid
        FROM Prizes
        WHERE eventid = e.eventid
    ) AND p.gender <> 'Female'
);

-- d)
CREATE VIEW FirstPrizeWinners AS
SELECT p.name AS participant_name, e.name AS event_name
FROM Participant p
JOIN Winners w ON p.playerid = w.playerid
JOIN Prizes pr ON w.prizeid = pr.prizeid AND pr.rank = 1
JOIN Event e ON pr.eventid = e.eventid;

-- e)
CREATE OR REPLACE FUNCTION create_prizes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Prizes (prizeid, prize_money, eventid, rank, year)
    VALUES (DEFAULT, 1500, NEW.eventid, 1, NEW.year),
           (DEFAULT, 1000, NEW.eventid, 2, NEW.year),
           (DEFAULT, 500, NEW.eventid, 3, NEW.year);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_prizes_trigger
AFTER INSERT ON Event
FOR EACH ROW
EXECUTE FUNCTION create_prizes();

-------------------------------------------------------------------------
-- 7) que

-- Create the STUDENT table
CREATE TABLE STUDENT (
    RegNo INT PRIMARY KEY,
    StudName VARCHAR(100),
    Address VARCHAR(100),
    Phone VARCHAR(20),
    Gender VARCHAR(10)
);
-- Insert values into the STUDENT table
INSERT INTO STUDENT (RegNo, StudName, Address, Phone, Gender)
VALUES
    (1, 'John Doe', '123 Main St', '123-456-7890', 'Male'),
    (2, 'Jane Smith', '456 Elm St', '987-654-3210', 'Female'),
    (3, 'Mike Johnson', '789 Oak St', '555-123-4567', 'Male');

-- Create the SUBJECT table
CREATE TABLE SUBJECT (
    Subcode INT PRIMARY KEY,
    Title VARCHAR(100),
    Sem INT,
    Credits INT
);

-- Insert values into the SUBJECT table
INSERT INTO SUBJECT (Subcode, Title, Sem, Credits)
VALUES
    (1, 'Mathematics', 1, 4),
    (2, 'Physics', 2, 3),
    (3, 'Chemistry', 1, 3);

-- Create the MARKS table
CREATE TABLE MARKS (
    RegNo INT,
    Subcode INT,
    Test1 DECIMAL(5, 2),
    Test2 DECIMAL(5, 2),
    Test3 DECIMAL(5, 2),
    Finalmark DECIMAL(5, 2),
    FOREIGN KEY (RegNo) REFERENCES STUDENT(RegNo),
    FOREIGN KEY (Subcode) REFERENCES SUBJECT(Subcode),
    PRIMARY KEY (RegNo, Subcode)
);

-- Insert values into the MARKS table
INSERT INTO MARKS (RegNo, Subcode, Test1, Test2, Test3, Finalmark)
VALUES
    (1, 1, 85.5, 90.0, 80.0, NULL),
    (1, 2, 75.0, 80.5, 85.0, NULL),
    (2, 1, 90.5, 85.0, 92.0, NULL),
    (2, 2, 80.0, 88.5, 90.5, NULL),
    (3, 1, 70.5, 75.0, 80.0, NULL),
    (3, 3, 85.0, 90.0, 92.5, NULL);

-- a)
SELECT s.Sem, s.Gender, COUNT(*) AS TotalStudents
FROM STUDENT s
GROUP BY s.Sem, s.Gender;
-- b)
UPDATE MARKS m
SET Finalmark = (SELECT (Test1 + Test2 + Test3 - LEAST(Test1, Test2, Test3)) / 2
                 FROM MARKS
                 WHERE RegNo = m.RegNo)
-- c)
UPDATE MARKS
SET CAT = CASE
    WHEN Finalmark >= 81 THEN 'Outstanding'
    WHEN Finalmark >= 51 AND Finalmark <= 80 THEN 'Average'
    WHEN Finalmark < 51 THEN 'Weak'
    ELSE 'Unknown'
END;
-- d)
CREATE VIEW StudentTest3Marks AS
SELECT RegNo, Subcode, Test3
FROM MARKS
WHERE RegNo = <specific_RegNo>;
-- e)
1.Create the tables STUDENT, SUBJECT, and MARKS with the respective columns and primary keys.
2.Insert sample data into the tables.
3.Run the queries mentioned in parts (a), (b), and (c) to compute the total number of students, calculate the Finalmark, and categorize the students.
4.Create the view mentioned in part (d) to retrieve the Test3 marks of a specific student in all subjects.
5.Test the procedures by executing the queries or accessing the view as required.

  ---------------------------------------------------------------------

  -- 9) que 

CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Cust_Name VARCHAR(100),
    Branch_Name VARCHAR(100),
    Account_Balance DECIMAL(10, 2),
    Account_Type VARCHAR(50)
);

INSERT INTO Account (Account_No, Cust_Name, Branch_Name, Account_Balance, Account_Type)
VALUES
    (1, 'John Doe', 'Branch1', 5000.00, 'Savings'),
    (2, 'Jane Smith', 'Branch2', 15000.00, 'Current'),
    (3, 'David Johnson', 'Branch1', 20000.00, 'Savings'),
    (4, 'Sarah Adams', 'Branch3', 8000.00, 'Savings'),
    (5, 'Michael Brown', 'Branch2', 12000.00, 'Current');

-- a)

SELECT Cust_Name, Account_No
FROM Account
WHERE Branch_Name = 'XXXXX';

-- b)

SELECT Cust_Name, Account_Type
FROM Account
WHERE Account_Balance > 10000.00;
-- c)
ALTER TABLE Account
ADD Cust_Date_of_Birth DATE;
-- d)
SELECT Account_No, Cust_Name, Branch_Name
FROM Account
WHERE Account_Balance < 1000.00;
-- e)
CREATE OR REPLACE PROCEDURE GetAccountDetails(
    IN branchName VARCHAR(100),
    OUT result CURSOR
)
AS $$
BEGIN
    OPEN result FOR
    SELECT Cust_Name, Account_No
    FROM Account
    WHERE Branch_Name = branchName;
END;
$$ LANGUAGE plpgsql;
---------------------------------------------------------------------
-- 11)  Que


CREATE TABLE SALESMAN (
    Salesman_id INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(100),
    Commission DECIMAL(10, 2)
);

CREATE TABLE CUSTOMER (
    Customer_id INT PRIMARY KEY,
    Cust_Name VARCHAR(100),
    City VARCHAR(100),
    Grade VARCHAR(10),
    Salesman_id INT,
    FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id)
);

CREATE TABLE ORDERS (
    Ord_No INT PRIMARY KEY,
    Purchase_Amt DECIMAL(10, 2),
    Ord_Date DATE,
    Customer_id INT,
    Salesman_id INT,
    FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id),
    FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id)
);
-- a)
SELECT S.Name, COUNT(C.Customer_id) AS Num_Customers
FROM SALESMAN S
JOIN CUSTOMER C ON S.Salesman_id = C.Salesman_id
GROUP BY S.Salesman_id, S.Name
HAVING COUNT(C.Customer_id) > 1;
-- b)
SELECT S.Salesman_id, S.Name, S.City, 'Has Customers' AS Status
FROM SALESMAN S
INNER JOIN CUSTOMER C ON S.Salesman_id = C.Salesman_id
UNION
SELECT S.Salesman_id, S.Name, S.City, 'No Customers' AS Status
FROM SALESMAN S
LEFT JOIN CUSTOMER C ON S.Salesman_id = C.Salesman_id
WHERE C.Customer_id IS NULL;
-- c)
CREATE VIEW MaxOrderSalesman AS
SELECT O.Salesman_id, MAX(O.Purchase_Amt) AS Max_Order
FROM ORDERS O
GROUP BY O.Salesman_id;
-- d)
DELETE FROM ORDERS WHERE Salesman_id = 1000;
DELETE FROM SALESMAN WHERE Salesman_id = 1000;
-- e)
CREATE TRIGGER UpdateCommission
AFTER UPDATE OF Grade ON CUSTOMER
FOR EACH ROW
WHEN (OLD.Salesman_id = NEW.Salesman_id)
BEGIN
    UPDATE SALESMAN
    SET Commission = Commission * 1.1
    WHERE Salesman_id = NEW.Salesman_id;
END;
---------------------------------------------------------------------
--2//
create table employee (SNo int(10),Name char(10),Designation varchar(10),branch char(10));
insert into employee values(1,'Sanjeevi','Student','CSBS');
insert into employee values(2,'Gobal','Student','CSBS');
select * from employee;

--2/a
ALTER TABLE employee ADD Salary varchar(20);
insert into employee values(3,'Sathya','Student','CSBS',);
select * from employee;

--2/b
CREATE TABLE Emp AS SELECT * FROM employee;

--2/c
DELETE FROM employee WHERE SNo=1;
select * from employee;

--2/d
DROP Table employee;
--2/e [ERROR]
---------------------------------------------------------------------

--4//
CREATE TABLE DEPARTMENTS (
  dept_no INT PRIMARY KEY,
  dept_name VARCHAR(100),
  dept_location VARCHAR(100)
);

CREATE TABLE EMPLOYEES (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100),
  emp_salary DECIMAL(10, 2),
  dept_no INT,
  FOREIGN KEY (dept_no) REFERENCES DEPARTMENTS(dept_no)
);

-- Inserting records into the DEPARTMENTS table
INSERT INTO DEPARTMENTS (dept_no, dept_name, dept_location)
VALUES (1, 'Sales', 'New York');

INSERT INTO DEPARTMENTS (dept_no, dept_name, dept_location)
VALUES (2, 'HR', 'London');

-- Inserting records into the EMPLOYEES table
INSERT INTO EMPLOYEES (emp_id, emp_name, emp_salary, dept_no)
VALUES (1, 'John Doe', 5000.00, 1);

INSERT INTO EMPLOYEES (emp_id, emp_name, emp_salary, dept_no)
VALUES (2, 'Jane Smith', 6000.00, 2);

--4/a
GRANT SELECT, INSERT, UPDATE ON EMPLOYEES TO DEPARTMENTS;
--OUTPUT : Assuming the privileges (SELECT, INSERT, UPDATE) are granted successfully.

--4/b
REVOKE ALL PRIVILEGES ON EMPLOYEES FROM DEPARTMENTS;
--OUTPUT : Assuming all privileges on the "EMPLOYEES" table have been revoked from the "DEPARTMENTS" table successfully.

--4/c
REVOKE SELECT, INSERT ON EMPLOYEES FROM DEPARTMENTS;
--OUTPUT : Assuming the specified privileges (SELECT, INSERT) have been revoked from the "DEPARTMENTS" table successfully.

--4/d
SAVEPOINT my_savepoint;
--OUTPUT : A savepoint is an internal mechanism in a transaction, and it does not produce a visible output as such. It provides a way to mark a specific point in the transaction to which you can later roll back if needed. No specific output is expected for this query.

--4/e
CREATE PROCEDURE GetEmployeeDetails(IN emp_id INT)
BEGIN
  SELECT * FROM EMPLOYEES WHERE emp_id = emp_id;
END;
--OUTPUT : emp_id | emp_name   | emp_salary | dept_no
--        ========|============|============|=========
--             1  |   John Doe |   5000.00  |    1

---------------------------------------------------------------------

--6//
-- Create ACTOR table
CREATE TABLE ACTOR (
  Act_id INT PRIMARY KEY,
  Act_Name VARCHAR(100),
  Act_Gender VARCHAR(10)
);

-- Create DIRECTOR table
CREATE TABLE DIRECTOR (
  Dir_id INT PRIMARY KEY,
  Dir_Name VARCHAR(100),
  Dir_Phone VARCHAR(20)
);
-- Create MOVIES table
CREATE TABLE MOVIES (
  Mov_id INT PRIMARY KEY,
  Mov_Title VARCHAR(100),
  Mov_Year INT,
  Mov_Lang VARCHAR(50),
  Dir_id INT,
  FOREIGN KEY (Dir_id) REFERENCES DIRECTOR(Dir_id)
);

-- Create MOVIE_CAST table
CREATE TABLE MOVIE_CAST (
  Act_id INT,
  Mov_id INT,
  Role VARCHAR(50),
  FOREIGN KEY (Act_id) REFERENCES ACTOR(Act_id),
  FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id)
);

-- Inserting records into the ACTOR table
INSERT INTO ACTOR (Act_id, Act_Name, Act_Gender) VALUES
(1, 'Actor1', 'Male'),
(2, 'Actor2', 'Female'),
(3, 'Actor3', 'Male'),
(4, 'Actor4', 'Female');

-- Inserting records into the DIRECTOR table
INSERT INTO DIRECTOR (Dir_id, Dir_Name, Dir_Phone) VALUES
(1, 'Director1', '1234567890'),
(2, 'Director2', '9876543210');

-- Inserting records into the MOVIES table
INSERT INTO MOVIES (Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id) VALUES
(1, 'Movie1', 2010, 'English', 1),
(2, 'Movie2', 2011, 'Spanish', 1),
(3, 'Movie3', 2009, 'French', 2),
(4, 'Movie4', 2012, 'English', 2);

-- Inserting records into the MOVIE_CAST table
INSERT INTO MOVIE_CAST (Act_id, Mov_id, Role) VALUES
(1, 1, 'Lead'),
(2, 1, 'Supporting'),
(2, 2, 'Lead'),
(3, 2, 'Supporting'),
(1, 3, 'Lead'),
(3, 3, 'Supporting'),
(4, 4, 'Lead');

--6/a
SELECT Mov_Title
FROM DIRECTOR
JOIN MOVIES ON DIRECTOR.Dir_id = MOVIES.Dir_id
WHERE Dir_Name = 'XXXX';

--6/b
SELECT Mov_Title
FROM MOVIES
JOIN MOVIE_CAST ON MOVIES.Mov_id = MOVIE_CAST.Mov_id
GROUP BY Mov_Title
HAVING COUNT(DISTINCT MOVIE_CAST.Act_id) >= 2;

--6/c
SELECT DISTINCT A.Act_Name
FROM ACTOR A
JOIN MOVIE_CAST MC ON A.Act_id = MC.Act_id
JOIN MOVIES M ON MC.Mov_id = M.Mov_id
WHERE M.Mov_Year < 2010 AND M.Mov_Year > 2015;

--6/d
CREATE VIEW MoviesWithActorAndDirector AS
SELECT M.Mov_Title, A.Act_Name, D.Dir_Name
FROM MOVIES M
JOIN MOVIE_CAST MC ON M.Mov_id = MC.Mov_id
JOIN ACTOR A ON MC.Act_id = A.Act_id
JOIN DIRECTOR D ON M.Dir_id = D.Dir_id
WHERE A.Act_id = X;
SELECT * FROM MoviesWithActorAndDirector;

--6/e [Syntax Error]
-- Create the function
CREATE FUNCTION GetActorCount(@ActorID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    
    SELECT @Count = COUNT(*)
    FROM MOVIE_CAST
    WHERE Act_id = @ActorID;
    
    RETURN @Count;
END;
---------------------------------------------------------------------

--8//
CREATE TABLE Bank (
  S_No INT PRIMARY KEY,
  Cust_Name VARCHAR(100),
  Acc_No VARCHAR(20),
  Balance DECIMAL(10, 2),
  Branch VARCHAR(100)
);
-- Inserting records into the Bank table
INSERT INTO Bank (S.No, Cust_Name, Acc_No, Balance, Branch) VALUES
(1, 'John Doe', 'ACC001', 5000, 'XYZ'),
(2, 'Jane Smith', 'ACC002', 8000, 'XYZ'),
(3, 'David Johnson', 'ACC003', 3000, 'ABC'),
(4, 'Sarah Williams', 'ACC004', 7000, 'ABC');
--8/a
SELECT *
FROM Bank
WHERE Branch = 'XYZ';

--8/b
SELECT *
FROM Bank
WHERE Balance > 5000;

--8/c
UPDATE Bank
SET Balance = 2000
WHERE S.No = 2;

--8/d
SELECT *
FROM Bank
WHERE Balance BETWEEN 1000 AND 5000;

--8/e [SYNTAX ERROR]
CREATE TRIGGER BalanceCheck
ON Bank
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT *
               FROM inserted
               WHERE Balance < 1000)
    BEGIN
        -- Perform the necessary actions when the balance is below 1000
        -- For example, raise an error or send a notification.
        RAISERROR ('Balance is below 1000', 16, 1);
    END
END;
-----------------------------------------------------
--10//
CREATE TABLE CUSTOMER (
  C_ID INT PRIMARY KEY,
  Name VARCHAR(100),
  Address VARCHAR(100),
  City VARCHAR(50),
  Mobile_No VARCHAR(20)
);

CREATE TABLE ORDER (
  C_ID INT,
  P_ID INT,
  P_Name VARCHAR(100),
  P_COST DECIMAL(10, 2),
  FOREIGN KEY (C_ID) REFERENCES CUSTOMER(C_ID)
);

INSERT INTO CUSTOMER (C_ID, Name, Address, City, Mobile_No) VALUES
(1, 'John Doe', '123 Main St', 'New York', '123-456-7890'),
(2, 'Jane Smith', '456 Elm St', 'Los Angeles', '987-654-3210'),
(3, 'David Johnson', '789 Oak St', 'Delhi', '555-555-5555');

INSERT INTO ORDER (C_ID, P_ID, P_Name, P_COST) VALUES
(1, 1001, 'Product A', 10.99),
(1, 1002, 'Product B', 15.99),
(2, 1003, 'Product C', 12.49),
(3, 1004, 'Product D', 8.99);

--10/a
SELECT c.Name, c.Address
FROM CUSTOMER c
JOIN ORD o ON c.C_ID = o.C_ID
WHERE o.P_COST > 10;

--10/b
SELECT P_Name
FROM ORD
WHERE P_COST >= 12;

--10/c
SELECT DISTINCT o.P_Name
FROM CUSTOMER c
JOIN ORDER o ON c.C_ID = o.C_ID
WHERE c.City = 'Delhi';

--10/d
ALTER TABLE CUSTOMER
ADD Email_id VARCHAR(100);

--10/e [SYNTAX ERROR]
CREATE FUNCTION GetCustomerCount()
RETURNS INT
BEGIN
  DECLARE customerCount INT;
  SELECT COUNT(*) INTO customerCount FROM CUSTOMER;
  RETURN customerCount;
END;
---------------------------------------------------------------------