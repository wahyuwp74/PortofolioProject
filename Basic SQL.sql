Select * from tblPerson
Select * from tblGender

insert into tblPerson Values (12, 'lams', 'l@l.com',4,27)

Alter table tblPerson
drop constraint DF_tblPerson_GenderID

Alter table tblPerson
ADD constraint DF_tblPerson_GenderID
Default 3 for GenderID



Delete from tblPerson1

DBCC checkident(tblPerson1, reseed,0)

Select * from tblPerson1

Set Identity_insert tblPerson1 OFF 

insert into tblPerson1 Values('May')

Delete From tblPerson1 where PersonID = 6


Create Table Test1
( ID int identity(1,1),
value nvarchar(20))

Create table test2
(ID int identity (1,1), 
Value nvarchar(20))

insert into Test1 Values ('X')

Select * from Test1
select * from test2

Create trigger trforinsert on Test1 for insert
as
begin 
	insert into test2 values('YYYY')
end 

Select SCOPE_IDENTITY()
select @@IDENTITY



select * from tblPerson

delete from tblPerson where ID = 10

alter table tblPerson
add constraint UQ_tblPerson_Email unique(Email)

insert into tblPerson values(12,'ind','k@k.com',1,27)


Select * from tblPerson where age in (20,23,45)

Select * from tblPerson where Email like '%@%'

Select * from tblPerson where (city='London' or city='Mumbai') AND Age >= 25

Select TOP 30 Percent * From tblPerson




Select * From tblEmployee

Select City, Gender, Sum(Salary) as [Total Salary], Count(Name) as [Total Employee]
From tblEmployee 
Group By City,Gender 
having Gender='Male'

Update tblEmployee
Set City='London'
Where ID=10

Select * From tblEmployee
Select * From tblDepartment


Select Name, Gender, Salary, DepartmentName
from tblEmployee
FULL join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.Id


Select * From tblEmp
Select * From tblMan

Select E.Name AS Employee, COALESCE(M.Name,'No Manager')	AS Manager	
from tblEmp AS E
Left join tblEmp AS M
on  E.ManagerID = M.EmployeeID