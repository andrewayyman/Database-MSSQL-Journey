create database musician
use musician

create table musician 
(
	Id int primary key,
	Name varchar(50),
	Ph_Number int ,
	City varchar(25) default 'Mansoura',
	Street varchar (100)
)

create table instrument
(
	Name varchar(50) primary key,
	[Key] char(1)
)

create table Album
(
	Id_Album int primary key,
	Tittle varchar(30),
	Date_album DATE,
	Mus_Id int  references musician(Id)
)

create table song
(
	title varchar(30) primary key,
	Author varchar (50) not null,
)

create table album_song
(
	album_id int references album(Id_Album),
	song_title varchar(30) references song(title)
	primary key(song_title)

)

create table mus_song
(
	mus_id int references musician(id),
	song_tittle varchar(30) references song(title)
	primary key(mus_id,song_tittle)
)

create table mus_instrument
(
	mus_id int references musician(id),
	inst_name varchar(50) references instrument(Name)
)