--====================================================== Demo 09 =============================================================
/*
    Demo Content : 
    - Stored Procedure 
        ..select
        ..delete
        ..Passing Parameter
        ..Dynamic Query 
        .. Insert based on execute
        .. Input output parameter
    
    - Trigger
        ..After insert update
        .. instead of 
        .. enable , disbale 
        .. Importnat Note (Deleted , Inserted)

*/

--------------------------------------------------------------------
--======================  Stored Procedure  =======================
--------------------------------------------------------------------

    --- Benefits Of SP:
-- 1. Performance
-- 2. Security (Hide Meta Data)
-- 3. Reduce Network Traffic on server
-- 4. Hide Business Rules
-- 5. Handle Errors (SP Contain DML)
-- 6. Accept Input And Out Parameteres => Make It More Flexbile 

/* 
    -- Query LifeCycle :  
            When a SQL query is executed, it goes through several stages before execution.
            Understanding this lifecycle helps in appreciating how stored procedures enhance performance.

    * Parser Syntax => Optimize Metadata => Query Tree (Exec Order ) => Execution Plan 
    
    - Parser Syntax : Validate the syntax if there's error ot not 
    - Optimize Metadata : Validate the metadata (Table name ,..)
    - Query Tree : Tree for the priority of execution to the query statments
    - Execution Plan : Execution phase for the query 

    A stored procedure goes through the full query lifecycle only once when it is first executed.
    On subsequent executions, the precompiled execution plan is reused, skipping the parsing, metadata validation,
    and optimization stages.

*/

------------- SP Select Ex -------------
-- Create Proc
Create Proc SP_GetStudentData
as
	Select *
	from Student
-- Exec
SP_GetStudentData


-- Create Proc needs a Parameter
Create Procedure SP_GetStudentById @StdId int
as
	Select *
	from Student
	Where St_Id =  @StdId
-- Exec with parameter
SP_GetStudentById 1

Declare @x int = 1 
Exec SP_GetStudentById @x -- lazm ast5dm exec tol ma b pass variable

Alter Schema iti
Transfer SP_GetStudentById

iti.SP_GetStudentById 1


------------- SP Delete Ex -------------

Delete 
From Topic
Where Top_Id = 1

-- Try Catch
Create or Alter Proc SP_DeleteTopicById @TopicId int
With Encryption
as  
    Begin Try
        Delete 
        From Topic
        Where Top_Id = @TopicId
    End Try
    Begin Catch
        print 'Error!'
    End Catch
         
exec SP_DeleteTopicById 1

exec sp_helptext 'SP_DeleteTopicById'



------------- SP Passing Parameter Ex -------------


Create or Alter Proc SP_SumData @x int = 2 , @y int = 5
As
    Print @x + @y

Exec SP_SumData 3,7			-- Passing Parameters by Position
Exec SP_SumData @y=7,@x=3    -- Passing Parameters by name
Exec SP_SumData 6			-- Default Values
Exec SP_SumData				-- Default Values




------------- SP Dynamic Query Ex -------------

Create or Alter Proc SP_GetData @tablename varchar(50) , @colname varchar(50)
With Encryption 
As 
    -- Select @colname From @tablename  -- invalid
    Execute ('Select ' + @colname + ' From ' + @tablename )
   

Exec SP_GetData 'Student' , '*'
Exec SP_GetData 'Student' , 'St_Fname'




------------- SP Insert based on execute Ex -------------

Create or Alter Proc SP_GetStudentDataByAddress @StAdress varchar(max)
With Encryption
As
    Select St_Id, St_FName, St_Address
    From Student
    Where St_Address = @StAdress

Exec SP_GetStudentDataByAddress 'Alex'


Create Table StudentsWithAddresss
(
StdId int Primary Key,
StdName varchar(20),
StdAddress varchar(20)
)

-- Insert Based On Execute
Insert Into StudentsWithAddresss
exec SP_GetStudentDataByAddress 'Alex'



------------- SP Input output parameter Ex ( Return of Sp ) -------------

Create or Alter Proc SP_GetStudentNameAndAgeById @StdId int , @StName varchar(30) out , @StAge int out 
With encryption
As
    Select @StName = St_Fname , @StAge  = St_Age
    From Student
    Where St_Id = @StdId


Declare @name varchar(30) , @age int
Exec SP_GetStudentNameAndAgeById 1 , @name out , @age out

select @name, @age

