
--1.	Разработать T-SQL-скрипт  следующего содержания: 
--1.1.	объявить переменные типа: char, varchar, 
-- datetime, time, int, smallint,  tinint, numeric(12, 5).
DECLARE @L_CHAR char = 'A',
		@L_VARCHAR varchar(6) = 'World',
		@L_DT datetime,
		@L_T time,
		@L_INT INT,
		@L_SMALLINT SMALLINT,
		@L_TINYINT tinyint,
		@L_NUM numeric(12, 5);
--1.2.	первые две переменные проинициализировать в операторе объявления.
--1.3.	присвоить  произвольные значения следующим двум переменным с помощью оператора SET, 
-- одной из  этих переменных  присвоить значение, полученное в результате запроса SELECT.
	SET @L_DT = GETDATE();
	SET @L_T = (SELECT CONVERT(TIME, GETDATE()));
--1.4.	одну из переменных оставить без инициализации и не присваивать ей значения,
--оставшимся переменным присвоить некоторые значения с помощью оператора SELECT;
SELECT	@L_INT = (SELECT COUNT(*) FROM ORDERS), 
		@L_TINYINT = (SELECT MAX(AGE) FROM SALESREPS), 
		@L_NUM = (SELECT AVG(PRICE) FROM PRODUCTS);
--1.5.	значения половины переменных вывести с помощью оператора SELECT, 
-- значения другой половины переменных распечатать с помощью оператора PRINT
SELECT @L_CHAR char_var, @L_VARCHAR varchar_var, @L_DT data_var, @L_T time_var;
PRINT CONCAT('Количество заказов: ' , @L_INT);
PRINT CONCAT('Переменная без значения:' , @L_SMALLINT);
PRINT CONCAT('Максимальный возраст сотрудника: ' , @L_TINYINT);
PRINT CONCAT('Средняя стоимость продукта: ' , @L_NUM);
--6.	Продемонстрировать применение оператора CASE.
SELECT DESCRIPTION, PRICE,
	CASE 
		WHEN PRICE > @L_NUM THEN  CONCAT('Средняя стоимость продукта меньше стоимости продукта ', DESCRIPTION)
		WHEN PRICE < @L_NUM THEN  CONCAT('Средняя стоимость продукта больше стоимости продукта ', DESCRIPTION)
	ELSE CONCAT('Средняя стоимость продукта равна стоимости продукта ', DESCRIPTION)
	END
FROM PRODUCTS

GO

--2.	Разработать скрипт, в котором определяется средняя стоимость продукта. 
-- Если средняя стоимость продукта превышает 10, 
-- то вывести количество продуктов, 
-- среднюю стоимость продукта, 
-- максимальную стоимость продукта. 
-- Если средняя стоимость продукта меньше 10, то вывести минимальную стоимость продукта.
DECLARE @AVG_PRODUCT_PRICE DECIMAL(6,2) = (SELECT ROUND(AVG(PRICE), 2) FROM PRODUCTS),
		@COUNT_OF_PRODUCTS INT,
		@MAX_PRODUCT_PRICE DECIMAL(6,2),
		@MIN_PRODUCT_PRICE DECIMAL(6,2);

IF @AVG_PRODUCT_PRICE > 10
	 BEGIN
		SELECT @COUNT_OF_PRODUCTS = (SELECT COUNT(*) FROM PRODUCTS), @MAX_PRODUCT_PRICE = (SELECT MAX(PRICE) FROM PRODUCTS);
		PRINT CONCAT('Количество продуктов = ', @COUNT_OF_PRODUCTS);
		PRINT CONCAT('Средняя стоимость продукта = ', @AVG_PRODUCT_PRICE);
		PRINT CONCAT('Максимальная стоимость продукта = ', @MAX_PRODUCT_PRICE);
	 END;
 ELSE IF @AVG_PRODUCT_PRICE < 10
	 BEGIN
		SET @MIN_PRODUCT_PRICE = (SELECT MIN(PRICE) FROM PRODUCTS);
		PRINT CONCAT('Минимальная стоимость продукта = ', @MIN_PRODUCT_PRICE);
	 END;
GO

