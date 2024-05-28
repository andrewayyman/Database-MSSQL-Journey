/*============================================================= Practice  ===================================================================== */
use ITI

/* ================ PART 01 =============== */

-- 1 . No. of std with age value
select count (St_Age) [no of std with age value]
from Student   -- he doesnt count null already

-- 2.no of courses with topic
select t.Top_Name, count(c.Crs_Id) [No. of courses] 
from Course c , topic t
where t.Top_Id = c.Top_Id  -- pk = fk
group by t.Top_Name


-- 3 student name and his supervisor 
select s.St_Fname,Super.*
from Student S, Student Super
    where Super.St_Id = s.St_super  -- pk = fk


-- 4. display with isnull 
select s.St_Id,s.St_Fname + ' ' + Isnull(s.St_Lname,', no Lname') [Full Name] ,d.Dept_Name -- maybe i use concat also but it's ok
from Student s join Department d
    on s.Dept_Id = d.Dept_Id -- fl = pk


-- 5. insname and salary , no salary '0000', use isnull
select Ins_Name, Isnull(Salary,0000) 
from Instructor


-- 6. select super fname and count if his std
select Super.St_Fname, count(*) [No. of std]
from Student S, Student Super
    where Super.St_Id = s.St_super  -- pk = fk
Group by Super.St_Fname


-- 7, max an min salaries for ins
select  MAX(salary) [Max Sal],MIN(salary)[Min Sal]
from Instructor


-- 8.AVG
select  avg(salary) [AVG Sal]
from Instructor




/* ================ PART 02 =============== */
Use MyCompany

-- 1. ''for each'' proj list name, hr for all employees
select p.Pname, SUM( wf.Hours ) [Total Hours]
from Project p join Works_for wf
    on p.Pnumber = wf.Pno -- fk = pk 
group by p.Pname




-- 2.''foreach'' department get name, max\min\avg salary of it's employee
select d.Dname ,
       MAX(e.salary)[Max Salary] ,
       Min(e.Salary)[Min Salary],
       AVG(e.salary)[Avg Salary]
from Departments d join Employee e
    on e.Dno = d.Dnum -- fk = pk
group by d.Dname


-- 3. retrive list of emp and there projects orderd by dept 
select *
from employee e ,Works_for wf, Project p
where e.SSN = wf.ESSn  -- pk = fk 
And wf.Pno = p.Pnumber -- pk = fk 
order by e.Dno, e.Fname, e.Lname



-- 4. update all salaries who work on 'alrabwah' by 30%
Update Employee
set Salary += Salary * 0.3
from Employee e, Works_for wf, Project p
where e.SSN = wf.ESSn  -- pk = fk 
And wf.Pno = p.Pnumber -- pk = fk 
And p.Pname = 'Al Rabwah'
