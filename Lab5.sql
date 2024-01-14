
--1.	����������� T-SQL-������  ���������� ����������: 
--1.1.	�������� ���������� ����: char, varchar, 
-- datetime, time, int, smallint,  tinint, numeric(12, 5).
DECLARE @L_CHAR char = 'A',
		@L_VARCHAR varchar(6) = 'World',
		@L_DT datetime,
		@L_T time,
		@L_INT INT,
		@L_SMALLINT SMALLINT,
		@L_TINYINT tinyint,
		@L_NUM numeric(12, 5);
--1.2.	������ ��� ���������� ������������������� � ��������� ����������.
--1.3.	���������  ������������ �������� ��������� ���� ���������� � ������� ��������� SET, 
-- ����� ��  ���� ����������  ��������� ��������, ���������� � ���������� ������� SELECT.
	SET @L_DT = GETDATE();
	SET @L_T = (SELECT CONVERT(TIME, GETDATE()));
--1.4.	���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������,
--���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT;
SELECT	@L_INT = (SELECT COUNT(*) FROM ORDERS), 
		@L_TINYINT = (SELECT MAX(AGE) FROM SALESREPS), 
		@L_NUM = (SELECT AVG(PRICE) FROM PRODUCTS);
--1.5.	�������� �������� ���������� ������� � ������� ��������� SELECT, 
-- �������� ������ �������� ���������� ����������� � ������� ��������� PRINT
SELECT @L_CHAR char_var, @L_VARCHAR varchar_var, @L_DT data_var, @L_T time_var;
PRINT CONCAT('���������� �������: ' , @L_INT);
PRINT CONCAT('���������� ��� ��������:' , @L_SMALLINT);
PRINT CONCAT('������������ ������� ����������: ' , @L_TINYINT);
PRINT CONCAT('������� ��������� ��������: ' , @L_NUM);
--6.	������������������ ���������� ��������� CASE.
SELECT DESCRIPTION, PRICE,
	CASE 
		WHEN PRICE > @L_NUM THEN  CONCAT('������� ��������� �������� ������ ��������� �������� ', DESCRIPTION)
		WHEN PRICE < @L_NUM THEN  CONCAT('������� ��������� �������� ������ ��������� �������� ', DESCRIPTION)
	ELSE CONCAT('������� ��������� �������� ����� ��������� �������� ', DESCRIPTION)
	END
FROM PRODUCTS

GO

--2.	����������� ������, � ������� ������������ ������� ��������� ��������. 
-- ���� ������� ��������� �������� ��������� 10, 
-- �� ������� ���������� ���������, 
-- ������� ��������� ��������, 
-- ������������ ��������� ��������. 
-- ���� ������� ��������� �������� ������ 10, �� ������� ����������� ��������� ��������.
DECLARE @AVG_PRODUCT_PRICE DECIMAL(6,2) = (SELECT ROUND(AVG(PRICE), 2) FROM PRODUCTS),
		@COUNT_OF_PRODUCTS INT,
		@MAX_PRODUCT_PRICE DECIMAL(6,2),
		@MIN_PRODUCT_PRICE DECIMAL(6,2);

IF @AVG_PRODUCT_PRICE > 10
	 BEGIN
		SELECT @COUNT_OF_PRODUCTS = (SELECT COUNT(*) FROM PRODUCTS), @MAX_PRODUCT_PRICE = (SELECT MAX(PRICE) FROM PRODUCTS);
		PRINT CONCAT('���������� ��������� = ', @COUNT_OF_PRODUCTS);
		PRINT CONCAT('������� ��������� �������� = ', @AVG_PRODUCT_PRICE);
		PRINT CONCAT('������������ ��������� �������� = ', @MAX_PRODUCT_PRICE);
	 END;
 ELSE IF @AVG_PRODUCT_PRICE < 10
	 BEGIN
		SET @MIN_PRODUCT_PRICE = (SELECT MIN(PRICE) FROM PRODUCTS);
		PRINT CONCAT('����������� ��������� �������� = ', @MIN_PRODUCT_PRICE);
	 END;
