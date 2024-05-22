create database My_ITI
use MY_ITI

create table Students 
(
	Id int primary key identity(1,1),
	Fname varchar(50) not null,
	Lname varchar (50),
	Age int,
	[Address] varchar(100) default 'Alex',
	Dep_id int  -- will be referenced later
)

create table Departments 
(
	Id int primary key,
	[Name] varchar(50) not null,
	HiringDate date,
	Ins_Id int -- will be referenced later
)

-- add ref in students
alter table Students 
add foreign key (Dep_id) 
references departments(Id)   

create table Instructors
(
	Id int primary key Identity(1,1),
	[Name] varchar(50),
	[Address] varchar(100) default 'Alex',
	Bouns int,
	Salary int default'2000',
	HourRate time,
	Dep_Id int references Departments(Id)
)

-- add ref in Departments
alter table Departments 
add foreign key (Ins_Id) 
references instructors(Id) 

create table Topics 
(
	Id int primary key identity(1,1),
	[Name] varchar(50)
)

create table Courses 
(
	Id int primary key identity(1,1),
	[Name] varchar(50) not null,
	[Address] varchar(100) default'Alex',
	Duration time,
	[Description] varchar(100),
	TopID int references Topics(Id)
)



create table Stud_Course
(
	Grade float,
	Stud_Id int references Students(Id),
	Course_Id int references Courses(Id),
	primary key (Stud_Id,Course_Id)  -- composite prim key
)

create table Course_Instructor 
(
	Evaluation varchar(50),
	Course_Id int references Courses(Id),
	Ins_Id int references Instructors(Id),
	primary key(Course_Id,Ins_Id)

)


