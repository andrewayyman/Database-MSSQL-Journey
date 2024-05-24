-------------------------------------------- Assignment 05 Demo -------------------------------------------------
use ITI

-- Joins --
-- 1. Cross join 'Cartesian ' Fake data
-- 2. inner join 
-- 3. Left || Right join
-- 4. self join 'unary relationship'



-- 1 Cross Join  'Fake Data'
------------------------------

-- Old Sql 
select S.St_Fname , D.Dept_Name
from Student S , Department D

-- New Sql 
select S.St_Fname , D.Dept_Name
from Student S cross join Department D


-- 2 Inner Join  'Most Used' no chance to return null values 
------------------------------

-- Old Sql
select s.St_Id,s.St_Fname , D.Dept_Name
from Student s , Department D 
where D.Dept_Id = s.Dept_Id -- pk = fk 

-- New Sql  ===>> use On and join keyword
select s.St_Id,s.St_Fname , D.Dept_Name
from Student s inner join Department D 
on D.Dept_Id = s.Dept_Id -- pk = fk 



-- 3.1 LEft Join ==>> Get All the left mandatory , maybe return null 
------------------------------

-- only new Sql Synatx
Select S.St_Fname , d.Dept_Name
From Student s left outer join Department d
On D.Dept_Id = s.Dept_Id  -- pk = fk


-- 3.2 Right Join ==>> Get All the right mandatory 
------------------------------

-- only new Sql Synatx
Select S.St_Fname , d.Dept_Name
From Student s right outer join Department d
On D.Dept_Id = s.Dept_Id  -- pk = fk


-- 3.3 Full Join ==>> Get All in the tables you join even they have null .. 
------------------------------

-- only new Sql Synatx
Select S.St_Fname , d.Dept_Name
From Student s full outer join Department d
On D.Dept_Id = s.Dept_Id  -- pk = fk



-- 4. Self Join ==>> with unary relationship
-------------------------------

select s.St_Fname , Super.St_Fname as 'SuperVisor Name' , Super.*
from Student s , Student Super
where Super.St_Id = s.St_super -- pk = fk 



--  Multible table Join 
-------------------------------

-- Old Sql
Select S.St_Id,S.St_Fname , C.Crs_Name , SC.Grade
From Student S , Stud_Course SC , Course C
where S.St_Id = SC.St_Id And C.Crs_Id = SC.Crs_Id -- pk = fk


-- New Sql ==>> the On must follow Join keyword
Select S.St_Id,S.St_Fname , C.Crs_Name , SC.Grade
From Student S join Stud_Course SC 
	On S.St_Id = SC.St_Id  -- pk = fk
join Course C
	On C.Crs_Id = SC.Crs_Id -- pk = fk
---------------------------------------------------------------------------------------------------------

-- Join With DML ( Insert - Update - Delete )
---------------------------

-- BEFORE USING UPDATE
Select s.St_Fname , S.St_Address , SC.Grade
From Student S , Stud_Course SC 
Where S.St_Id = SC.St_Id And S.St_Address = 'Cairo'  -- pk = fk


-- UPDATING
Update Sc
set SC.Grade = SC.Grade + ( SC.Grade *0.1 )
From Student S , Stud_Course SC 
Where S.St_Id = SC.St_Id And S.St_Address = 'Cairo'  -- pk = fk


-- AFTER USING UPDATE
Select s.St_Fname , S.St_Address , SC.Grade
From Student S , Stud_Course SC 
Where S.St_Id = SC.St_Id And S.St_Address = 'Cairo'  -- pk = fk



-- Delete 
Delete From SC
From Student S , Stud_Course SC 
Where S.St_Id = SC.St_Id And S.St_Address = 'Cairo'  -- pk = fk

---------------------------------------------------------------------------------------------------------
-- FUNCTIONS ..

-- AGGREGATE FUNCTIONS ==>> ( COUNT, SUM, MAX, MIN, AVG  )
---------------------------

-- COUNT
Select Count (*) AS 'No. of instructors'
From Instructor  -- 15

-- SUM 
select Sum(Salary) As 'Sum Of Salary'
from Instructor -- 974053.00


select Sum(Ins_Name) 
from Instructor -- Invalid type


-- AVG	
select Avg(Salary) As 'Avg Of Salary'
from Instructor -- 69575.2142


-- MAX
select MAX(Salary) As 'MAX Of Salary'
from Instructor -- 323423.00


-- MIN
select MIN(Salary) As 'MIN Of Salary'
from Instructor -- 2323.00


select Min(Ins_Name) 
from Instructor -- return by alphabetically [aA-zZ] A,a Is Min Z,z Is MAx

-- !! NOT Preferred to use this aggreagte funcitons with non numeric even it's not returning syntax errors
