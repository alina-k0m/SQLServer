--���������������� T-SQL.

--1.	����������� T-SQL-������  ���������� ����������: 
--1.1.	�������� ���������� ����: char, varchar, datetime, time, int, smallint,  tinyint, numeric(12, 5).
DECLARE @ch char(2) = 'A',
		@vch varchar(20) = 'Hello';
DECLARE @dt datetime, @t time;
DECLARE @X int,	@X1 smallint, @X2 tinyint;
DECLARE @num numeric(12, 5);

------------------------------------------
--������� ����� �� 1 �� 20
DECLARE @num1 int = 1;
	while @num1 <=20
BEGIN 
	print @num1;
	set @num1 = @num1 + 1;
END;
-------------------------------------------

--1.2.	������ ��� ���������� ������������������� � ��������� ����������.
--1.3.	���������  ������������ �������� ��������� ���� ���������� � ������� ��������� SET,
--����� ��  ���� ����������  ��������� ��������, ���������� � ���������� ������� SELECT.
set @dt = getdate();
set @t = getdate();
--��������� ��������, ���������� � ���������� ������� SELECT.
set @X = (select count(*) from OFFICES);

--1.4.	���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������, 
--���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT;. 
select @X1 = 5, @X2 = 8, @num = 3.1415;

--1.5.	�������� �������� ���������� ������� � ������� ��������� SELECT, 
--�������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 
select @ch ch, @vch vc, @dt dt, @t t;
print concat (@X, ' ', @X1, ' ', @X2, ' ', @num);
GO

--2.	����������� ������, � ������� ������������ ������� ��������� ��������. 
--���� ������� ��������� �������� ��������� 10, �� ������� ���������� ���������, 
--������� ��������� ��������, ������������ ��������� ��������. ���� ������� ��������� 
--�������� ������ 10, �� ������� ����������� ��������� ��������. 
DECLARE @avg_product_price numeric(6,2) = (select round(avg(PRICE), 2) from PRODUCTS);
DECLARE @product_cnt int;
DECLARE @max_product_price numeric(6,2), @min_product_price numeric(6,2);
if (@avg_product_price > 10)
	begin
		set @product_cnt = (select count(*) from PRODUCTS)
		set @max_product_price = (select max(PRICE) from PRODUCTS)
		print concat ('���������� ��������� = ', @product_cnt);
		print concat ('������� ���� �������� = ', @avg_product_price);
		print concat ('����������� ���� �������� = ', @max_product_price);
	end;
else if (@avg_product_price < 10)
	begin
		set @min_product_price = (select min(PRICE) from PRODUCTS);
		print concat ('����������� ���� �������� = ', @min_product_price)
	end;
GO

--3.	���������� ���������� ������� ���������� � ������������ ������. 
DECLARE @emp_name varchar(15) = 'Dan Roberts';
DECLARE @start_date date = '2007-01-01', @end_date date = '2008-01-01';
DECLARE @emp_no int = (select EMPL_NUM from SALESREPS where NAME = @emp_name);
DECLARE @order_cnt int = (select count(*) from ORDERS
							where ORDER_DATE between @start_date and @end_date and REP = @emp_no);
		print concat ('���������� ������� ���������� ', @emp_name,
						' � ������ � ', @start_date, '�� ', @end_date,
						' ���������� ', @order_cnt);

--4.	����������� T-SQL-�������, �����������: 
--4.1.	�������������� ����� ���������� � ��������.
DECLARE @emp_name1 varchar(15) = 'Sue Smith';
DECLARE @first_name_letter varchar(1) = left(@emp_name1, 1);
DECLARE @space_position int = charindex(' ', @emp_name1);
DECLARE @first_surname_letter varchar(1) = substring(@emp_name1, @space_position + 1, 1);
print concat(@first_name_letter, '. ', @first_surname_letter, '.');

--4.2.	����� �����������, � ������� ���� ����� � ��������� ������.
DECLARE @emp_name2 varchar(15) = 'Sue Smith';
DECLARE @hiredate_month int = (select month(HIRE_DATE) from SALESREPS
								where name = @emp_name2);
DECLARE @next_month int = month (dateadd(m, 1, getdate()));
if (@hiredate_month = @next_month)
		print concat ('��������� ', @emp_name2, ' ������ �� ������ � ��������� ������: ', @hiredate_month);
	else
		print concat ('��������� ', @emp_name2, ' ������ �� ������ � ������ ������: ', @hiredate_month);
GO

--4.3.	����� �����������, ������� ����������� ����� 10 ���.
DECLARE @emp_name3 varchar(15) = 'Sue Smith';
DECLARE @hiredate date = (select HIRE_DATE from SALESREPS where name = @emp_name3);
DECLARE @years_past int = datediff(yy, @hiredate, getdate());
if (@years_past > 10)
		print concat ('��������� ', @emp_name3, ' ���������� ����� 10 ��� (', @years_past, ')');
	else
		print concat ('��������� ', @emp_name3, ' ���������� ����� 10 ��� (', @years_past, ')');
GO

--4.4.	����� ��� ������, � ������� �������� ������.
DECLARE @order_num int = 112961;
DECLARE @order_day varchar(15) = (select DATENAME(weekday, ORDER_DATE) from ORDERS
									where ORDER_NUM = @order_num);
print concat ('����� � = ', @order_num, ' ��� ������� � ', @order_day);
GO

--5.	������������������ ���������� ��������� IF� ELSE.
DECLARE @flag int;
if (@flag is null)
	print 'Variable is null';
else if (@flag > 0)
	print 'Variable is positive';
else if (@flag = 0)
	print 'Variable is zero';
else
	print 'Variable is negative';
GO

--6.	������������������ ���������� ��������� CASE.
SELECT *,
  CASE
    WHEN SALES>=400000 THEN '�� >= 400000'
    WHEN SALES>=200000 THEN '200000 <= �� < 500000'
    ELSE '�� < 200000'
  END SALESCase
FROM SALESREPS

--7.	������������������ ���������� ��������� RETURN. 
CREATE PROCEDURE GetAvgPrice AS
DECLARE @avgPrice MONEY
SELECT @avgPrice = AVG(PRICE)
FROM PRODUCTS
RETURN @avgPrice;

--8.	����������� ������ � ��������, � ������� ������������ ��� ��������� 
--������ ����� TRY � CATCH. -- ��������� ������� ERROR_NUMBER (��� ��������� ������), 
-- ERROR_MESSAGE (��������� �� ������), ERROR_LINE(��� ��������� ������), 
-- ERROR_PROCEDURE (���  ��������� ��� NULL), ERROR_SEVERITY (������� ����������� ������), 
-- ERROR_STATE (����� ������). 
DROP TABLE COUNTRY
CREATE TABLE COUNTRY (ID INT NOT NULL, NameCountry VARCHAR(30) NOT NULL)
BEGIN TRY
    INSERT INTO COUNTRY VALUES(NULL, NULL)
    PRINT '������ ������� ���������!'
END TRY
BEGIN CATCH
    SELECT  
     ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH

--9.	������� ��������� ��������� ������� �� ���� ��������. �������� ������ (10 �����) 
--� �������������� ��������� WHILE. ������� �� ����������.
create table #test_EA (x int, y varchar(3), z char(3));

DECLARE @i int = 1;
while (@i <= 10)
	begin	
		insert into #test_EA values (@i, 'tes', 'set');
		set @i = @i + 1;
	end;

select * from #test_EA;
drop table #test_EA;
