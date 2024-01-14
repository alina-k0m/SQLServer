-- procedure function
--drop procedure print_myself;
--drop procedure print_my_name;
--drop procedure print_my_name_2;
--drop procedure print_my_name_3;
--go

create procedure print_myself
as
begin
	print 'print_myself';
end;
go

exec print_myself;
go


create procedure print_my_name @v_name varchar(10)
as
begin
	print 'Hello, ' + @v_name;
end;
go

declare @lname varchar(12) = 'JoeJoeJoeJoe';
exec print_my_name @lname;
go

create procedure print_my_name_2 @v_name varchar(10)
as
declare @rc int = 0;
begin
	print 'Hello, ' + @v_name;
	set @rc = 15;
	return @rc;
end;
go

declare @lname varchar(5) = 'Joe',
		@result int = 0;
exec @result = print_my_name_2 @lname;
print @result;
go

create procedure print_my_name_3 @v_name varchar(10), @name_length int output
as
declare @rc int = 0;
begin
	print 'Hello, ' + @v_name;
	set @rc = 15;
	set @name_length = len(@v_name);
	return @rc;
end;
go


declare @lname varchar(5) = 'Alice',
		@nl int = 0,
		@result int = 0;
exec @result = print_my_name_3 @lname, @nl output;
print 'Name length = ' + cast(@nl as varchar(5));
print @result;
go









