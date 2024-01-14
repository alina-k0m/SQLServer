--Программирование T-SQL.
--1.	Разработать T-SQL-скрипт  следующего содержания: 
--1.1.	объявить переменные типа: char, varchar, datetime, time, int, smallint,  tinyint, numeric(12, 5).
declare @l_char char(5) = 'Hello', @l_vchar varchar(5) = 'World';
declare @l_dtm datetime, @l_tm time;
declare @l_int int, @l_sint smallint, @l_tint tinyint;
declare @l_num numeric(12, 5);
--1.2.	первые две переменные проинициализировать в операторе объявления.
--1.3.	присвоить  произвольные значения следующим двум переменным 
-- с помощью оператора SET, одной из  этих переменных  
set @l_dtm = getdate();
set @l_tm = getdate();
-- присвоить значение, полученное в результате запроса SELECT.
set @l_int = (select count(*) from offices);
--1.4.	одну из переменных оставить без инициализации и не присваивать ей значения,
-- оставшимся переменным присвоить некоторые значения с помощью оператора SELECT;. 
select @l_sint = 5, @l_tint = 7, @l_num = 3.1415;
--1.5.	значения половины переменных вывести с помощью оператора SELECT,
-- значения другой половины переменных распечатать с помощью оператора PRINT. 
select @l_char l_char, @l_vchar l_vchar, @l_dtm l_dtm, @l_tm l_tm;
print concat (@l_int, ' ', @l_sint, ' ', @l_tint, ' ', @l_num);
go

--2.	Разработать скрипт, в котором определяется средняя стоимость продукта. 
-- Если средняя стоимость продукта превышает 10, то вывести количество продуктов, 
-- среднюю стоимость продукта, максимальную стоимость продукта. 
-- Если средняя стоимость продукта меньше 10, то вывести минимальную стоимость продукта. 
declare @avg_product_price numeric(6,2) = (select round( avg(price), 2 ) from PRODUCTS);
declare @product_cnt int;
declare @max_product_price numeric(6,2), @min_product_price numeric(6,2);
if (@avg_product_price > 10)
	begin
		set @product_cnt = (select count(*) from PRODUCTS);
		set @max_product_price = (select max(price) from PRODUCTS);
		print concat('Количество продуктов = ', @product_cnt);
		print concat('Средняя цена продукта = ', @avg_product_price);
		print concat('Максимальная цена продукта = ', @max_product_price);
	end;
 else if (@avg_product_price < 10)
	begin
		set @min_product_price = (select min(price) from PRODUCTS);
		print concat('Минимальная цена продукта = ', @min_product_price)
	end;
go

--3.	Подсчитать количество заказов сотрудника в определенный период. 
declare @emp_name varchar(15) = 'Sue Smith';  -- Dan Roberts
declare @start_date date = '2007-01-01', @end_date date = '2008-01-01';
declare @emp_no int = (select EMPL_NUM from SALESREPS where NAME = @emp_name);
declare @order_cnt int = (select count(*) from ORDERS 
				where ORDER_DATE between @start_date and @end_date 
				and REP = @emp_no);
print concat('Количество заказов сотрудника ', @emp_name, 
			 ' в период с ', @start_date, ' по ', @end_date,
			 ' составляет ', @order_cnt);
go

--4.	Разработать T-SQL-скрипты, выполняющие: 
--4.1.	преобразование имени сотрудника в инициалы.
declare @emp_name varchar(15) = 'Dan Roberts';  -- Dan Roberts Sue Smith
declare @first_name_letter varchar(1) = left(@emp_name, 1);
declare @space_position int = charindex(' ', @emp_name);
declare @first_surname_letter varchar(1) = substring(@emp_name, @space_position + 1, 1);
print concat (@first_name_letter, '. ', @first_surname_letter, '.');
go

--4.2.	поиск сотрудников, у которых дата найма в следующем месяце.
declare @emp_name varchar(15) = 'Sue Smith';  -- Dan Roberts Sue Smith
declare @hiredate_month int = (select month(HIRE_DATE) from SALESREPS
								where name = @emp_name);
declare @next_month int = month(dateadd(m, 1, getdate()));
if ( @hiredate_month = @next_month )
	print concat ('Сотрудник ', @emp_name, ' принят на работу в следующем месяце (', @hiredate_month, ').');
  else
	print concat ('Сотрудник ', @emp_name, ' принят на работу в другом месяце (', @hiredate_month, ').');
go

--4.3.	поиск сотрудников, которые проработали более 10 лет.
declare @emp_name varchar(15) = 'Evgenia';  -- Dan Roberts Sue Smith
declare @hiredate date = (select  hire_date from SALESREPS where name = @emp_name);
declare @years_past int = datediff(yy, @hiredate, getdate());
if (@years_past > 10)
	print concat('Сотрудник ', @emp_name, ' проработал более 10 лет (', @years_past, ')');
  else
	print concat('Сотрудник ', @emp_name, ' проработал менее 10 лет (', @years_past, ')');
go

--4.4.	поиск дня недели, в который делались заказы.
declare @order_num int = 112961;
declare @order_day varchar(15) = (select DATENAME(weekday, order_date) from ORDERS
								   where ORDER_NUM = @order_num);
print concat ('Заказ № = ', @order_num, ' был выполнен в ', @order_day);
go

--5.	Продемонстрировать применение оператора IF… ELSE.
declare @flag int;
if ( @flag is null )
	print 'Variable is null';
 else if ( @flag > 0 )
	print 'Variable is positive';
 else if ( @flag = 0 )
	print 'Variable is zero';
 else print 'Variable is negative';
go

--6.	Продемонстрировать применение оператора CASE.
--7.	Продемонстрировать применение оператора RETURN. 
--8.	Разработать скрипт с ошибками, в котором используются 
-- для обработки ошибок блоки TRY и CATCH. 
-- Применить функции ERROR_NUMBER (код последней ошибки), 
-- ERROR_MESSAGE (сообщение об ошибке), 
-- ERROR_LINE(код последней ошибки), 
-- ERROR_PROCEDURE (имя  процедуры или NULL), 
-- ERROR_SEVERITY (уровень серьезности ошибки), ERROR_ STATE (метка ошибки). 
--9.	Создать локальную временную таблицу из трех столбцов. 
-- Добавить данные (10 строк) с использованием оператора WHILE. Вывести ее содержимое.
create table #test_EA (x int, y varchar(3), z char(3));

declare @i int = 1;
while (@i <= 10)
	begin
		insert into #test_EA values (@i, 'tes', 'set');
		set @i = @i + 1;
	end;

select * from #test_EA;
drop table #test_EA;