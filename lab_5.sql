--���������������� T-SQL.
--1.	����������� T-SQL-������  ���������� ����������: 
--1.1.	�������� ���������� ����: char, varchar, datetime, time, int, smallint,  tinyint, numeric(12, 5).
declare @l_char char(5) = 'Hello', @l_vchar varchar(5) = 'World';
declare @l_dtm datetime, @l_tm time;
declare @l_int int, @l_sint smallint, @l_tint tinyint;
declare @l_num numeric(12, 5);
--1.2.	������ ��� ���������� ������������������� � ��������� ����������.
--1.3.	���������  ������������ �������� ��������� ���� ���������� 
-- � ������� ��������� SET, ����� ��  ���� ����������  
set @l_dtm = getdate();
set @l_tm = getdate();
-- ��������� ��������, ���������� � ���������� ������� SELECT.
set @l_int = (select count(*) from offices);
--1.4.	���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������,
-- ���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT;. 
select @l_sint = 5, @l_tint = 7, @l_num = 3.1415;
--1.5.	�������� �������� ���������� ������� � ������� ��������� SELECT,
-- �������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 
select @l_char l_char, @l_vchar l_vchar, @l_dtm l_dtm, @l_tm l_tm;
print concat (@l_int, ' ', @l_sint, ' ', @l_tint, ' ', @l_num);
go

--2.	����������� ������, � ������� ������������ ������� ��������� ��������. 
-- ���� ������� ��������� �������� ��������� 10, �� ������� ���������� ���������, 
-- ������� ��������� ��������, ������������ ��������� ��������. 
-- ���� ������� ��������� �������� ������ 10, �� ������� ����������� ��������� ��������. 
declare @avg_product_price numeric(6,2) = (select round( avg(price), 2 ) from PRODUCTS);
declare @product_cnt int;
declare @max_product_price numeric(6,2), @min_product_price numeric(6,2);
if (@avg_product_price > 10)
	begin
		set @product_cnt = (select count(*) from PRODUCTS);
		set @max_product_price = (select max(price) from PRODUCTS);
		print concat('���������� ��������� = ', @product_cnt);
		print concat('������� ���� �������� = ', @avg_product_price);
		print concat('������������ ���� �������� = ', @max_product_price);
	end;
 else if (@avg_product_price < 10)
	begin
		set @min_product_price = (select min(price) from PRODUCTS);
		print concat('����������� ���� �������� = ', @min_product_price)
	end;
go

--3.	���������� ���������� ������� ���������� � ������������ ������. 
declare @emp_name varchar(15) = 'Sue Smith';  -- Dan Roberts
declare @start_date date = '2007-01-01', @end_date date = '2008-01-01';
declare @emp_no int = (select EMPL_NUM from SALESREPS where NAME = @emp_name);
declare @order_cnt int = (select count(*) from ORDERS 
				where ORDER_DATE between @start_date and @end_date 
				and REP = @emp_no);
print concat('���������� ������� ���������� ', @emp_name, 
			 ' � ������ � ', @start_date, ' �� ', @end_date,
			 ' ���������� ', @order_cnt);
go

--4.	����������� T-SQL-�������, �����������: 
--4.1.	�������������� ����� ���������� � ��������.
declare @emp_name varchar(15) = 'Dan Roberts';  -- Dan Roberts Sue Smith
declare @first_name_letter varchar(1) = left(@emp_name, 1);
declare @space_position int = charindex(' ', @emp_name);
declare @first_surname_letter varchar(1) = substring(@emp_name, @space_position + 1, 1);
print concat (@first_name_letter, '. ', @first_surname_letter, '.');
go

--4.2.	����� �����������, � ������� ���� ����� � ��������� ������.
declare @emp_name varchar(15) = 'Sue Smith';  -- Dan Roberts Sue Smith
declare @hiredate_month int = (select month(HIRE_DATE) from SALESREPS
								where name = @emp_name);
declare @next_month int = month(dateadd(m, 1, getdate()));
if ( @hiredate_month = @next_month )
	print concat ('��������� ', @emp_name, ' ������ �� ������ � ��������� ������ (', @hiredate_month, ').');
  else
	print concat ('��������� ', @emp_name, ' ������ �� ������ � ������ ������ (', @hiredate_month, ').');
go

--4.3.	����� �����������, ������� ����������� ����� 10 ���.
declare @emp_name varchar(15) = 'Evgenia';  -- Dan Roberts Sue Smith
declare @hiredate date = (select  hire_date from SALESREPS where name = @emp_name);
declare @years_past int = datediff(yy, @hiredate, getdate());
if (@years_past > 10)
	print concat('��������� ', @emp_name, ' ���������� ����� 10 ��� (', @years_past, ')');
  else
	print concat('��������� ', @emp_name, ' ���������� ����� 10 ��� (', @years_past, ')');
go

--4.4.	����� ��� ������, � ������� �������� ������.
declare @order_num int = 112961;
declare @order_day varchar(15) = (select DATENAME(weekday, order_date) from ORDERS
								   where ORDER_NUM = @order_num);
print concat ('����� � = ', @order_num, ' ��� �������� � ', @order_day);
go

--5.	������������������ ���������� ��������� IF� ELSE.
declare @flag int;
if ( @flag is null )
	print 'Variable is null';
 else if ( @flag > 0 )
	print 'Variable is positive';
 else if ( @flag = 0 )
	print 'Variable is zero';
 else print 'Variable is negative';
go

--6.	������������������ ���������� ��������� CASE.
--7.	������������������ ���������� ��������� RETURN. 
--8.	����������� ������ � ��������, � ������� ������������ 
-- ��� ��������� ������ ����� TRY � CATCH. 
-- ��������� ������� ERROR_NUMBER (��� ��������� ������), 
-- ERROR_MESSAGE (��������� �� ������), 
-- ERROR_LINE(��� ��������� ������), 
-- ERROR_PROCEDURE (���  ��������� ��� NULL), 
-- ERROR_SEVERITY (������� ����������� ������), ERROR_ STATE (����� ������). 
--9.	������� ��������� ��������� ������� �� ���� ��������. 
-- �������� ������ (10 �����) � �������������� ��������� WHILE. ������� �� ����������.
create table #test_EA (x int, y varchar(3), z char(3));

declare @i int = 1;
while (@i <= 10)
	begin
		insert into #test_EA values (@i, 'tes', 'set');
		set @i = @i + 1;
	end;

select * from #test_EA;
drop table #test_EA;