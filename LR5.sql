--Программирование T-SQL.

--1.	Разработать T-SQL-скрипт  следующего содержания: 
--1.1.	объявить переменные типа: char, varchar, datetime, time, int, smallint,  tinyint, numeric(12, 5).
DECLARE @ch char(2) = 'A',
		@vch varchar(20) = 'Hello';
DECLARE @dt datetime, @t time;
DECLARE @X int,	@X1 smallint, @X2 tinyint;
DECLARE @num numeric(12, 5);

------------------------------------------
--вывести числа от 1 до 20
DECLARE @num1 int = 1;
	while @num1 <=20
BEGIN 
	print @num1;
	set @num1 = @num1 + 1;
END;
-------------------------------------------

--1.2.	первые две переменные проинициализировать в операторе объявления.
--1.3.	присвоить  произвольные значения следующим двум переменным с помощью оператора SET,
--одной из  этих переменных  присвоить значение, полученное в результате запроса SELECT.
set @dt = getdate();
set @t = getdate();
--присвоить значение, полученное в результате запроса SELECT.
set @X = (select count(*) from OFFICES);

--1.4.	одну из переменных оставить без инициализации и не присваивать ей значения, 
--оставшимся переменным присвоить некоторые значения с помощью оператора SELECT;. 
select @X1 = 5, @X2 = 8, @num = 3.1415;

--1.5.	значения половины переменных вывести с помощью оператора SELECT, 
--значения другой половины переменных распечатать с помощью оператора PRINT. 
select @ch ch, @vch vc, @dt dt, @t t;
print concat (@X, ' ', @X1, ' ', @X2, ' ', @num);
GO

--2.	Разработать скрипт, в котором определяется средняя стоимость продукта. 
--Если средняя стоимость продукта превышает 10, то вывести количество продуктов, 
--среднюю стоимость продукта, максимальную стоимость продукта. Если средняя стоимость 
--продукта меньше 10, то вывести минимальную стоимость продукта. 
DECLARE @avg_product_price numeric(6,2) = (select round(avg(PRICE), 2) from PRODUCTS);
DECLARE @product_cnt int;
DECLARE @max_product_price numeric(6,2), @min_product_price numeric(6,2);
if (@avg_product_price > 10)
	begin
		set @product_cnt = (select count(*) from PRODUCTS)
		set @max_product_price = (select max(PRICE) from PRODUCTS)
		print concat ('Количество продуктов = ', @product_cnt);
		print concat ('Средняя цена продукта = ', @avg_product_price);
		print concat ('аксимальная цена продукта = ', @max_product_price);
	end;
else if (@avg_product_price < 10)
	begin
		set @min_product_price = (select min(PRICE) from PRODUCTS);
		print concat ('Минимальная цена продукта = ', @min_product_price)
	end;
GO

--3.	Подсчитать количество заказов сотрудника в определенный период. 
DECLARE @emp_name varchar(15) = 'Dan Roberts';
DECLARE @start_date date = '2007-01-01', @end_date date = '2008-01-01';
DECLARE @emp_no int = (select EMPL_NUM from SALESREPS where NAME = @emp_name);
DECLARE @order_cnt int = (select count(*) from ORDERS
							where ORDER_DATE between @start_date and @end_date and REP = @emp_no);
		print concat ('Количество заказов сотрудника ', @emp_name,
						' в период с ', @start_date, 'по ', @end_date,
						' составляет ', @order_cnt);

--4.	Разработать T-SQL-скрипты, выполняющие: 
--4.1.	преобразование имени сотрудника в инициалы.
DECLARE @emp_name1 varchar(15) = 'Sue Smith';
DECLARE @first_name_letter varchar(1) = left(@emp_name1, 1);
DECLARE @space_position int = charindex(' ', @emp_name1);
DECLARE @first_surname_letter varchar(1) = substring(@emp_name1, @space_position + 1, 1);
print concat(@first_name_letter, '. ', @first_surname_letter, '.');

--4.2.	поиск сотрудников, у которых дата найма в следующем месяце.
DECLARE @emp_name2 varchar(15) = 'Sue Smith';
DECLARE @hiredate_month int = (select month(HIRE_DATE) from SALESREPS
								where name = @emp_name2);
DECLARE @next_month int = month (dateadd(m, 1, getdate()));
if (@hiredate_month = @next_month)
		print concat ('Сотрудник ', @emp_name2, ' принят на работу в следующем месяце: ', @hiredate_month);
	else
		print concat ('Сотрудник ', @emp_name2, ' принят на работу в другом месяце: ', @hiredate_month);
GO

--4.3.	поиск сотрудников, которые проработали более 10 лет.
DECLARE @emp_name3 varchar(15) = 'Sue Smith';
DECLARE @hiredate date = (select HIRE_DATE from SALESREPS where name = @emp_name3);
DECLARE @years_past int = datediff(yy, @hiredate, getdate());
if (@years_past > 10)
		print concat ('Сотрудник ', @emp_name3, ' проработал более 10 лет (', @years_past, ')');
	else
		print concat ('Сотрудник ', @emp_name3, ' проработал менее 10 лет (', @years_past, ')');
GO

--4.4.	поиск дня недели, в который делались заказы.
DECLARE @order_num int = 112961;
DECLARE @order_day varchar(15) = (select DATENAME(weekday, ORDER_DATE) from ORDERS
									where ORDER_NUM = @order_num);
print concat ('Заказ № = ', @order_num, ' был выплнен в ', @order_day);
GO

--5.	Продемонстрировать применение оператора IF… ELSE.
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

--6.	Продемонстрировать применение оператора CASE.
SELECT *,
  CASE
    WHEN SALES>=400000 THEN 'ЗП >= 400000'
    WHEN SALES>=200000 THEN '200000 <= ЗП < 500000'
    ELSE 'ЗП < 200000'
  END SALESCase
FROM SALESREPS

--7.	Продемонстрировать применение оператора RETURN. 
CREATE PROCEDURE GetAvgPrice AS
DECLARE @avgPrice MONEY
SELECT @avgPrice = AVG(PRICE)
FROM PRODUCTS
RETURN @avgPrice;

--8.	Разработать скрипт с ошибками, в котором используются для обработки 
--ошибок блоки TRY и CATCH. -- Применить функции ERROR_NUMBER (код последней ошибки), 
-- ERROR_MESSAGE (сообщение об ошибке), ERROR_LINE(код последней ошибки), 
-- ERROR_PROCEDURE (имя  процедуры или NULL), ERROR_SEVERITY (уровень серьезности ошибки), 
-- ERROR_STATE (метка ошибки). 
DROP TABLE COUNTRY
CREATE TABLE COUNTRY (ID INT NOT NULL, NameCountry VARCHAR(30) NOT NULL)
BEGIN TRY
    INSERT INTO COUNTRY VALUES(NULL, NULL)
    PRINT 'Данные успешно добавлены!'
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

--9.	Создать локальную временную таблицу из трех столбцов. Добавить данные (10 строк) 
--с использованием оператора WHILE. Вывести ее содержимое.
create table #test_EA (x int, y varchar(3), z char(3));

DECLARE @i int = 1;
while (@i <= 10)
	begin	
		insert into #test_EA values (@i, 'tes', 'set');
		set @i = @i + 1;
	end;

select * from #test_EA;
drop table #test_EA;
