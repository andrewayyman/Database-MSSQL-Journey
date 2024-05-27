/* ===================================================== Demo ====================================================================   */

use ITI
-- FUNCTIONS ..=>> 1. Built in funciton (SQL)
--                 2. User-Defined Function
---->> Scalar Fucntions (Returns value)
---->> Table Valued fucntion (Return Table)

-------------------------------------------------- 1. Built in Functions ---------------------------------------------------------------------------
/*
aggregate, null, string, date time, casting, system,ranking,math.
*/



-- 1 - AGGREGATE FUNCTIONS ==>> ( COUNT, SUM, MAX, MIN, AVG  )
------------------------------

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



-- 2 - NULL FUNCTIONS 
------------------------------

Select St_Fname
From Student
Where St_Fname is not Null

    -- ISNull (..,..) Replace Null Value On the Returning table, 2 parameters first is expression and second is the value to replace

Select ISNULL (St_Fname,'No Name')
From Student

Select ISNULL (St_Fname , St_Lname)
From Student

Select ISNULL (St_Fname , ISNULL(St_LName ,'No NAme'))
From Student

    -- Coalesce (...,...,...) Same AS IsNull But wiht multible Choices MAny parameters

Select Coalesce (St_Fname,St_LName,'No Name')
From Student




-- 3 - CASTING FUNCTIONS  ( Convert drom data type to another)
------------------------------  
-- [Convert, Cast]

  --  2.1 Convert (datatype, Expression)  ^can have third parameter which is style..

Select St_Fname + ' ' + St_Age 
FRom Student -- cannot concat string + int =>> error


Select St_Fname + ' ' + Convert(varchar(max) ,St_Age)
FRom Student   
-- but this return null , cuz age is maybe equal null ... String + null = null , then we need to valdiate the age is not null


Select St_Fname + ' ' + Convert(varchar(max) ,IsNull(St_Age,'0')) -- to replace the null age to 0
FRom Student   


    --2.2 Cast ( Expression as Data_Type ) ( St_Age as varchar(max) )

Select St_Id, St_Fname + ' ' + Cast ( ISNULL(St_Age,'0') as varchar(max) )  -- same as convert but diff syntax till now
FRom Student   


-- DateTime to string 
-- convert function may take third parameter which is style 

select GETDATE() 

select Cast (GETDATE() as varchar(max))
select CONVERT(varchar(max), GetDate())
-- now they look same but in convert i can add new parameter to style the returning date styling

select CONVERT(varchar(max), GetDate(), 101)
select CONVERT(varchar(max), GetDate(), 102)
select CONVERT(varchar(max), GetDate(), 103)
select CONVERT(varchar(max), GetDate(), 104)
select CONVERT(nvarchar(max), GetDate(), 130) -- make it nvarchar not only varchar to return arabic



-- Concat ( convert all parameters to string ) AND Concat them AND Convert null to empty string

-- ahmed 21 without null for all
Select Concat( St_Fname, ' ',St_Age )
From Student






-- 4 - DATETIME FUNCTIONS  
------------------------------  

-- return the current date
select getdate() 

-- Return the day from the current date
Select Day (GetDate()) -- maybe year or month also

-- Return the last date of last day in this month
Select EOMONTH(GETDATE())


-- Format() -> change the format of date ^ Not data type
Select FORMAT(GETDATE(), 'dd/MM/yy' ) 
Select FORMAT(GETDATE(), 'ddd/MM/yy' ) 
Select FORMAT(GETDATE(), 'ddd/MMM/yy' )  
Select FORMAT(GETDATE(), 'ddd/MMM/yy hh:mm:ss tt ' )
        -- alot of format you can now more from ms documenation


-- all letter smal except the Month must be capital 'M'

-- dd -> number of day
-- ddd -> name of dat
-- MM -> number of month
-- MMM -> name of month
-- yy -> number of year
-- yyyy -> full number of year
-- hh -> hours
-- mm -> min
-- ss -> seconds
-- tt -> p, or am 


-- you can add another parameter which is the language 'culture' 
Select FORMAT(GETDATE(), 'ddd/MMM/yy hh:mm:ss tt ','ar' )






-- 5 - GROUPBY FUNCTIONS  -- Split Table Groups
------------------------------ 
 
-- what if we need min salary '''for each''' department ->> we need to use groupby  , usually with for each 
Select Ins_Name, Dept_Id
From Instructor
order by Dept_Id
    -- then that's not we want, we want for each department 

Select Dept_Id, Min(Salary) [Min Salary]
From Instructor
Group by Dept_Id -- we group by the depid then each unique deptid will be in seperated group and we can operate any aggreggate func on it


-- Note group with a repeated column

-- no of std in each deparment
Select Dept_Id, count(*) [no. of std]  -- if i want to add another col. to select then i need to add another gp also
from Student
group by Dept_Id


-- no of std in each deparment with address
Select Dept_Id, St_Address, count(*) [no. of std]  
from Student
group by Dept_Id ,St_Address



-- Where -> condition on row
-- Having -> condition on group

-- no of std in each deparment with more than 3 std then we use having
Select Dept_Id, count(*) [no. of std]  
from Student
group by Dept_Id
Having Count(*) > 3


-- Grouby with join
select S.Dept_id,
       d.Dept_Name,
       Count(*)

from Student S join Department D
    on D.Dept_Id = S.Dept_Id
group by S.Dept_Id, D.Dept_Name


-- NOTE ==>> Lma tla2eee nfsk bt3ml select l lcolumn w m3aah aggregation e3rf enk ht7taag groupby 




-- sum of salaries for instructors and add condition
select Dept_Id,sum(Salary)[Sum of salaries], Count(*)[No. Of ins]
from Instructor
group by Dept_Id
Having Count(*) > 1



-- u can use having without group by 'only 1 scenario'
-- like when we need avg of salaries for instructors " filtre based on value returned from aggregate func  "

select avg(salary)
from Instructor
where avg (salary) > 10000 -- invalid cannot use where with aggregate


select avg(salary)
from Instructor
having avg (salary) > 10000


---- Group by with self
-- no of students for each supervisro
select s.St_super,Super.St_Fname, count(*) [No. of std]
from Student S, Student Super
    where Super.St_Id = s.St_super  -- pk = fk
Group by s.St_super,Super.St_Fname