--3.	Подсчитать количество заказов сотрудника в определенный период.
DECLARE @START_DATE DATE = (SELECT MIN(ORDER_DATE) FROM ORDERS), @END_DATE DATE = (SELECT MAX(ORDER_DATE) FROM ORDERS);
DECLARE @SALESREP_NAME VARCHAR(15) = 'Larry Fitch';

DECLARE @EMP_NO INT = (SELECT EMPL_NUM FROM SALESREPS WHERE NAME = @SALESREP_NAME);
DECLARE @COUNT_ORDERS INT = 
	(SELECT COUNT(*) 
	FROM ORDERS 
	WHERE ORDER_DATE BETWEEN @START_DATE AND @END_DATE AND REP = @EMP_NO);
PRINT CONCAT('Количество заказов ', @SALESREP_NAME, ', выполненных с ', @START_DATE, ' по ', @END_DATE, ', составляет: ', @COUNT_ORDERS);
GO

--4.	Разработать T-SQL-скрипты, выполняющие: 
--4.1.	преобразование имени сотрудника в инициалы.
DECLARE @SALESREP_NAME VARCHAR(15) = 'Pashkevich Natalia';
DECLARE @SPACE_POSITION  INT = CHARINDEX(' ', @SALESREP_NAME);;
DECLARE @SURNAME VARCHAR(20) = SUBSTRING(@SALESREP_NAME,0,@SPACE_POSITION);
DECLARE @FIRST_LETTER_NAME CHAR(1) = SUBSTRING(@SALESREP_NAME,@SPACE_POSITION+1,1);
PRINT CONCAT(@SURNAME, ' ', @FIRST_LETTER_NAME, '.');

GO

--4.2.	поиск сотрудников, у которых дата найма в следующем месяце.
DECLARE @START_DATE date = DATEADD(month, -1, (SELECT MIN(HIRE_DATE) FROM SALESREPS));
SELECT * FROM SALESREPS WHERE HIRE_DATE = DATEADD(MONTH,+1,@START_DATE);

GO

--4.3.	поиск сотрудников, которые проработали более 10 лет.
SELECT * FROM SALESREPS WHERE DATEDIFF(YEAR,HIRE_DATE, GETDATE()) > 10;

GO

--4.4.	поиск дня недели, в который делались заказы.
DROP TABLE #TEMP;
SELECT * INTO   #TEMP FROM   ORDERS;
WHILE EXISTS(SELECT * FROM #Temp)
	BEGIN
		DECLARE @DATE_ORDER DATE = (SELECT TOP 1 ORDER_DATE FROM #TEMP), @ID_ORDER INT = (SELECT TOP 1 ORDER_NUM FROM #TEMP);
		PRINT CONCAT('Заказ № ', @ID_ORDER,' был выполнен в ', DATENAME(weekday, @DATE_ORDER))
		DELETE #TEMP WHERE ORDER_NUM = (SELECT TOP 1 ORDER_NUM FROM #TEMP);
END

--5.	Продемонстрировать применение оператора IF… ELSE.


--7.	Продемонстрировать применение оператора RETURN.

-- Запускать в отдельном файле

CREATE PROCEDURE GetAvgPrice AS
DECLARE @avgPrice MONEY
SELECT @avgPrice = AVG(PRICE)
FROM PRODUCTS
RETURN @avgPrice;


--DECLARE @result MONEY
 
--EXEC @result = GetAvgPrice
--PRINT @result

--8.	Разработать скрипт с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH. 
-- Применить функции ERROR_NUMBER (код последней ошибки), 
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

--9.	Создать локальную временную таблицу из трех столбцов. 
-- Добавить данные (10 строк) с использованием оператора WHILE. Вывести ее содержимое.
--DROP TABLE #TempTable
CREATE TABLE #TempTable (
    ID INT PRIMARY KEY,
    Date DATE,
    Rnd INT
);

DECLARE @INCREMENT INT = 0

WHILE @INCREMENT < 10
    BEGIN
        INSERT INTO #TempTable VALUES(@INCREMENT, GETDATE(), (SELECT RAND()*(100) Random_Number))
        SET @INCREMENT = @INCREMENT + 1
    END;
 
SELECT * FROM #TempTable