--- Better Version 

-- deal wiht 1 variable as input and output in same time
Create or Alter Proc SP_GetStudentNameAndAgeByIdV2 @StName varchar(30) out , @StData int out 
With encryption
As
    Select @StName = St_Fname , @StData  = St_Age
    From Student
    Where St_Id = @StData


Declare @name varchar(30) , @age int = 7
Exec SP_GetStudentNameAndAgeByIdV2 @name out , @age out

select @name, @age




--------------------------------------------------------------------
--==========================  Triggers  ============================
--------------------------------------------------------------------
----Types Of Stored Procedures

--1.User Defined Procedure
    SP_GetStudentNameById  SP_GetStudentData   SP_Sum

--2.Built In Procedure 
    SP_HelpText 'SP_GetData'   
    SP_Rename

--3. Triggers (Special Stored Procedure)
   -- Can't Call
   -- Can't Take Parameter 
   -- Concept : Events

---Types Of Triggers 
  --- Server Level
  --- DB Level
  --- Table Level (our Interset)
  --- Actions (Insert/Update/Delete) [Event]
  --- [Select] => Not Logged at Log File 

  --- After => Insert 
  --- After => Update
  --- After => Delete  ** After => Delete
  --- Instead of => Insert - Update - Delete
  --- Before => xxx
  -------------------------------------------------------------------------------------


----------------- After insert update ------------------


-- Ex 
Create or Alter Trigger Tri_WelcomeTrigger
On Student
After Insert  -- or instead of insert
As 
    Print 'Welocme'


insert into Student (St_Id , St_Fname)
Values (100010 , 'Ahmed')

-- Trigger Follow the Table he belongs to in his schema 
-- so you can't transfer trigger to another schema it follow the table 


-- Ex 
Create or Alter Trigger Tri_UpdateStudent
On Student
After Update 
As 
    Select GETDATE() As Datetime


update student
Set St_Fname = 'Hussien'
Where St_Id = 100010



----------------- instead of  ------------------
--Ex 
Create Or Alter Trigger Tri_PreventDeleteStudent
On Student
Instead of Delete  -- after while use trigger after execute the delete so use instead of
As 
    Print 'Cannot Delete'

Delete From Student
Where St_Id = 100010


--Ex
Create or Alter Trigger Tri_LockDepartment
On Department
Instead of Delete , update , Insert
AS 
    Print 'Cannot do any operation on this table ' + SUSER_NAME()
 

update Department
set Dept_Location = 'cairo'


----------------- Enable / Disable ------------------

-- drop 
Drop Trigger Tri_lockDepartment

-- Disable
alter table department
Disable trigger Tri_lockDepartment

--Enable
alter table department
Enable trigger Tri_lockDepartment


-- Disable -> deactivate the trigger without delete





----------------- Most Importnat point For Trigger ------------------
-- 2 Tables : Inserted / Deleted Will be Created With Each Fire Of Trigger
-- In Case Of Delete:  Deleted Table Will Contain Deleted Values 
-- In Case Of Insert:  Inserted Table  Will Contain Inserted Values 
-- In Case of Update : Deleted Table Will Contain Deleted Values 
--                   : Inserted Table  Will Contain Inserted Values 



Select * from Inserted -- inavlid


Create or Alter Trigger Tri05
On Course 
After Update 
as
    Select * from inserted -- new values
    Select * from deleted  -- old values


update Course
Set Crs_Name = 'React'
Where Crs_Id = 700
------------------------------

Create or Alter Trigger Tri07
on Course
Instead of Delete
AS
    select 'U cannot delete Course ' + (select Crs_Name from deleted) + ' From this table'


Delete from Course
Where Crs_Id = 100 

-------------------------------
Create table UpdatedTopics 
(
    Top_Id int primary key,
    Top_Name varchar(30)
)


create or Alter trigger Tri01
On topic
After Update
As 
    Insert into UpdatedTopics
    Select Top_Id , Top_Name 
    From deleted


update topic 
set Top_Name = 'Mobile'
Where Top_Id = 3

-- now the old data in topic table inserted into updatedtopics as a new data automatically
----------------------------------------

Create or Alter Trigger Tri_PreventDeleteStudent
On Student
Instead of Delete
as
   if(Format(GETDATE(),'ddd') = 'Thu')
   Delete From Student
   where St_Id = (Select St_Id from deleted)


   Delete 
   From Student
   where St_Id = 16







