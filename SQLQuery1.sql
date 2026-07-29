create database Faculty_System_Project;
/*=========================================================
                    Database Setup
=========================================================*/
use Faculty_System_Project;

create table Department (
dept_ID int primary key,
dept_name varchar(120) not null
);


create table Student(
stu_ID int primary key ,
stu_name varchar(120) not null,
stu_age int check (stu_age>=18),
stu_level int check(stu_level between 1 and 4),
dept_ID int not null ,
foreign key(dept_ID) references  Department(dept_ID)
);


create table Doctor(
doc_ID int primary key,
doc_name varchar(120) not null,
doc_age int check(doc_age>25),
doc_title varchar(120) not null,
dept_ID int not null ,
foreign key (dept_ID) references Department(dept_ID)

);

create table Course (
    c_code varchar(20) primary key,
    c_name varchar(120) not null,
    dept_ID int not null,
    foreign key (dept_ID) references Department (dept_ID)
);

create table Enrollment(
stu_ID int not null,
c_code varchar(20) not null,
foreign key (stu_ID) references Student(stu_ID),
foreign key (c_code) references Course(c_code),
primary key (stu_ID,c_code)

);

create table teaching (
doc_ID int not null,
c_code varchar(20) not null,
foreign key (doc_ID) references Doctor(doc_ID),
foreign key (c_code) references Course(c_code),
primary key (doc_ID,c_code)
);

alter table Student 
add stu_grade int ;


create Synonym stu for dbo.Student ;

alter table department
add constraint uq_department_name
unique(dept_name);


/*=========================================================
                     Sample Data
=========================================================*/



INSERT INTO Department 
VALUES(1,'Computer Science'),
      (2,'Information Technology'),
      (3,'Artificial Intelligence'),
      (4,'Software Engineering');


INSERT INTO Student 
VALUES(1,'Hasnaa',20,2,1,100),
      (2,'Habiba',20,2,1,100),
      (3,'Ali',19,1,2,95),
      (4,'Omar',21,3,3,90),
      (5,'Youssef',22,4,4,100),
      (6,'Mariam',19,2,1,50),
      (7,'Nour',20,3,1,70),
      (8,'Salma',21,4,4,80),
      (9,'Ahmed',18,1,3,99),
      (10,'Laila',20,2,2,60);


INSERT INTO Doctor 
VALUES(101,'Dr. Osama',45,'Professor',1),
      (102,'Dr. Mostafa',50,'Professor',2),
      (103,'Dr. Ahmed',42,'Associate Professor',3),
      (104,'Dr. Sara',39,'Lecturer',4),
      (105,'Dr. Mona',41,'Professor',1),
      (106,'Dr. Karim',44,'Lecturer',2),
      (107,'Dr. Hossam',48,'Professor',3),
      (108,'Dr. Eman',37,'Assistant Professor',1);


INSERT INTO Course 
VALUES('CS101','Programming',1),
      ('CS102','Data Structures',1),
      ('IT201','Database',2),
      ('AI301','Machine Learning',3),
      ('IS202','System Analysis',4),
      ('SE401','Software Engineering',4),
      ('CY501','Cyber Security',2),
      ('DS601','Data Mining',1),
      ('NW701','Computer Networks',2),
      ('AI302','Deep Learning',3);


INSERT INTO Enrollment 
VALUES
(1,'CS101'),
(1,'IT201'),
(2,'CS101'),
(2,'CS102'),
(3,'NW701'),
(4,'AI301'),
(4,'AI302'),
(5,'IS202'),
(5,'SE401'),
(6,'SE401'),
(6,'IT201'),
(7,'CY501'),
(8,'DS601'),
(9,'NW701'),
(10,'AI301'),
(10,'CS102');



INSERT INTO Teaching 
VALUES
(101,'CS101'),
(101,'CS102'),
(102,'IT201'),
(103,'AI301'),
(103,'AI302'),
(104,'IS202'),
(105,'SE401'),
(106,'CY501'),
(107,'DS601'),
(108,'NW701');




