--Session 04 Demo  
Use company
-- 1. DDL (create - alter - drop )
-- 2. DML (insert - update - delete)

-- 2.1 Insert 
-- 2.1.1 Simple Insert 

Insert Into Employees values ('ahmed','ali','M','10/28/1990','Cairo',NULL,NULL)
Insert Into Employees values ('Amr','Ahmed','M','10/28/1990','Cairo',NULL,1)


Insert Into Employees (Fname,Lname,BirthDate,Dnum,superSNN) 
values ('Amr','Ahmed','10/28/1990',NULL,NULL)

/*
fname is requited no insert without it 
can insert without the default attribute or allow null or has identity
*/


-- 2.1.2 Row Constructor Insert - more thatn one row 


Insert Into Department 
values
('Hr',1,'10/28/1990'),
('IT',2,'10/28/1990'),
('Sales',3,'10/28/1990')

--Insert Into Department Values ('Marketing',10,'10/28/1990')

Insert Into Department Values ('Marketing',1,'10/28/1990')




-- 2.2. Update

Update Employees
set Address = 'Alex'
Where SSN = 3

Update Employees
Set Fname = 'Ali'
Where Fname = 'amr' 


Update Department
Set MGRSSN = 1
Where Dnum = 10


-- 2.3. Delete 

-- cannot delete cuz it has another dependents
Delete From Employees
Where SSN = 1

-- no dependent for this ssn it's valid to delete
Delete From Employees
Where SSN = 4



----------------------- DQL ------------------------

----- Select 

Select * 
from Employees


Select Fname,Lname
from Employees

select Fname+' '+Lname as 'Full Name'
from Employees


use ITI

SELECT St_Id , St_Fname, St_Address
FROM Student


SELECT St_Id , St_Fname, St_Address
FROM Student	
where St_Age > 25


SELECT St_Id , St_Fname,St_Age
FROM Student
where St_Age > 20 and St_Age < 30


SELECT St_Id , St_Fname,St_Age
FROM Student
where St_Age between 20 and 30


SELECT St_Id , St_Fname,St_Address
FROM Student
where St_Address = 'Cairo'



SELECT St_Id , St_Fname,St_Address
FROM Student
where St_Address = 'Alex'



SELECT St_Id , St_Fname,St_Address
FROM Student
where St_Address = 'Mansoura'



SELECT St_Id , St_Fname,St_Address
FROM Student
where St_Address = 'Mansoura' or St_Address = 'Cairo' or St_Address = 'Alex'

-- OR 

SELECT St_Id , St_Fname,St_Address
FROM Student
where St_Address in ('Mansoura' ,'Cairo' , 'Alex')



SELECT St_Id , St_Fname,St_Address
FROM Student
where St_Address not in ('Mansoura' ,'Cairo' , 'Alex')




SELECT St_Id , St_Fname,St_Address
FROM Student
where St_Address != 'Cairo'




SELECT St_Id , St_Fname,St_super
FROM Student
where St_super is not NULL              -- != NULL not valid



-- LIKE 

SELECT St_Id , St_Fname
FROM Student
Where St_Fname like 'a%'



SELECT St_Id , St_Fname
FROM Student
Where St_Fname like '%[%]'



SELECT St_Id , St_Fname
FROM Student
Where St_Fname like '[ah]%'




SELECT St_Id , St_Fname
FROM Student
Where St_Fname like '[^ah]%'



-- Order By 

-- ascend
Select St_Id , St_Fname, St_Age
From Student
order by St_Age



-- descend
Select St_Id , St_Fname, St_Age
From Student
order by St_Age desc



Select St_Id , St_Fname, St_Age
From Student
order by St_Fname



Select St_Id , St_Fname, St_Age
From Student
order by St_Fname desc , St_Age asc



-- distinct "unique"


select distinct St_Address
from Student
where St_Address is not NULL 