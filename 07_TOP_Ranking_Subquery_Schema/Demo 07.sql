/**====================================== Demo Assignment 07 =====================================================*/
Use ITI

/* == Demo Content ==

- Subquery
- Top 
- Random
- Ranking Fun 
- Execution Order
- Schema

*/

/* ========================================== SubQuery ======================================= */
-------------------------------------------------------------------------

Select st_id, St_Fname, St_Age
from student
where St_Age > avg(St_Age) -- In valid 
/*
 invalid cuz cannot use aggregate with where cuz where execute by row and by the data mapped by row 
 but avg of age not in the table so no use for aggregate with where
*/

-- but we can split it
select avg(st_age)
from Student -- 26

 
select st_id,St_Fname,St_Age
from Student
where St_Age > 26 -- we put directly 26 here 

-- but we need to make it variable not fixed number so we use *SUBQUERY* 

-- outer query
select st_id,St_Fname,St_Age
from Student
where St_Age > ( select avg(st_age) from Student ) -- inner query

-- But it's not recommended due to it's performance 

Select Count(*)
from Student

/* st_ID:Count(*)
    1:19
    2:19
    3:19

select st_id , 19
from student

*/
select St_Id,( Select Count(*) from Student )  --19
from Student

-------- SubQuery + Join --------

-- dept names that have students 

-- using join
Select Distinct D.Dept_Name
From Student S , Department D
where s.Dept_Id = d.Dept_Id -- pk=fk

-- another method
Select Dept_Name
from Department
Where dept_id in (10,20,30,40)

Select distinct Dept_Id 
from Student
where Dept_Id is not null -- out => 10 20 30 40 

-- then we can use subquery 
-- outer query
Select Dept_Name
from Department
Where dept_id in 
    (
    Select distinct Dept_Id 
    from Student
    where Dept_Id is not null -- inner query 
    )

-------- SubQuery + dml 'inset , update , delete' --------

-- delete students grades who live in cairo 

--select sc.Grade
delete from sc
from student s, Stud_Course sc
where s.St_Id = sc.St_Id  -- pk=fk 
And s.St_Address = 'Cairo'

----- another method 

delete from Stud_Course
where St_Id in (
    select St_Id
    from Student
    where St_Address = 'Cairo' -- assume return 4 ids then will be deleted from stud_Course those 4 ids
    )




/* ======================================== Top ======================================= */
-------------------------------------------------------------------------
/*
    - Keyword to get the top rows 
    - No key words named bottom 
    - The TOP keyword is used to limit the number of rows returned by a query.
    - Top PErcentage => SELECT TOP 10 PERCENT * FROM Employees; – returns the top 10% of rows.



*/

-- top percentage
SELECT TOP 10 PERCENT * FROM Student

-- first 2 students
select top( 2 )*
from Student

select top(5) St_Id, St_Fname, St_Age 
from Student

-- select last 5 stds 
select top(5) St_Id, St_Fname,St_Lname,St_Age
from Student
order by St_Id desc 

-- ins with max salary --> not just the max salary as a number no the instrucor himeslf
select top(1) Ins_Name, Ins_Id,salary
from Instructor
order by Salary desc

-- the second max salary  
--without using top
select max (Salary) ' 2nd max salary '
from Instructor
where salary != ( select MAX(salary) from Instructor )

--with top
select top(1) * from
(select top(2) Ins_Id, Ins_Name, Salary
from Instructor
order by Salary desc ) as newtable
order by Salary --98989.00
         


/* ======================================== Top with ties ======================================= */
-------------------------------------------------------------------------
/*

    - same as top but it includes the record after the last record if this record equal tha last
    - [30 29 28 27 26 26 24] top(5) ==> [30 29 28 27 26 ]     
    - [30 29 28 27 26 26 24] top(5) with ties ==> [30 29 28 27 26 26 ]     

    - works with order by only **
*/

-- top
select top(5) St_Age
from Student
order by St_Age desc

-- top with ties
select top(5) with ties St_Age
from Student
order by St_Age desc


/* ======================================== Random Selection ======================================= */
-------------------------------------------------------------------------
/*
    - NewID() -> GUID (global universal id) => used for random selection and it's unique 
    - 32 digit , hexdecimal
*/
select NEWID() -- GUID

select St_Fname, newid()
from Student

select top(3) newid() [Random id],St_Fname
from Student
order by newid() -- now we order by generated id which is change randomly every execution 


/* ======================================== Ranking Function ======================================= */
-------------------------------------------------------------------------

/*
    - Row_Number()==> No Duplicate Rank,In Case i want sequental rank [1,2,3,4,5]
    - Dense_Rank()==> Can Duplicate Rank,In Case i can make same person in same rank [1,2,2,3,4,4,5] *but all number included*
    - Rank()      ==> Can Duplicate Rank but the next rank not require to be sequential,
                        In Case busineed need is to allow numbers not sequential [1,1,3,3,5,5,7,7,9,9]
                        the next rank is = last rank + no. of it's duplicates 
                        next rank = 7 + 2 = 9  ' 2 is how many 7 is occured ' 

*/