select * from Department;
select * from stu;
select * from Doctor;
select * from Course;
select * from Enrollment;
select * from Teaching;

/*=========================================================
                     Student Management
=========================================================*/


select * from stu;

declare @name varchar(120)='Hasnaa';
select * 
from stu 
where stu_name =@name;


declare @ID int =5;
select * 
from stu
where stu_ID=@ID;


update stu 
set stu_level = 3 
where stu_ID=1;

declare @stud int =2;
update stu 
set stu_level = 3
where stu_ID=@stud;

select stu_name , stu_level from stu 
order by stu_level;

select stu_level, count(*) 
from stu 
group by (stu_level);

select top(2)  * 
from stu 
order by stu_age desc;

select top(2) with ties stu_name , stu_age 
from Student
order by stu_age desc;

select * , newID() as RandomID
from stu 
order by RandomID;

select top(1)* , newID() as RandomID
from stu 
order by RandomID;

select stu_name , 
case 
    when stu_level =1 then 'Frist'
    when stu_level =2 then 'second'
    when stu_level =3 then 'third'
    when stu_level =4 then 'Fourth'
    end as Student_Levels
    from Student;

    select stu_name , 
    iif(stu_age>=20 ,'Adult','Young') as 'Status'
    from Student;


    select * , ntile(3) over (order by stu_level) 
    from Stu ;



/*=========================================================
                     Student Ranking Report
=========================================================*/

     

    select stu_name , stu_grade ,
    row_number() over(order by stu_grade desc) as Row_number 
    from stu;

    select stu_name , stu_grade ,
    rank() over(order by stu_grade desc) as Rank 
    from stu;

    select dept_name, stu_name , stu_grade ,
    DENSE_RANK() over(partition by stu.dept_ID order by stu_grade desc ) as Dense_Rank 
    from stu join Department 
    on stu.dept_ID = Department.dept_ID;

   
/*=========================================================
                     Department Management
=========================================================*/

 

   -- Report 1: Number of Students in Each Department
   select dept_name, count(*) as num_of_stu_in_dept
   from stu join Department 
   on stu.dept_ID=Department.dept_ID
   group by (dept_name);


   -- Report 2: Number of Doctors in Each Department
   select dept_name , count(*) as num_of_doc_in_dept
   from Doctor D join Department dept 
   on D.dept_ID=dept.dept_ID 
   group by (dept_name);

   -- Report 3: Number of Courses in Each Department
   select dept_name , count(*) as num_of_courses_in_dept
   from Course C join Department dept
   on C.dept_ID = dept.dept_ID 
   group by (dept_name);

   -- Report 4: Departments with More Than X Students
   declare @x int =3 ;
   select dept_name, count(*) as num_of_stu_in_dept
   from stu join Department 
   on stu.dept_ID=Department.dept_ID
   group by (dept_name)
   having count(*)>@x;

   -- Report 5: Total Number of Students
   select count(*) as num_of_stu from stu;


   -- Report 6: Highest Grade in each Department
   select
        d.dept_name,
        s.stu_name,
        s.stu_grade,
        FIRST_VALUE(stu_grade)
        over
        (
            partition by d.dept_ID
            order by  stu_grade desc
        ) as HighestGrade
    from stu s
    join Department d
    on s.dept_ID=d.dept_ID;

    -- Report 7: Average Grade
    select
        d.dept_name,
        avg(stu_grade) as AverageGrade
    from stu s
    join Department d
    on s.dept_ID=d.dept_ID
    group by d.dept_name;

    -- Number of Students per Department with Grand Total (ROLLUP)
   
   select
        d.dept_name,
        count(*) as number_of_students
    from stu s
    join department d
    on s.dept_id = d.dept_id
    group by rollup(d.dept_name);
    
    -- Number of Students by Department and Level (CUBE)
    
    select
        d.dept_name,
        s.stu_level,
        count(*) as total_students
    from stu s
    join department d
    on s.dept_id = d.dept_id
    group by cube(d.dept_name, s.stu_level);
    
    --Custom Department Reports using GROUPING SETS

    select
        d.dept_name,
        s.stu_level,
        count(*) as total_students
    from stu s
    join department d
    on s.dept_id = d.dept_id
    group by grouping sets
    (
        (d.dept_name),
        (s.stu_level),
        ()
    );

