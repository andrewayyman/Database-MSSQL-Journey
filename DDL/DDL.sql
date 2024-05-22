create database company

use  company

create table Employees
(
	SSN int Primary key Identity(1,1),
	Fname varchar(50) Not Null,
	Lname varchar(50),
	Gender char(1) Default 'M',
	BirthDate date,
	Address varchar(100) default 'Cairo',
	Dnum int,
	superSNN int references Employees(SSN)
)

create table Department
(
	Dnum int primary key identity(1,1),
	Dname varchar(50) not null,
	MGRSSN int references Employees(SSN),
	HiringDate date
)

create table Departmentlocation
(
	Dnum int references Department(Dnum),
	location varchar(100) default 'ALEXANDRIA',
	Primary Key(Dnum,Location)
)

create Table Projects 
(
	Pnum int primary key identity(100,100),
	Pname varchar(100) not null,
	location varchar(100),
	City varchar(50) default 'Cairo',
	Dnum int references Department(Dnum)
)

create table Depandents 

(
Name varchar (70) unique ,
Birthdate date,
Gender char(1) default'M',
ESSN int references Employees(SSN)
)

create Table EmloyeeProjects 
(
	ESSN int references Employees (SSN),
	Pnum int references projects(Pnum),
	NumOfHours int ,
	primary key (ESSN,Pnum)
)

alter table employees 
add foreign key(Dnum) 
references department(Dnum)

alter table employees 
ADD test int 

alter table employees 
alter column test bigint  

alter table employees 
drop column test 

--drop refere to delete table 

create table test (id int)

drop table test

--drop database refer to delete database 
