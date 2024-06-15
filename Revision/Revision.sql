--=============================================== Revision ==========================================================

use Library

--1. Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name.
select CONCAT (Fname ,' ', Lname)
From Employee
where LEN(Fname) > 3

--2.Write a query to display the total number of Programming books available in the library with alias name ‘NO OF PROGRAMMING BOOKS’ {1 Point} 
select Count (id) [NO OF PROGRAMMING BOOKS]
from Book
where Cat_id = 1


--3.Write a query to display the number of books published by (HarperCollins) with the alias name 'NO_OF_BOOKS'. {1 Point} 
select Count (id) [NO_OF_BOOKS]
from Book
where Publisher_id =1 


--4.Write a query to display the User SSN and name, date of borrowing and due date of the User whose due date is before July 2022. {1 Point} 
select u.SSN , u.User_Name , b.Borrow_date , b.Due_date
from Users u ,Borrowing b
where u.SSN = b.User_ssn
And b.Due_date < '2022-07-01'



--5.Write a query to display book title, author name and display in the following format,
---------' [Book Title] is written by [Author Name]. {2 Points} 
SELECT CONCAT('[', b.Title, '] is written by [', a.Name, ']') as 'Book written by'
From Book b join Book_Author ba
    On b.Id = ba.Book_id
join Author a 
    On a.Id = ba.Author_id



--6.Write a query to display the name of users who have letter 'A' in their names. {1 Point} 
select SSN , User_Name
from Users
where User_Name like '%a%'

--7.Write a query that display user SSN who makes the most borrowing{2 Points} 
select top(1) * from (
Select u.SSN, u.User_Name, COUNT(b.User_ssn) [borrow_count]
From Users u , Borrowing b 
Where u.SSN = b.User_ssn
Group By u.SSN, u.User_Name
) as newtable
order by borrow_count desc

--8.Write a query that displays the total amount of money that each user paid for borrowing books. {2 Points} 
Select u.SSN ,u.User_Name, SUM (b.Amount) [Total Money spent]
From Users u , Borrowing b 
where u.SSN = b.User_ssn
group by u.SSN ,u.User_Name

--9.write a query that displays the category which has the book that has the minimum amount of money for borrowing. {2 Points} 

Select Top(1) * from (
Select c.Cat_name , MIN(bow.Amount) [min amount]
From Book b join Category c
    On b.Cat_id = c.Id
join Borrowing bow
    On bow.Book_id = b.Id
group by c.Cat_name
) as subquery
order by [min amount] 


--10.write a query that displays the email of an employee if it's not found, display address if it's not found, display date of birthday. {1 Point} 
Select Coalesce ( Email, Address, Convert ( varchar,DOB ) ) as 'Info'
from Employee 


--11.Write a query to list the category and number of books in each category with the alias name 'Count Of Books'. {1 Point} 
select c.Cat_name , COUNT (b.Id) as  'Count Of Books'
From Book b , Category c 
Where b.Cat_id = c.Id
group by c.Cat_name


--12 Write a query that display books id which is not found in floor num = 1 and shelf-code = A1
Select b.Id , sh.Floor_num , b.Shelf_code
From Book b , Shelf sh 
where b.Shelf_code = sh.Code
And sh.Floor_num != 1 
And b.Shelf_code = 'A1'


--13.Write a query that displays the floor number , Number of Blocks and number of employees working on that floor.{2 Points} 

Select f.Number[Floor Number] , f.Num_blocks , Count(e.id) as 'employees working on that floor'
From [Floor] f , Employee e 
where f.Number = e.Floor_no 
group by f.Num_blocks , f.Number



--14.Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points} 
Select b.Title , u.User_Name , bow.Borrow_date
From Book b join Borrowing Bow
    On b.Id = bow.Book_id
Join Users u
    On U.Emp_id = bow.Emp_id
WHERE bow.Borrow_date BETWEEN '2022-03-01' AND '2022-10-01';

--15.Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name.{2 Points} 
Select  CONCAT(e.fname , e.Lname) AS Employee_Full_Name,
        Concat(sup.Fname , sup.Lname)  AS Supervisor_Name
From Employee e , Employee sup
Where e.Super_id = sup.id;



--16.Select Employee name and his/her salary but if there is no salary display Employee bonus. {2 Points} 
select Fname , isnull(Salary, Bouns) 
from employee 