/*=========================================================
                     Course Management
=========================================================*/




-- Display All Courses

select 
    c.c_code,
    c.c_name,
    d.dept_name
from Course c join Department d 
on c.dept_ID = d.dept_ID ;

-- Display Students Enrolled in Each Course

select 
    c.c_name,
    s.stu_name
from Enrollment e
join stu s 
on e.stu_ID=s.stu_ID
join Course c 
on c.c_code=e.c_code
order by c.c_name;

-- Display Doctor Teaching Each Course

select 
    c.c_name,
    d.doc_name
from teaching t 
join Doctor d 
on t.doc_ID = d.doc_ID
join Course c 
on c.c_code=t.c_code;


-- Display Courses by Department

select
    dept.dept_name,
    c.c_name
from Course c 
join Department dept 
on c.dept_ID=dept.dept_ID
order by dept.dept_name;



--Student Courses
create view student_view 
as 
    select  s.stu_name,
            c.c_name,
            d.dept_name
    from Enrollment e 
    join stu s
    on e.stu_ID=s.stu_ID 
    join Course c 
    on c.c_code =e.c_code
    join Department d
    on d.dept_ID= c.dept_ID;

SELECT *
FROM student_view;


--Doctor Courses
    create view doctor_view
    as 
        select 
                d.doc_name,
                c.c_name,
                dept.dept_name
        from teaching t
        join Doctor d
        on t.doc_ID=d.doc_ID
        join Course c 
        on c.c_code=t.c_code
        join Department dept
        on dept.dept_ID=c.dept_ID;


select * from doctor_view;


--Department Courses
create view department_view
as 
    select 
        dept.dept_name,
        c.c_name
    from Department dept 
    join Course c 
    on dept.dept_ID=c.dept_ID;


    select * from department_view;


    --DML on views 
    create view s_view 
    as 
        select 
            stu_ID ,
            stu_name ,
            dept_ID 
        from stu ;

    select * from s_view;

    insert into s_view 
    values (11,'Abdallah',1);

    declare @stu_id int =11;
    declare @dept int =2;
    update s_view 
    set dept_ID =@dept
    where stu_ID=@stu_id;


    declare @id int =11;
    delete from s_view 
    where stu_ID =@id;


/*=========================================================
                     Reports & Database Utilities
=========================================================*/

     select
        stu_name,
        cast(stu_grade as float) / 25 as gpa
    from stu;


    select
        stu_name,
        convert(varchar(10), stu_grade) as grade_text
    from stu;


    select
        stu_name,
        format(stu_grade, 'n2') as grade
    from stu;

        alter table student
    add register_date date;

    update student
    set register_date = '2026-07-15';

    select
        stu_name,
        day(register_date) as register_day
    from student;


    select
        stu_name,
        eomonth(register_date) as end_of_month
    from student;

    create table excellent_students
    (
        stu_id int,
        stu_name varchar(120),
        stu_grade int
    );


    insert into excellent_students

    select
        stu_id,
        stu_name,
        stu_grade
    from student
    where stu_grade>=95;

    select * from excellent_students;

    create index idx_name
    on student(stu_name);

    create index idx_grade
    on student(stu_grade);


        -- previous student grade
    select
        stu_name,
        stu_grade,
        lag(stu_grade) over(order by stu_grade desc) as previous_grade
    from stu;


    select
        dept_name,
        stu_name,
        first_value(stu_name)
        over(partition by department.dept_id
        order by stu_grade desc) as top_student
    from stu
    join department
    on department.dept_id=stu.dept_id;


    select
        dept_name,
        stu_name,
        last_value(stu_name)
        over(
        partition by department.dept_id
        order by stu_grade
        rows between unbounded preceding
        and unbounded following
        ) as lowest_student
    from stu
    join department
    on department.dept_id=stu.dept_id;
