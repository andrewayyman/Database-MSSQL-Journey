--====================================================== Practice  08 ===================================================================
/*
    - Part01 : Functions
    - Part02 : Views 
    - Part03 : Views

*/


----------------------------------------------------------------
--===================== Part 01 ================================
----------------------------------------------------------------
Use ITI 
--1.Create a scalar function that takes a date and returns the Month name of that date.
Create Function GetMonthFromDate(@date date)
Returns varchar(20)
Begin
    Return Datename(month , @date )
End

select dbo.GetMonthFromDate('2002-3-18') -- March


--2.Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
Create or Alter function NumbersBetweenTwoNumbers(@first_num int ,@second_num int)
returns varchar(max)
begin

	if ( @second_num < @first_num )
	begin
		declare @tmp int = @second_num
		set @second_num = @first_num
		set @first_num = @tmp
	end

	declare @result varchar(max) = cast(@first_num+1 as varchar(max)) 
	set @first_num = @first_num + 1

	while ( @first_num < @second_num-1 )
	begin
        SET @result =concat(@result , ', ' , @first_num +1)
		set @first_num = @first_num + 1
	end
	
	return @result
end
 
 --run
select dbo.numbersBetweenTwoNumbers(5,1)

--3.Create a table-valued function that takes Student No and returns Department Name with Student full name.
Create or Alter function DeptNameFromStdName(@id int)
returns table
as
return (
	
		select D.Dept_Name , S.St_Fname+ ' '+ s.St_Lname AS [Null Name]
		from Department D, Student S
		where D.Dept_Id = S.Dept_Id AND S.St_Id = @id

)

--RUN
SELECT * FROM   DBO.DeptNameFromStdName(1)

--4.Create a scalar function that takes Student ID and returns a message to user 

Create or Alter function MessageBasedOnName(@id int)
RETURNS varchar(50)
begin 
	
	declare @FName varchar(10)
	declare @LName varchar(10)
	declare @RESLUT varchar(50)

	select @FName = St_Fname , @LName = St_Lname 
	FROM Student
	WHERE St_Id = @id

	IF @FName IS NULL AND @LName IS NULL
		SET @RESLUT = 'First name & last name are null'
	ELSE IF @FName IS NULL
		SET @RESLUT = 'first name is null'
	ELSE IF  @LName IS NULL
		SET @RESLUT = 'last name is null'
	ELSE
		SET @RESLUT = 'First name & last name are not null'

	return @RESLUT
end

--RUN
SELECT DBO.MessageBasedOnName(1111)

--5.Create a function that takes an integer which represents the format of the Manager hiring date and displays department name, Manager Name and hiring date with this format.   

Create or Alter function deptName_MngrData(@num int)
RETURNS  table
as
RETURN (

	select D.Dept_Name , I.Ins_Name , convert(varchar(50),D.Manager_hiredate, @num) as [date]
	from Instructor I, Department D
	where I.Ins_Id = d.Dept_Manager and D.Manager_hiredate is not null 

)
---RUN
select * from dbo.deptName_MngrData(101)


--6.Create multi-statement table-valued function that takes a string
Create OR ALTER function StdNameBasedOnFormat(@Format varchar(20))
returns @Table table
(
	Name varchar(10)
)
as
begin
	if(@Format = 'first name')
		insert into @Table
		select ISNULL(St_Fname,'') 
		from Student
	else if(@Format = 'last name')
		insert into @Table
		select ISNULL(St_Lname, '')
		from Student
	else
		insert into @Table
		select ISNULL(St_Fname,'') + ' ' + ISNULL(St_Lname, '')
		from Student

	RETURN
end

----RUN
select * from dbo.StdNameBasedOnFormat('last name')




--7.Create function that takes project number and display all employees in this project (Use MyCompany DB)

USE MyCompany

CREATE FUNCTION EmployeesInProjects(@NUM_DEPT INT)
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM Employee
	WHERE DNO = @NUM_DEPT
)

---RUN
select * from dbo.EmployeesInProjects(30)






----------------------------------------------------------------
--===================== Part 02 ================================
----------------------------------------------------------------
--Note : # means number and for example d2 means department which has id or number 2
Use ITI 
--1.Create a view that displays the student's full name, course name if the student has a grade more than 50. 

CREATE VIEW StudentsCoursesHighGrade
with encryption as
	select S.St_Fname AS [STUDENT NAME] , C.Crs_Name AS COURSE
	from Student S , Course C , Stud_Course STC
	WHERE S.St_Id = STC.St_Id AND C.Crs_Id = STC.Crs_Id AND STC.Grade > 50

--RUN
SELECT * FROM DBO.StudentsCoursesHighGrade

--2.Create an Encrypted view that displays manager names and the topics they teach. 