--17.Display max and min salary for Employees {2 Points} 
select max(Salary) from Employee
select min(Salary) from Employee


--18.Write a function that take Number and display if it is even or odd {2 Points} 
create function isOddOrEven(@num int)
returns varchar(50)

begin
	declare @message varchar(50)
	if @num %2 = 0
		set @message = 'is even'
	else if @num %2 != 0
		set @message = 'is odd'
	return @message
end
-- run
select dbo.isOddOrEven(2)
select dbo.isOddOrEven(5)


--19.write a function that take category name and display Title of books in that category {2 Points} 
create or alter function categoryBooks(@CatName nvarchar(50))
returns @t table
(
	Book_title nvarchar(max)
)
as 
begin
	insert into @t
	select Title
	from Category c , Book b
	where c.Id = b.Cat_id and c.Cat_name = @CatName
 return
 end
 
-- run
select * from dbo.categoryBooks('self improvement')



--20. write a function that takes the phone of the user and displays Book Title , user-name,
    --  amount of money and due-date. {2 Points} 
create or alter function getUserBookAndAmountByPhone (@phone nvarchar(100))
returns @t table
(
	Title nvarchar(50),
	User_Name nvarchar(50),
	Amount int,
	Due_Date date
)
as
begin

	insert into @t
	select b.Title , u.User_Name , bw.Amount , bw.Due_date 
	from Borrowing bw , Book b , Users u , User_phones uph
	where b.Id = bw.Book_id and u.SSN = bw.User_ssn and u.SSN = uph.User_ssn and uph.Phone_num = @phone
	return
end

-- run
select * from dbo.getUserBookAndAmountByPhone('0123652145')



--21.Write a function that take user name and check if it's duplicated return Message in the following format ([User Name] is Repeated 
-----[Count] times) if it's not duplicated display msg with this format [user  name] is not duplicated,if it's not Found Return [User Name] is Not Found
create or alter function repeatedName(@uName nvarchar(50))
returns nvarchar(max)
begin
	declare @c int
	declare @message nvarchar(max)

	select @c = count(*)
	from Users
	where  User_Name =@uName

	if @c>1
		set @message = concat(@uName , ' is Reapeted ' , @c , ' times')
	else if @c = 1
		set @message = concat(@uName ,' is not duplicated')
	else if @c = 0
		set @message = concat(@uName ,' is Not Found')

	return @message

end
-- run
select dbo.repeatedName('Amr Ahmed')



--22.Create a scalar function that takes date and Format to return Date With That Format 

create or alter function SetDateFormat(@d date,@format nVArchar(100))
returns nvarchar(100)

begin
	declare @newDate nvarchar(100) 
	set @newDate = format(@d,@format)
	return @newDate
	end
-- run
select dbo.SetDateFormat(getdate(),'yyyy/MM/dd')
	

--23.Create a stored procedure to show the number of books per Category 
create or alter proc numOfBookPerCategory
as
select c.Cat_name , count (*)[Num of books per Category]
from book b , Category c
where c.Id = b.Cat_id
group by c.Cat_name

exec numOfBookPerCategory



--24.Create a stored procedure that will be used in case there is an old manager who has left the floor and a new one becomes his replacement. The 
-----procedure should take 3 parameters (old Emp.id, new Emp.id and the floor number) and it will be used to update the floor table. {3 Points} 
create proc oldToNewManger(@oldEmpId int,@NewEmpId int ,@FloorNum int)
as
	begin try
		update Floor 
		set MG_ID = @NewEmpId
		where MG_ID=@oldEmpId and Number = @FloorNum
	end try
	begin catch
		print'error occurred'
	end catch





--25.Create a view AlexAndCairoEmp that displays Employee data for users who live in Alex or Cairo 
Create or alter view AlexAndCairoEmp
as
select *
from Employee
where Address in('alex' , 'cairo')



--26.create a view "V2" That displays number of books per shelf  
create or alter view V2
as
select sh.Code , count(*)[number of books per shelf]
from book b , Shelf sh 
where sh.Code = b.Shelf_code
group by sh.Code 




--27.create a view "V3" That display  the shelf code that have maximum  number of  books using the previous view "V2" {2 Points} 
create or alter view V3
as
select max([number of books per shelf])[Max num of books] 
from V2


