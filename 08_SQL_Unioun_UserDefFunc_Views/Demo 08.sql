--============================================ Demo 08 =======================================================
/* DEMO Content 
    1 - Union Family
    2 - Select into , based select 
    3 - User Defined Functions
        3.1. Scalar 
        3.2. Inline table
        3.3. Multistatment table
    4 - Views 
        4.1. Standard View
        4.2. Partitioned View
        4.3. View , Schema
        4.4. Views Encryption
        4.5. View + DML
        4.6. View With Check
*/
--===============================================================================================================

----------------------------------------------------------------
--================ 1 - Union Family ============================
----------------------------------------------------------------
/*
                    [ Union - Union All - Intersect - Except ]
    NOTE : - Must be same datatybe and same number of selected columns 

    1.1 Union  
    - The UNION operator is used to combine the results of two or more SELECT statements.
    - It removes duplicate records from the result set.
    - Each SELECT statement within the UNION must have the same number of columns in the result sets with similar data types.
    ** Combine the output of 2 select statments but remove duplicates **
    
    1.2 Union All
    - Same as Union But With duplicates 
    - It's faster

    1.3 Intersect 
    - Return the common records from two or more SELECT statements.
    - Only rows that are present in all SELECT statements will be included in the result set.

    1.4 Except
    - Return the records from the first SELECT statement that are not present in the second SELECT statement.
    - It removes duplicates from the result set by default.

*/
use iti

-- union 
select st_fname from student 
Union
select Ins_Name from Instructor

-- union 
select St_Id,st_fname from student 
Union
select Ins_Id,Ins_Name from Instructor


-- union all 
select st_fname from student 
Union all
select Ins_Name from Instructor

-- intersect -common-
select st_fname from student 
Intersect
select Ins_Name from Instructor

-- except 
select st_fname from student 
Except
select Ins_Name from Instructor


-----------------------------------------------------------------------
--=========== 2 - Select Into , Select Based on Insert ================
-----------------------------------------------------------------------
/*
 * Select Into => 
    - Copy table (structure with data)
    - The SELECT INTO statement is used to create a new table and insert data into it based on the result of a SELECT query.
    - It is useful for making copies of tables or backing up data.                 
 
 * Select Based on Insert =>
    - The INSERT INTO ... SELECT statement is used to insert data into an existing table based on the result of a SELECT query.
    - It does not create a new table but adds rows to an existing one. 
*/


--------  Select Into --------
-- now i want to copy employee table in company to iti database
-- then i will use iti "the destination"
use iti

Select * Into NewEmployee
from MyCompany.dbo.Employee -- But No relations and constriants will be copied

-- copy structure only
select * into NewProject 
from MyCompany.dbo.Project
Where 1=2  -- put any condition that cannot be happen

-------- Insert based on Select --------
    
insert into NewProject
select * from MyCompany.dbo.Project

-----------------------------------------------------------------------
--================== 3 - User Defined Functions ======================
-----------------------------------------------------------------------
/*
    ***************
    - Must Have Return Value 
    - Signature (Name , Parameters , Return type)
    - Body [ Select Statment | Insert Based on Select 'for multistatments' ]
    ***************

*3.1. Scalar Fun => 
    - Return just a single value (e.g., int, date, varchar).

*3.2. Inline Table =>
    - Return Table
    - Contain a single SELECT statement.
    - More Efficient than multi

*3.3. Multistatment Table =>
    - Return Table
    -  Can contain multiple statements.
    - They are more flexible but can be less efficient.

*/
 
-----------------------------------
------- 3.1 Scalar Function -------
----------------------------------- 
--Only One Select & Return a Value

-- Createing Function
Create Function GetStudentNameById ( @StdId int )
Returns Varchar(max)    -- Signature
Begin

Declare @StudentName varchar(max)
Select @StudentName = St_Fname
From Student
Where St_Id = @StdId

Return @StudentName
End     -- Function Body


-- Calling Function
Select Dbo.GetStudentNameById(10)


-- Creating Function
use MyCompany
Create or Alter Function GetDeptManagerByDeptName ( @DeptName varchar(max) )
Returns varchar(max)
Begin

Declare @deptmanager varchar(max )
Select @deptmanager= E.Fname
From Departments D , Employee E
Where E.SSN = D.MGRSSN
And Dname = @DeptName

Return @deptmanager
End

-- Calling
Select dbo.GetDeptManagerByDeptName('Dp2')






-----------------------------------------
------- 3.2 Inline Table Functoin -------
-----------------------------------------  
-- Only One Select & Return Table
use iti

-- Creating
Create or Alter Function GetDeptInsByDeptId( @DeptId int )
Returns Table   -- Signature
As
Return (

Select Ins_Id , Ins_Name , Dept_Id
From Instructor
Where Dept_Id = @DeptId

)

-- Calling  "Deal with it as a table" 
Select * 
from dbo.GetDeptInsByDeptId(30)



------------------------------------------------
------- 3.2 Multistatment Table Functoin -------
------------------------------------------------ 
-- Many Select statments With logic[If,while,...etc] & Return Table


-- Creating
Create or Alter Function GetDataBasedOnFormat( @format varchar(max) )
Returns @t Table ( StdId int , StdName varchar(max) )
As 
Begin

    if @format = 'first'
        Insert Into @t
        Select St_Id , St_Fname
        From Student 

    Else If @format = 'last'
        Insert Into @t
        Select St_Id , St_Lname
        From Student

    Else If @format = 'full'
        Insert Into @t
        Select St_Id , CONCAT(St_Fname , ' ' ,  St_Lname )
        From Student

Return
End



-- Calling
Select * 
from dbo.GetDataBasedOnFormat('FULL')