CREATE OR ALTER VIEW ManagersWithTopics
With Encryption
As
	select DISTINCT I.Ins_Name , T.Top_Name
	from Instructor I , Ins_Course IC , Course C , Topic T
	WHERE I.Ins_Id = IC.Ins_Id AND C.Crs_Id = IC.Crs_Id AND T.Top_Id = C.Top_Id
	AND I.Ins_Id IN (SELECT Dept_Manager FROM Department)

--RUN
SELECT * FROM DBO.ManagersWithTopics

--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding

CREATE OR ALTER VIEW InsOfSdJavaDept
with encryption as
	select DISTINCT I.Ins_Name , D.Dept_Name
	from Instructor I , Department D
	WHERE D.Dept_Id = I.Dept_Id AND D.Dept_Name  IN('SD' , 'Java')

CREATE SCHEMA binding

alter schema binding transfer dbo.InsOfSdJavaDept

---RUN
select * from binding.InsOfSdJavaDept

--4.Create a view that will display the project name and the number of employees working on it. (Use Company DB)
USE MyCompany

Create or alter view EmployeesInProjects
as
	select p.Pname ,COUNT(e.SSN) as [count of employees]
	from Employee E, Project P , Works_for W
	where e.SSN = w.ESSn and p.Pnumber = w.Pno
	group by p.Pname 


----RUN
select * from EmployeesInProjects


--1.Create a view named   “v_clerk” that will display employee Number ,project Number, the date of hiring of all t-he jobs of the type 'Clerk'.
use [SD32-Company] 


CREATE OR ALTER VIEW v_clerk
AS 
	select E.EmpNo , W.ProjectNo , w.Enter_Date
	from HR.Employee E , DBO.Works_on W
	WHERE e.EmpNo = w.EmpNo and w.Job = 'Clerk'
--RUN
select * from v_clerk


--2.Create view named  “v_without_budget” that will display all the projects data without budget

create or alter view v_without_budget
as
	select ProjectNo , ProjectName from hr.Project

--- RUN
select * from v_without_budget


--3.Create view named  “v_count “ that will display the project name and the Number of jobs in it
create or alter view v_count 
as
	SELECT P.ProjectName ,  COUNT(W.Job) as [num of jops]
	FROM Works_on W, hr.Project P
	WHERE P.ProjectNo = W.ProjectNo
	GROUP BY  P.ProjectName
--- RUN
select * from v_count


--4.Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)

create or alter view  v_project_p2 
AS
	SELECT E.EmpFname
	FROM  HR.Employee E , v_clerk C
	WHERE E.EmpNo = C.EmpNo AND C.ProjectNo =  2
--- RUN
select * from v_project_p2


--5.modify the view named  “v_without_budget”  to display all DATA in project p1 and p2.

alter view v_without_budget
as
	select ProjectNo , ProjectName , Budget from hr.Project

--- RUN
select * from v_without_budget


--6.Delete the views  “v_ clerk” and “v_count”

DROP VIEW v_clerk 
DROP VIEW v_count


--7.Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’

create or alter view employeeData 
AS
	SELECT EmpNo , EmpLname 
	FROM HR.Employee
	WHERE DeptNo = 2
--- RUN
select * from employeeData


--8.Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)

SELECT EmpLname 
FROM employeeData
WHERE EmpLname LIKE '%J'


--9.Create view named “v_dept” that will display the department# and department name

create or alter view v_dept 
AS
	SELECT DeptNo , DeptName
	FROM Department
--- RUN
select * from v_dept







----------------------------------------------------------------
--===================== Part 03 ================================
----------------------------------------------------------------
Use ITI 
--1.Create a view “V1” that displays student data for students who live in Alex or Cairo. 
Create OR Alter View V1
As
    Select *
    From Student
    Where St_Address In('Cairo','Alex') 
    With Check Option 

-- Run
Select * From V1

--Note: Prevent the users to run the following query 
Update V1 set st_address='tanta'
Where st_address='alex'




use [SD32-Company]
--1.Create view named “v_dept” that will display the department# and department name
Create or ALter View v_dept
As
    Select DeptNo , DeptName
    From Company.Department

-- Run
select * from v_dept

--2.using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
insert into v_dept
Values (4,'Development')


--3.Create view name “v_2006_check” that will display employee Number, the project Number where he works and the date of joining the project which must be from the first of January and the last of December 2006.this view will be used to insert data so make sure that the coming new data must match the condition
CREATE OR ALTER VIEW v_2006_check
AS
SELECT W.empno, W.projectno, W.enter_date
FROM 
    [dbo].[Works_on] W
WHERE 
    W.enter_date BETWEEN '2006-01-01' AND '2006-12-31';


-- Run
select * from v_dept














































