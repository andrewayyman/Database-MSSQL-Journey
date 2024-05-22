
----------------------------------------- Assignment 04 -------------------------------------------------------

----------------------------------------- PArt01 Create with wizard -------------------------------------------
--Done
use My_ITI

----------------------------------------- Part02 Dml on previous-------------------------------------------
-- 1 / Insertion 
-- insertion tree => topics, departments, instructors, courses, students, stud_Course, course_instructor

INSERT INTO Topics ([Name])
VALUES ('C#'), ('Data Structures');

INSERT INTO Departments (Id, [Name], HiringDate)
VALUES (1, 'Flutter', '2024-08-09'),
       (2, 'Frontend', '2024-05-07'),
	   (30, 'Backend', '2024-10-12');

INSERT INTO Instructors ([Name], [Address], Bouns, Salary, HourRate, Dep_Id)
VALUES ('Hamada', 'Mansoura', 500, 9000, '05:00:00', 1),
       ('Osama', 'Shobra', 600, 12000, '03:00:00', 2);

INSERT INTO Courses ([Name], [Address], Duration, [Description], TopID)
VALUES ('Databases', 'Nahas', '02:30:00', ' SQL', 1),
       ('Data Structures and Algorithms', 'rabbaa', '05:00:00', ' data structures', 2);

INSERT INTO Students (Fname, Lname, Age, [Address], Dep_id)
VALUES ('Mohsen', 'mahmoud', 20, 'Helwan', 1),
       ('yara', 'ayman', 22, 'Shobra', 2);

INSERT INTO Stud_Course (Grade, Stud_Id, Course_Id)
VALUES (85, 1, 1), (90, 1, 2),
       (80, 2, 1), (95, 2, 2);

INSERT INTO Course_Instructor (Evaluation, Course_Id, Ins_Id)
VALUES ('Ma4y &aloo ', 1, 1), (' #la Adoo', 2, 2);

-- 2 / DMl
-- 2.1 Insert personal with dept 30
INSERT INTO Students (Fname, Lname, Age, [Address], Dep_id)
VALUES ('Andrew', 'Ayman', 22, 'Nozha',30 );

-- 2.2 Insert Ins default bonus 
INSERT INTO Instructors ([Name], [Address], Salary, HourRate, Dep_Id)
VALUES ('Omar', 'afifi', 15000, '05:00:00', 30);

-- 2.3 Upgrade salary by 20%
UPDATE Instructors
SET Salary = Salary * 1.20;




----------------------------------------- Part03 Restore MyCompany DB  -------------------------------------------




use MyCompany
-- Queries

-- 3.1
Select * from employee

--3.2
select Fname, Lname,Salary,Dno
from Employee

--3.3
select Pname, Plocation, Dnum
from Project

--3.4
SELECT Fullname = Fname + ' ' + Lname, Salary * 0.10 AS 'ANNUAL COMM'
from Employee

--3.5
select SSN, Fullname = Fname + ' ' + Lname,Salary
from Employee
where Salary >1000

--3.6
select Fullname = Fname + ' '+Lname,SSN , + Lname,Salary*12 as 'Anuual Salary'
from Employee
where Salary*12 >10000

--3.7
select Fullname = Fname + ' '+Lname, Salary
from employee
where sex = 'F'

--3.8
select Dnum, Dname,MGRSSN
from Departments
where MGRSSN = 968574   -- dnum = 20

--3.9
select Pnumber, Pname, Plocation ,Dnum
from Project
where Dnum = 10

--3.10
SELECT *
FROM Project
WHERE Pname LIKE 'a%';

----------------------------------------- Part04 Restore ITI DB  -------------------------------------------
--4.1 / all instructors Names without repetition
use ITI

select DISTINCT Ins_Name
FROM Instructor

-- 4.2 Bonus

/*

'@@' in sql server defined as global variables to provide access on system-level informationin sql server
it's like system variables and it's read only users doesn't have access to modify it .

*/

select @@VERSION AS 'My SSMS Version'

select @@SERVERNAME AS 'My Server Name'