GO

--3.	���������� ���������� ������� ���������� � ������������ ������.
DECLARE @START_DATE DATE = (SELECT MIN(ORDER_DATE) FROM ORDERS), @END_DATE DATE = (SELECT MAX(ORDER_DATE) FROM ORDERS);
DECLARE @SALESREP_NAME VARCHAR(15) = 'Larry Fitch';

DECLARE @EMP_NO INT = (SELECT EMPL_NUM FROM SALESREPS WHERE NAME = @SALESREP_NAME);
DECLARE @COUNT_ORDERS INT = 
	(SELECT COUNT(*) 
	FROM ORDERS 
	WHERE ORDER_DATE BETWEEN @START_DATE AND @END_DATE AND REP = @EMP_NO);
PRINT CONCAT('���������� ������� ', @SALESREP_NAME, ', ����������� � ', @START_DATE, ' �� ', @END_DATE, ', ����������: ', @COUNT_ORDERS);
GO

--4.	����������� T-SQL-�������, �����������: 
--4.1.	�������������� ����� ���������� � ��������.
DECLARE @SALESREP_NAME VARCHAR(15) = 'Pashkevich Natalia';
DECLARE @SPACE_POSITION  INT = CHARINDEX(' ', @SALESREP_NAME);;
DECLARE @SURNAME VARCHAR(20) = SUBSTRING(@SALESREP_NAME,0,@SPACE_POSITION);
DECLARE @FIRST_LETTER_NAME CHAR(1) = SUBSTRING(@SALESREP_NAME,@SPACE_POSITION+1,1);
PRINT CONCAT(@SURNAME, ' ', @FIRST_LETTER_NAME, '.');

GO

--4.2.	����� �����������, � ������� ���� ����� � ��������� ������.
DECLARE @START_DATE date = DATEADD(month, -1, (SELECT MIN(HIRE_DATE) FROM SALESREPS));
SELECT * FROM SALESREPS WHERE HIRE_DATE = DATEADD(MONTH,+1,@START_DATE);

GO

--4.3.	����� �����������, ������� ����������� ����� 10 ���.
SELECT * FROM SALESREPS WHERE DATEDIFF(YEAR,HIRE_DATE, GETDATE()) > 10;

GO

--4.4.	����� ��� ������, � ������� �������� ������.
DROP TABLE #TEMP;
SELECT * INTO   #TEMP FROM   ORDERS;
WHILE EXISTS(SELECT * FROM #Temp)
	BEGIN
		DECLARE @DATE_ORDER DATE = (SELECT TOP 1 ORDER_DATE FROM #TEMP), @ID_ORDER INT = (SELECT TOP 1 ORDER_NUM FROM #TEMP);
		PRINT CONCAT('����� � ', @ID_ORDER,' ��� �������� � ', DATENAME(weekday, @DATE_ORDER))
		DELETE #TEMP WHERE ORDER_NUM = (SELECT TOP 1 ORDER_NUM FROM #TEMP);
END

--5.	������������������ ���������� ��������� IF� ELSE.


--7.	������������������ ���������� ��������� RETURN.

-- ��������� � ��������� �����

CREATE PROCEDURE GetAvgPrice AS
DECLARE @avgPrice MONEY
SELECT @avgPrice = AVG(PRICE)
FROM PRODUCTS
RETURN @avgPrice;


--DECLARE @result MONEY
 
--EXEC @result = GetAvgPrice
--PRINT @result

--8.	����������� ������ � ��������, � ������� ������������ ��� ��������� ������ ����� TRY � CATCH. 
-- ��������� ������� ERROR_NUMBER (��� ��������� ������), 
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

--9.	������� ��������� ��������� ������� �� ���� ��������. 
-- �������� ������ (10 �����) � �������������� ��������� WHILE. ������� �� ����������.
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