-- Row_Number()
select Ins_Name,Salary,ROW_NUMBER() over (order by salary desc) as RNumber
from Instructor
-- Ranking 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 => when equal value it's ranked based on another cond no duplication


-- Dense_Number()
select Ins_Name,Salary,Dense_Rank() over (order by salary desc) as DRank
from Instructor
-- 1 2 3 4 5 6 7 8 9 10 10 11 11 12 13 ==> it's same but when there's equal rank it can be duplicated


-- Rank() 'With Gaps'
select Ins_Name,Salary,Rank() over (order by salary desc) as R
from Instructor
-- 1 2 3 4 5 6 7 8 9 10 10 12 12 14 15 => now when equal rank it's shifted after duplicated 


----- get the 2 older students 

-- using ranking 
select *
from
(select St_Fname , St_Age, ROW_NUMBER() over( order by st_Age desc ) as ranknumebr
from student) as newtable
where ranknumebr <= 2

-- using top 'Recommended'
select top(2) st_Fname,St_Age
from student
order by St_Age desc -- 44,34



----- Get 5th younger student 
-- using ranking 'Recommended' cuz both have subquery but this not too much order by
select * 
from
(select St_Fname, St_Age, Row_Number() over ( order by St_Age )[rn]
from Student
where St_Age is not null ) as newtable
where rn = 5 

-- using top
select top(1) *
from
(select top(5) St_Fname,St_Age
from Student
where St_Age is not null
order by St_Age) as newtable
order by St_Age desc



-- Younger std at each department 
---------------------------------
select St_Fname, St_Age, Dept_Id, ROW_NUMBER() over ( partition by Dept_Id order by St_Age ) as rn
from Student
where St_Age is not null AND Dept_Id is not null

-- partition -->> cut the table to many partition in the same table and rank every partition seperated 
-- sounds like group by but in the same table and with ranking 


-------------- Ranking NTile ----------------- 
----------------------------------------------
/*
    - it divides the table into quartile 
    - seperate the table into equal groups 
    - The NTILE function is a powerful tool for data segmentation,
    - allowing for analysis and strategic decision-making. 
      helps in breaking down data into manageable, equally sized groups,
      providing clarity and focus in various analytical contexts.
*/


-- 5 instructors for lowerst salary
select * 
from
( Select Ins_Name, Salary, NTILE(3) over( order by salary ) as rn
from Instructor  -- 3 quartiles ,,, 15 row then it divides 15 / 3 ==> 5 for each quartile 
where salary is not null ) as newtable
where rn = 1

 -- using top 
select top(5) *
from Instructor
where salary is not null
order by Salary



/* ======================================== Execution Order ======================================= */
------------------------------------------------------------------------------------------------------

/*
1- FROM 
2- WHERE
3- GROUP 
4- HAVING
5- SELECT
6- DISTINCT
7- ORDER BY
8- OFFSET-FETCH 

*/

select CONCAT(st_fname, ' ', St_Lname) as [fullname]  
from Student    
where full name = 'Ahmed Hassan' -- inavalid 


select CONCAT(st_fname, ' ', St_Lname) as [fullname]  
from Student    
where CONCAT(st_fname, ' ', St_Lname) = 'Ahmed Hassan' -- valid



/* ========================================== Schema ======================================= */
-------------------------------------------------------------------------

/*
    - HIERARCHY : Server ==>> Database ==>> Schema ==>> Database Objects [table , function , view , stored procedure]
    - A schema in SQL Server is a container for database objects such as tables, views, procedures, etc.
    - It helps in organizing and managing database objects.
    - Schema helps that now you can name many object with same name 
    - Help in security and permissions grant access    


*/

select @@SERVERNAME
select * from Student -- is same as 
select * from [WILDRABBIT].[iti].[dbo].Student
     -- but we ignore server name cuz it's server which we connect on 
     -- we ignore iti cuz we use it already
     -- ignore dbo cuz it's the default schema already if it's in another schema we should specify    
  


-- to Create Schema [DDL]
Create Schema Sales  

-- To Move Table from schema to another
alter schema Sales
Transfer STudent -- now we transferd studen table to another schema not deafult

-- if we try to access this table like the old way it's not valid cuz it's not in default schema
select * from Student 

-- we need to specify 
select * from Sales.Student -- working

-- let's move back the table to the default schema 
alter schema dbo
transfer sales.student -- it's moved back now to default schema 'dbo'

-- NOTE : when i use alter i alter on the schema that i want to move the table to it

-- If i want to  add new table with same nsame as old table add to another schema : 
create table sales.Department
(
    id int primary key 
)


-- to drop schema 
drop schema Sales -- can't drop schema while it have objects 

-- then 
drop table sales.Department
drop schema sales































