-----------------------------------------------------------------------
--======================== 4 - VIEWS   ================================
-----------------------------------------------------------------------
/*
    - A view is a saved SQL query that you can treat as a table. It does not store data itself but provides a way to look at data stored in other tables.
    - View is layer to protect tha database 
    - IS not Table it's Virtual Table
    - Helps in Permission Limit access of data
    - Hide Database Objects
    - Secure From SQL Injection 
    - Simplify Complex Query by store it and be usable many times 
    - No parameter 'only select statments'
    - No DML Queries only Select
    
 * 4.1. Standard View
 * 4.2. Partitioned View
 * 4.3. Indexed View
*/


-----------------------------------------
----------- 4.1 Standard View -----------
-----------------------------------------  


select * 
from Student

-- Creating View
Create or Alter View StudentsView(id, firstname , lastname , address , age)
As
    Select St_Id , St_Lname ,St_Lname , St_Address , St_Age
    From Student

-- Calling View
select *
from StudentsView

 -- View to Limit access of data now the user can use this view which i provide to him with the columns i need him to see only
 -- and i can change the name of returned cols also like we did here 
 -- This provide Encapsulation for your data and security




-- Creating View 
Create or Alter View AlexStudentsView 
As
    Select St_Id , St_Fname , St_Address
    from Student
    Where St_Address = 'Alex'

-- Calling 
Select * 
from AlexStudentsView


-- Creating View 
Create or Alter View CairoStudentView 
As
    Select St_Id , St_Fname , St_Address
    from Student
    Where St_Address = 'Cairo'

-- Calling 
Select * 
from CairoStudentView



-- Creating
Create or Alter View StudentDepDataView 
with encryption
As 
    Select St_Id , St_Fname , d.Dept_Id , d.Dept_Name
    From Student S , Department D 
    Where D.Dept_Id = S.Dept_Id

--Calling 
select * 
From StudentDepDataView

-- but we have this stored procedure 
sp_helptext 'StudentDepDataView' -- that return all info about the view

-- then we have option to encrypt it to add 'with encryption' in signature



--------------------------------------------
----------- 4.2 Partitioned View -----------
--------------------------------------------
-- More than on Select Statments  using union

Create or Alter View AlexCairoStudentView
with encryption 
As 
    Select * from AlexStudentsView
    union
    select * from CairoStudentView

select * 
from AlexCairoStudentView



--------------------------------------------
----------- 4.3. Views , Schema -------------
--------------------------------------------
-- by default all created views created in default schema 'dbo'

-- Create Schema
create schema CairoStudents

-- Transfer View to another schema
Alter Schema CairoStudents
Transfer dbo.CairoStudentView


Select * 
From CairoStudentView -- Invalid

Select * 
From CairoStudents.CairoStudentView -- Valid

-- move it back to dbo
alter schema dbo
transfer CairoStudents.CairoStudentView




----------------------------------------------------
----------- 4.4. Views With Encryption -------------
---------------------------------------------------- 


Create or ALter View CAiroAlexStudentGradesView
With Encryption
As 
    Select s.St_Fname , c.Crs_Name , sc.Grade , s.St_Address
    From Student S , Course C , Stud_Course SC
    Where S.St_Id = Sc.st_id And C.Crs_Id = sc.Crs_Id
    And St_Address in ('Cairo','Alex')


select * 
from CAiroAlexStudentGradesView

----- OR ----- To show how it simplify complex query

Create or ALter View CAiroAlexStudentGradesView
With Encryption
As 
    Select s.St_Fname , c.Crs_Name , sc.Grade , s.St_Address
    From AlexCairoStudentView S , Course C , Stud_Course SC
    Where S.St_Id = Sc.st_id And C.Crs_Id = sc.Crs_Id 

select * 
from CAiroAlexStudentGradesView


sp_helptext'CAiroAlexStudentGradesView' -- Encrypteed





----------------------------------------------------
----------- 4.5. Views With DML --------------------
---------------------------------------------------- 
-- No DML in View Body , But i can operate dml on view
-- when i mainpulate on view it mainupilate in the original table
-- [ Insert , Update , Delete ] 

Create or Alter View CairoStudentView (id , name , address)
As
    Select St_Id , St_Fname , St_Address
    from Student
    Where St_Address = 'Cairo'

Select * From CairoStudentView

---- IF 1 TABLE
-- Insert 
insert into CairoStudentView
values (9999,'andrew','cairo')
-- but must include all the cols in the view excpet if they was identity id or default 

-- update
update CairoStudentView
Set name = 'Alaa'
Where id = 12


-- delete
delete from CairoStudentView
where id = 9999


---- IF MULTIBLE TABLES
-- Insert
insert into StudentDepDataView
Values (1010,'Omar',100,'test') -- Invalid Cannot modify on multible tables in same update

-- lazm a7dd w table table

insert into StudentDepDataView(St_Id , St_Fname)
Values (1010 ,'Omar')

insert into StudentDepDataView(Dept_Id , Dept_Name)
Values (100 ,'test')


-- update 
update StudentDepDataView
set St_Fname = 'Alaa'
where St_Id  = 1


-- Delete 
Delete StudentDepDataView
Where St_Id = 1 -- cannot delete st_id has dependent
-- delete on multible tables view is invalid

 
----------------------------------------------------
----------- 4.6. Views With Check Constraint --------------------
---------------------------------------------------- 
-- constraint on the view creation

insert into CairoStudentView
Values (9998,'may','Alex') -- Valid but not true cuz we skip the constraint and add to alex 


Create or Alter View CairoStudentView 
With Encryption
As
    Select St_Id , St_Fname , St_Address
    from Student
    Where St_Address = 'Cairo' With check option 



insert into CairoStudentView
Values (9999,'may','Alex') -- Now it's invalid to insert into alex while view is for cairo























