/*================================================= Assignment 07 ==============================================================*/



--=================== Part 01 ===============--
-----------------------------------------------
Use ITI 

--1.Display instructors who have salaries less than the average salary of all instructors.
select *
from Instructor
where salary < ( select AVG(salary) from Instructor )


--2.Display the Department name that contains the instructor who receives the minimum salary.
select d.Dept_Name,I.Salary 
from Department D , Instructor I
where d.Dept_Id = i.Dept_Id -- pk= fk
AND i.Salary = ( select MIN(salary) from Instructor )


--3.Select max two salaries in instructor table. 
select top(2) Ins_Name,salary 
from Instructor
order by Salary desc


--4.Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
select * 
from (
select salary, Dept_Id, ROW_NUMBER() over ( partition by dept_id order by salary desc ) as r1
from Instructor ) as newtable
where r1 <= 2 

--5.Write a query to select a random  student from each department.  “using one of Ranking Functions”
select *
from (
select St_Fname, Dept_Id, ROW_NUMBER() over (partition by dept_id order by newid() ) as r1
from Student ) as newtable
where Dept_Id is not null and r1 = 1 



Use MyCompany 
--1.Display the data of the department which has the smallest employee ID over all employees' ID.
select D.*
from Departments D , Employee E1
where D.Dnum = E1.Dno
and E1.SSN = (select Min(E2.ssn) from Employee E2) 


--2.List the last name of all managers who have no dependents.
select E.Fname,E.Lname
from Employee E , Departments D
where E.SSN = D.MGRSSN 
and E.SSn not in (Select essn from Dependent)


--3.For each department-- if its average salary is less than the average salary of all employees display its number, name and number of its employees.
select D.Dnum , D.Dname , Count(E.SSN) as Num_Of_Empolyees
from Departments D , Employee E
where D.Dnum = E.Dno 
group by D.Dnum , D.Dname
having Avg(E.Salary) <  ( select Avg(Salary) From Employee )


--4.Try to get the max 2 salaries using subquery
SELECT salary
FROM (
    SELECT salary, ROW_NUMBER() OVER (ORDER BY salary DESC) AS r1
    FROM Employee
) AS newtable
WHERE r1 <= 2;



--5.Display the employee number and name if he/she has at least one dependent (use exists keyword) self-study.
select E.SSN , E.Fname
from Employee E , Dependent D
where E.SSN = D.ESSN and exists(Select Essn from Dependent)



--=================== Part 02 ===============
------------------------------------------------
-- Restore adventureworks2012 Database 
use adventureworks2012

-- 1.Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
select SalesOrderID , ShipDate
from sales.SalesOrderHeader
where OrderDate between '7/28/2002' and '7/29/2014'


-- 2.Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select ProductID , Name
from Production.Product
where StandardCost < 110 

-- 3.Display ProductID, Name if its weight is unknown
select ProductID , Name
from Production.Product
where Weight is null 


-- 4.Display all Products with a Silver, Black, or Red Color
select ProductID , Name , Color
from Production.Product
where Color in ('Silver' , 'Black' , 'Red')


-- 5.Display any Product with a Name starting with the letter B
select Name as Product_Name
from Production.Product
where Name like 'B%'


-- 6.Run the following Query, Then write a query that displays any Product description with underscore value in its description.

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

-- answer 
Select Description
from Production.ProductDescription
where Description like '%[_]%'

--7.Display the Employees HireDate (note no repeated values are allowed)
select distinct HireDate 
from HumanResources.Employee


--8.Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
select 'The ' + Name + 'is only! ' + CONVERT(nvarchar(30),ListPrice) as Products_With_Price
from Production.Product
where ListPrice between 100 and 120
order by ListPrice



