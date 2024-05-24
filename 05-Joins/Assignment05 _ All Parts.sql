---------------------------------------------------- Assignment 05 ---------------------------------------------------------

-- Part 01
---------------------------------------------------------------------------------------

use ITI

-- 1  max min salary 
select Max(Salary) as 'Max Salary' , Min(Salary) as 'Min Salary'
from Instructor  -- 323423.00

-- 2 avg salary

 select Avg(Salary) as 'AVG Salary' 
from Instructor  -- 69575.2142


-- Part 02
---------------------------------------------------------------------------------------
use MyCompany

-- DQL : 
-- 1. 
Select E.SSN, 'Emp Name' = E.Fname +' '+E.Lname , P.Pname , D.Dname 
From Employee E join Departments D
	On D.Dnum = E.Dno -- PK = FK
join Project P
	On D.Dnum = P.Dnum	 -- PK = FK
Order By D.Dname


-- 2. 
Update E
Set E.Salary += (E.Salary *0.3)
From Employee E join Works_for WF
	On E.SSN = WF.ESSn -- Pk = FK
join Project P 
	On WF.Pno = P.Pnumber  --PK = FK
Where p.Pname = 'Al Rabwah'  
 
			-- 1 row affected which is kamel mohamed with essn 223344 to be with salary 2340
 select SSN, Fname,Salary
 from Employee
 where SSN = 223344  -- salary equal 2340 was 1800



 -- DML : 
-- 1. 
Insert into Departments (Dname,Dnum,MGRSSN,[MGRStart Date])
				 Values ('DEPT IT',100,112233,'1-11-2006')

-- 2. 
-- 2.A 
Update Departments
Set MGRSSN = 968574
From Departments
where Dnum = 100  -- 1 row affected noha now is manager of dep 100


-- 2.B
Update Departments
Set Dnum = 20
From Departments
where MGRSSN = 102672   


-- 2.C 
Update Employee
Set Superssn = 102672
from Employee
Where SSN = 102660 


-- 3

-- we cannot delete cuz it have dependent
Delete 
from Employee
Where SSN = 223344

-- Handle Dependents
	-- in departments, replace with null 'it allows null'
Update Departments
Set MGRSSN = NULL
from Departments 
Where MGRSSN = 223344

	-- in works_for replace the mgr to another manager, while there is id = 102672 like in assignment
Update Works_for
Set ESSn = 321654
from Works_for 
Where ESSn = 223344


	-- in Employee, replace the manager for 2 employees to another manager
Update Employee
Set Superssn = 321654
from Employee
Where Superssn = 223344

-- now it's deleted succefully ..
Delete 
from Employee
Where SSN = 223344




-- Part 03
---------------------------------------------------------------------------------------
use MyCompany


-- 1. 
Select E.Fname 
From Employee E
Join Works_for WF
    On E.SSN = WF.ESSn
Join Project P 
    On WF.Pno = P.Pnumber
Where E.Dno = 10 And P.PName = 'AL Rabwah' And WF.Hours >= 10;


-- 2. kamel mohamed who i just deleted him in part02 from task ? .. 
   -- i will replace him with amr omarn with id 321654
select Super.Fname,
       E.Fname SuperVisorName 

from Employee E Join Employee Super
    On E.SSN = Super.Superssn -- pk = fk 
Where Super.Superssn = 321654   -- ahmed,hana,edward,noha supervised by amr omran



-- 3. ALL MANAGERS DATA
Select
    E1.Fname AS ManagerName,
    E1.SSN AS ManagerSSN,
    E2.Fname AS SupervisedEmployee,
    D.Dname AS DepartmentManaged,
    D.[MGRStart Date] 

From Employee E1 -- AS MANAGER
Left Join Employee E2  -- AS EMPS
    On E1.SSN = E2.SuperSSN
Left Join Departments D 
    On E1.SSN = D.MgrSSN


-- 4.
Select E.Fname + '' +E.Lname [Employee Name ],
       P.Pname [Project Assigned]

From Employee E 
Left join Works_for Wf
    On E.SSN = Wf.ESSn --  pk = fk
Left Join Project P
    On Wf.Pno = P.Pnumber  -- pk = fk
Order By P.Pname



-- 5.
Select
    P.Pnumber,D.Dname, E.Lname, E.[Address], E.Bdate  

From Project P
Join  Departments D
    On P.DNum = D.DNum
Join Employee E 
    On D.MgrSSN = E.SSN
Where
    P.City = 'Cairo';



-- 6.
Select *
From Employee E 
Left Join Dependent Dp
    On E.SSN = DP.ESSN




-- Part 04
---------------------------------------------------------------------------------------
use MyCompany


-- 1.
Select 
    D.DNum As DepartmentID, 
    D.Dname As DepartmentName, 
    E.SSN As ManagerID, 
    E.Fname As ManagerName
From Departments D
Join Employee E 
    On D.MgrSSN = E.SSN;


-- 2.
Select 
    D.Dname,P.PName
From Departments D
LEft Join Project P 
    On D.DNum = P.DNum;


-- 3.
Select 
    D.*,E.Fname As EmployeeName
From Dependent D
Join Employee E 
    On D.ESSN = E.SSN;


-- 4.
Select 
    P.Pnumber,P.PName,P.Plocation,P.City
From Project P
Where P.City In ('Cairo', 'Alex');



-- 5. 
Select *
From Project P
Where P.PName Like 'a%';


-- 6.
Select*
From Employee E
Where E.Dno = 30 And E.Salary Between 1000 And 2000;



-- 7.
Select E.Fname 
From Employee E
Join Works_for WF
    On E.SSN = WF.ESSn
Join Project P 
    On WF.Pno = P.Pnumber
Where E.Dno = 10 And P.PName = 'AL Rabwah' And WF.Hours >= 10;




-- 8.
Select 
    E.Fname,P.PName 
From Employee E
Join Works_for WF
    On E.SSN = WF.ESSN
Join Project P 
    On WF.Pno= P.Pnumber
Order By P.PName;



-- 9. 
Select
    P.Pnumber,D.Dname, E.Lname, E.[Address], E.Bdate  

From Project P
Join  Departments D
    On P.DNum = D.DNum
Join Employee E 
    On D.MgrSSN = E.SSN
Where
    P.City = 'Cairo';