-- Solved with help from chatgpt TBH
--28 .Create a table named ‘ReturnedBooks’ With the Following Structure :
    --(User SSN, Book Id, Due Date,Return Date,fees)
    --then create A trigger that instead of inserting the data of returned book 
    --checks if the return date is the due date or not if not so the user must pay 
    --a fee and it will be 20% of the amount that was paid before. {3 Points}
create table ReturnedBooks(
    User_SSN int,
    Book_Id int,
    Due_Date date,
    Return_Date date,
    fees int)

CREATE OR ALTER TRIGGER CheckReturnDate
ON ReturnedBooks
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @User_SSN INT,
            @Book_Id INT,
            @Due_Date DATE,
            @Return_Date DATE,
            @Amount DECIMAL(10, 2),
            @Fees DECIMAL(10, 2);

    SELECT @User_SSN = i.User_SSN,
           @Book_Id = i.Book_Id,
           @Due_Date = i.Due_Date,
           @Return_Date = i.Return_Date
    FROM inserted i;

    SELECT @Amount = bw.Amount
    FROM Borrowing bw
    WHERE bw.User_SSN = @User_SSN AND bw.Book_Id = @Book_Id;

    IF @Return_Date <> @Due_Date
    BEGIN
        SET @Fees = @Amount * 0.20;
    END
    ELSE
    BEGIN
        SET @Fees = 0;
    END

    -- Insert the data into the ReturnedBooks table
    INSERT INTO ReturnedBooks (User_SSN, Book_Id, Due_Date, Return_Date, Fees)
    VALUES (@User_SSN, @Book_Id, @Due_Date, @Return_Date, @Fees);
END




--29.In the Floor table insert new Floor With Number of blocks 2 , employee 
--with SSN = 20 as a manager for this Floor,The start date for this manager 
--is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5) 
--moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
--Mohamed(his SSN =12) His position . {3 Points}

insert into floor(Number ,Num_blocks, MG_ID , Hiring_Date)
values(7,2,20,getdate())

update Floor
set MG_ID = 5
where Number =6


update Floor
set MG_ID = 12
where Number =4

/*30.Create view name (v_2006_check) that will display Manager id, Floor 
Number where he/she works , Number of Blocks and the Hiring Date 
which must be from the first of March and the end of May 2022.this view 
will be used to insert data so make sure that the coming new data must 
match the condition then try to insert this 2 rows and*/

create or alter view v_2006_check
as
select e.Id , f.Number , f.Num_blocks , f.Hiring_Date 
from Floor f, Employee e
where e.Id = f.MG_ID and f.Hiring_Date between '3/1/2022' and '5/30/2022' with check option 

select * from v_2006_check
 
insert into v_2006_check (Id , Number , Num_blocks , Hiring_Date )
values (2,6,2,'7-8-2023') 
insert into v_2006_check
values (4,7,1,'4-8-2022')
-- it have identity constraint on id 



--31.Create a trigger to prevent anyone from Modifying or Delete or Insert in 
--the Employee table ( Display a message for user to tell him that he can’t 
--take any action with this Table)
Create or alter Trigger Tr01
on Employee
Instead of Delete , insert , update
as
print 'You can’t take any action with this Table'



--32.Testing Referential Integrity , Mention What Will Happen When:
--A. Add a new User Phone Number with User_SSN = 50 in User_Phones Table {1 Point}
insert into User_phones
values(50 ,'01141534369') 
    --can't insert because there is no user with ssn = 50


--B. Modify the employee id 20 in the employee table to 21 {1 Point}
update employee
set Id =21
where Id =20
     -- 1 row affected but it's not actually updated the effect is on the inserted or deleted column

--C. Delete the employee with id 1 {1 Point}
delete from Employee where id = 1 
    -- (1 row affected) but still exist


--D. Delete the employee with id 12 
delete from Employee where id = 12
    -- (1 row affected) but still exist

--E. Create an index on column (Salary) that allows you to cluster the data in table Employee. {1 Point}
create clustered index index1
ON Employee (Salary)
    --Cannot create more than one clustered index on table

/*33.Try to Create Login With Your Name And give yourself access Only to 
Employee and Floor tables then allow this login to select and insert data 
into tables and deny Delete and update (Don't Forget To take screenshot to every step) {5 Points}*/

create schema b

alter schema b
transfer dbo.Employee

alter schema b
transfer dbo.Floor












































