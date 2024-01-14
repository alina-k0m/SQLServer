----------------------- Batch --- �����----------------------------------
----------------------- ����� 1 -----------------------------------------
USE tempdb;
GO
----------------------- ����� 2 -----------------------------------------
CREATE TABLE #test_table (id int identity (2,2));
GO
----------------------- ����� 3 -----------------------------------------
INSERT INTO #test_table DEFAULT VALUES;
GO 3 -- ������
----------------------- ����� 4 -----------------------------------------
SELECT * FROM #test_table;
GO
----------------------- ����� 5 -----------------------------------------
DROP TABLE #test_table;
GO
----------------------- DECLARE -----------------------------------------
DECLARE @X int = 1,
  @Y decimal (5,3),
  @Z float (4) = 4.3E-2;
DECLARE @ch char(2),
  @text_en varchar(20) = 'Hello',
  @text_ru nvarchar(20) = '������';
DECLARE @d1 date = '10/10/2019',
  @d2 datetime = getdate(), --��������� ���� � �������
  @d3 time = getdate();
DECLARE @t1 table(x int identity (1,1), y varchar(3) default 'yyy' );
INSERT @t1 default values;
DECLARE @u1 uniqueidentifier = newid();
----------------------- SELECT --------------------------------------
SELECT @X, @Y, @Z;
SELECT @ch, @text_en, @text_ru;
SELECT @d1, @d2, @d3;
SELECT * FROM @t1;
SELECT @u1;
GO
-------------------- ������ - �� ����� ���������� -------------------
SELECT @X, @Y, @Z;
SELECT @ch, @text_en, @text_ru;
SELECT @d1, @d2, @d3;
SELECT * FROM @t1;
SELECT @u1;
GO
-------------------- ��������� ������������ -------------------------
-------------------- DECLARE -------------------------
DECLARE @X int = 1;
  
DECLARE @ch char(2);
-------------------- SET -----------------------------
SET @ch = 'TT';  
DECLARE @d1 date ;
----------------------- SELECT -----------------------
SELECT @d1 = '10/10/2019';
SELECT @X X, @ch ch, @d1 d1;
PRINT @X;
PRINT @ch;
PRINT @d1;
GO
-------------------- �������� PRINT -------------------------
DECLARE @X int = 1;
DECLARE @ch char(2) = 'TT';  
DECLARE @d1 date = '10/10/2019';
PRINT cast(@X as varchar(3)) + ' ' + @ch+ ' ' + cast(@d1 as varchar(10));
GO
-------------------- ������� CAST -------------------------
SELECT 1/24 as S1,
    cast(1/24 as numeric(5,3)) as S2,
    cast(1 as numeric(5,3))/cast(24 as numeric(5,3)) as S3;
GO
-----------------------------------------------------------
DECLARE @prod_sum numeric(8,3) = (SELECT CAST(SUM(PRICE) as numeric(8,3)) FROM PRODUCTS);
DECLARE @prod_count numeric(8,3);
DECLARE @prod_avg_price numeric(8,3);
DECLARE @prod_avg_price_lo_100 numeric(8,3);
SELECT @prod_count = CAST((SELECT COUNT(PRICE) FROM PRODUCTS) as numeric(8,3)),
    @prod_avg_price = (SELECT CAST(AVG(PRICE) as numeric(8,3)) FROM PRODUCTS),
    @prod_avg_price_lo_100 =(SELECT CAST(AVG(PRICE) as numeric(8,3)) FROM PRODUCTS
          WHERE PRICE < @prod_avg_price);
SELECT  @prod_sum 'prod_sum',
  @prod_count 'prod_count',
     @prod_avg_price 'prod_avg_price',
     @prod_avg_price_lo_100 'prod_avg_price_lo_100';
GO
---------------------------------------------------------
DECLARE @prod_sum numeric(8,3) = (SELECT CAST(SUM(PRICE) as numeric(8,3)) FROM PRODUCTS);
DECLARE @prod_count numeric(8,3);
DECLARE @prod_avg_price numeric(8,3);
DECLARE @prod_avg_price_lo_100 numeric(8,3);
SELECT @prod_count = CAST((SELECT COUNT(PRICE) FROM PRODUCTS) as numeric(8,3)),
    @prod_avg_price = (SELECT CAST(AVG(PRICE) as numeric(8,3)) FROM PRODUCTS);
SET @prod_avg_price_lo_100 =(SELECT CAST(AVG(PRICE) as numeric(8,3)) FROM PRODUCTS
          WHERE PRICE < @prod_avg_price);
SELECT  @prod_sum 'prod_sum',
  @prod_count 'prod_count',
     @prod_avg_price 'prod_avg_price',
     @prod_avg_price_lo_100 'prod_avg_price_lo_100';
GO
-------------------- �������������� �������� -------------------------
DECLARE @x int, @x1 int = 1, @x2 int = 4, @x3 int;
DECLARE @y int, @y1 int = 3, @y2 int = 5;
DECLARE @z numeric (6,2), @z1 numeric (6,2) = 3.72, @z2 numeric (6,2) = 5.22;
DECLARE @p float (6), @p1 float (6) = 3.72, @p2 float (6) = 5.22;
SET @x = @x1 + @x2;
SET @y = @y2 - @y1;
SET @z = @z1 * @z2;
SET @p = @p2 / @p1;
SET @x3 = @y1 % @y2;
SELECT @X 'X', @Y 'Y', @Z 'Z', @P 'P', @x3 'X3';
SET @x+=2;
SET @y-=1;
SET @z*=2;
SET @p/= 3;
SET @x3%= 2;
SELECT @X 'X', @Y 'Y', @Z 'Z', @P 'P', @x3 'X3';
GO
----------- �������������� �������� - �������� ---------------------
DECLARE @x int = 15;
DECLARE @y numeric (6,2) = 153.72;
DECLARE @z numeric (6,1) = 13353.7;
DECLARE @p float (6) = 3.72E-3;
SELECT @x+@y 'X+Y', @y+@z 'Y+Z', @Z+@p 'Z+P';
SELECT  cast((@x+@y) as int) 'X+Y',
  cast((@y+@z) as numeric (6,1)) 'Y+Z',
  cast((@Z+@p) as varchar(10)) 'Z+P';
GO
----------- ���������� ������� - ����� ---------------------
-- LEN() ���������� ���������� �������� � ������
-- � �������� ��������� � ������� ���������� ������, ��� ������� ���� ����� �����
SELECT CITY, LEN(CITY) Name_Legth FROM OFFICES;
-- LTRIM() ������� ��������� ������� �� ������
-- RTRIM() ������� �������� ������� �� ������
-- � �������� ��������� ��������� ������
SELECT LTRIM('  CITY') Left_Trim, RTRIM(' CITY    ') Right_Trim;
-- CHARINDEX() ���������� ������, �� �������� ��������� ������ ��������� ��������� � ������
-- � �������� ������� ��������� ���������� ��������� ������,
-- � �������� ������� ��������� - ������, � ������� ���� ����� �����
SELECT CITY, CHARINDEX('an', CITY) Str_Pos FROM OFFICES;
-- PATINDEX() ���������� ������, �� �������� ���������
-- ������ ��������� ������������� ������� � ������
SELECT CITY, PATINDEX('%a%n%', CITY) Str_Pos FROM OFFICES;
-- LEFT() � RIGHT() �������� � ������ ������ ������������ ���������� ��������
-- ������ �������� ������� - ������
-- ������ - ���������� ��������, ������� ���� ��������
SELECT LEFT(CITY, 3) l3, RIGHT(CITY, 3) r3 FROM OFFICES;
-- SUBSTRING() �������� �� ������ ��������� ������������ �����
-- ������� � ������������� �������
-- ������ �������� ������� - ������
-- ������ - ��������� ������
-- ������ - ���������� ���������� ��������
SELECT SUBSTRING(CITY, 1, 4) l4, SUBSTRING(CITY, 4, 4) r4 FROM OFFICES;
-- REPLACE() �������� ���� ��������� ������
-- ������ �������� ������� - ������
-- ������ - ���������, ������� ���� ��������
-- ������ - ���������, �� ������� ���� ��������
SELECT REPLACE(CITY, 'o', '0') FROM OFFICES;
-- REVERSE() �������������� ������ ��������
SELECT REVERSE(CITY)  FROM OFFICES;
-- CONCAT() ���������� ��� ������ � ����
-- SPACE() ���������� ������, ������� ��������
-- ������������ ���������� ��������
SELECT CONCAT(CITY, SPACE(3), REGION) FROM OFFICES;
-- LOWER() ��������� ������ � ������ �������
-- UPPER() ��������� ������ � ������� �������
SELECT LOWER(CITY), UPPER(CITY) FROM OFFICES;
-- REPLICATE() ��������� ������
SELECT CITY, REPLICATE(CITY, 4) FROM OFFICES;

----------- ���������� ������� - ���� ---------------------
-- GETDATE() ���������� ������� ��������� ���� � �����
-- �� ������ ��������� ����� � ���� ������� datetime
SELECT GETDATE();
-- GETUTCDATE() ���������� ������� ��������� ���� � �����
-- �� �������� (UTC/GMT) � ���� ������� datetime
SELECT GETUTCDATE(); 
 
-- SYSDATETIME() ���������� ������� ��������� ���� � �����
-- SYSUTCDATETIME() ���������� ������� ��������� ���� � ����� �� �������� (UTC/GMT)
-- ���� � ����� ������������ � ���� ������� datetime2
SELECT SYSDATETIME() date_time, SYSUTCDATETIME() utc_date_time;
      
-- SYSDATETIMEOFFSET() ���������� ������ datetimeoffset(7)
-- ������� �������� ���� � ����� ������������ GMT
SELECT SYSDATETIMEOFFSET();
-- DAY() ���������� ���� ����
-- MONTH() ���������� ����� ����
-- YEAR() ���������� ��� �� ����
SELECT  ORDER_DATE,
  DAY(ORDER_DATE),
  MONTH(ORDER_DATE),
  YEAR(ORDER_DATE) FROM Orders;
-- DATENAME() ���������� ����� ���� � ���� ������
-- �������� ������ ����� ���� ���������� ������ ����������
-- ���� ���������� ������ ����������
SELECT  DATENAME(month, GETDATE()),
  DATENAME(year, GETDATE()),
  DATENAME(quarter, GETDATE()),
  DATENAME(dayofyear, GETDATE()),
  DATENAME(year, GETDATE()),
  DATENAME(day, GETDATE()),
  DATENAME(week, GETDATE()),
  DATENAME(weekday, GETDATE()),
  DATENAME(hour, GETDATE()),
  DATENAME(minute, GETDATE());
-- year (yy, yyyy): ���
-- quarter (qq, q): �������
-- month (mm, m): �����
-- dayofyear (dy, y): ���� ����
-- day (dd, d): ���� ������
-- week (wk, ww): ������
-- weekday (dw): ���� ������
-- hour (hh): ���
-- minute (mi, n): ������
-- second (ss, s): �������
-- millisecond (ms): ������������
-- microsecond (mcs): ������������
-- nanosecond (ns): �����������
-- tzoffset (tz): �������� � ������� ������������ �������� (��� ������� datetimeoffset)
-- DATEPART() ���������� ����� ���� � ���� �����
SELECT DATEPART(month, GETDATE());
-- DATEADD() ���������� ����, ������� �������� �����������
-- �������� ����� � ������������� ���������� ����
SELECT  DATEADD(month, 2, GETDATE()),
  DATEADD(day, 15, GETDATE()),
        DATEADD(day, -25, GETDATE());
-- DATEDIFF() ���������� ������� ����� ����� ������
SELECT DATEDIFF(day, '2019-01-20', GETDATE());
-- TODATETIMEOFFSET() ���������� �������� datetimeoffset
-- ������� �������� ����������� �������� ���������� �������� � ������ �������� datetimeoffset
SELECT  TODATETIMEOFFSET('2019-07-18 01:10:22', '+03:00'),
  TODATETIMEOFFSET('2019-07-18 01:10:22', '-03:00');
-- SWITCHOFFSET() ���������� �������� datetimeoffset
-- ������� �������� ����������� �������� ���������� �������� � �������� datetime2
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+02:30');
-- EOMONTH() ���������� ���� ���������� ��� ��� ������
-- �����q �������� - ���������� �������
SELECT EOMONTH(GETDATE());
SELECT EOMONTH(GETDATE(), -3);
-- DATEFROMPARTS() ������� ����
SELECT DATEFROMPARTS(2019, 10, 10);
-- ISDATE: ���������, �������� �� ��������� �����
-- ���� ��������, �� ���������� 1, ����� 0
SELECT ISDATE(GETDATE()), ISDATE('SQL');
----------- ���������� ������� - ��������� -------------------
SELECT  @@ROWCOUNT,
  @@SERVERNAME,
  @@IDENTITY,
  @@VERSION,
  @@ERROR,
  @@SPID,
  @@TRANCOUNT,
  @@FETCH_STATUS,
  @@NESTLEVEL;
----------- �������� RETURN -------------------
PRINT '1';
RETURN;    -- ����� �� ������
PRINT '2'; -- �� ����������
GO
PRINT '3';
----------- ��������� BEGIN END -------------------
PRINT '------- ����� 1 -----';
DECLARE @X1 INT = 1;
PRINT '����� 1, X1 =' + CAST(@X1 AS varchar(5));
BEGIN
 PRINT '------- ����� 1 ----- ���� 1 ---------';
 DECLARE @X11 INT = 11;
 PRINT '���� 1, X1 = ' + CAST(@X1 AS varchar(5));
 PRINT '���� 1, X11 = ' + CAST(@X11 AS varchar(5));
 BEGIN
  PRINT '------ ����� 1 ---- ���� 1 ---- ���� 2 ----';
  DECLARE @X21 INT = 21;
  PRINT '���� 2, X1 = ' + CAST(@X1 AS varchar(5));
  PRINT '���� 2, X11 = ' + CAST(@X11 AS varchar(5));
  PRINT '���� 2, X21 = ' + CAST(@X21 AS varchar(5));
  PRINT '����� --- ����� 1 ---- ���� 1 ---- ���� 2 ----';
 END;
 BEGIN
  PRINT '------ ����� 1 ---- ���� 1 ---- ���� 3 ----';
  PRINT '���� 3, X1 = ' + CAST(@X1 AS varchar(5));
  PRINT '���� 3, X11 = ' + CAST(@X11 AS varchar(5));
  PRINT '���� 3, X21 = ' + CAST(@X21 AS varchar(5));
  RETURN; --
  PRINT '����� --- ����� 1 ---- ���� 1 ---- ���� 3 ----';
 END;
 PRINT '����� --- ����� 1 ---- ���� 1 ---- ';
END;
PRINT '����� --- ����� 1 ----------------- ';
GO
PRINT '------- ����� 2 -----';

----------- �������� IF ELSE -------------------
DECLARE @X int = 1,
  @Y decimal (5,3),
  @Z float (4) = 4.3E-2;
IF @x < @Z -- @x > @Y -- NULL
BEGIN
 SELECT @X, @Y, @Z;
END;
ELSE
PRINT 'ELSE';
GO
----------- ����������� ELSE IF -------------------
DECLARE @X int = 120;
IF @x > 200 PRINT 'x > 200'
 ELSE IF @x > 150 PRINT 'x BETWEEN 150 AND 200'
 ELSE IF @x > 50 PRINT 'x BETWEEN 50 AND 150'
 ELSE PRINT 'x < 50';
GO
----------- �������� CASE -------------------
DECLARE @X int = 17;
PRINT
(CASE
 WHEN @x > 200 THEN 'x > 200'
 WHEN @x > 100 THEN 'x BETWEEN 150 AND 200'
 WHEN @x > 50  THEN 'x BETWEEN 50 AND 150'
 ELSE 'x < 50'
END)
GO
----------- �������� WHILE -------------------
DECLARE @X int = 1;
WHILE (@X<10)
BEGIN
 PRINT @X;
 SET @X = @x+1;
END
GO
----- �������� WHILE --- BREAK � CONTINUE -------------------
DECLARE @X int = 1, @Y int;
WHILE (@X<10)
BEGIN
 SET @Y = @x;
 SET @X = @x+1;
 PRINT 'Block A' + cast(@Y as varchar(3));
 IF @Y = 2 CONTINUE; -- �� ������ �����
 IF @Y = 4 BREAK;  -- ����� �� �����
 PRINT 'Block B' + cast(@Y as varchar(3));
END
GO
----- ����������� TRY - CATCH -------------------
DECLARE @X int = 2, @Y int = 0, @Z int;
BEGIN TRY
 PRINT 'Block A'
 SET @Z = @X/@Y; -- ERR
 PRINT 'Block B'
END TRY
BEGIN CATCH
 PRINT 'Block C'
END CATCH
GO
DECLARE @X int = 2, @Y int = 0, @Z int;
BEGIN TRY
 SET @Z = @X/@Y; -- ERR
END TRY
BEGIN CATCH
 PRINT 'Block CATCH'
 PRINT ERROR_NUMBER()
 PRINT ERROR_MESSAGE()
 PRINT ERROR_LINE()
 PRINT ERROR_PROCEDURE()
 PRINT ERROR_SEVERITY()
 PRINT ERROR_STATE()
END CATCH
GO
DECLARE @X int = 2, @Y int = 0, @Z int;
BEGIN TRY
 RAISERROR ('Error raised in TRY block.', -- Message text. 
               16, -- Severity. 
               1   -- State. 
               ); 
END TRY
BEGIN CATCH
 PRINT 'Block CATCH'
 PRINT ERROR_NUMBER()
 PRINT ERROR_MESSAGE()
 PRINT ERROR_LINE()
 PRINT ERROR_PROCEDURE()
 PRINT ERROR_SEVERITY()
 PRINT ERROR_STATE()
END CATCH
GO
----- �������� WAITFOR --����������� ���������� �������-----------------
DECLARE @X char(8) = '12:25';
SELECT SYSDATETIME();
WAITFOR TIME @X;
SELECT SYSDATETIME();
GO
DECLARE @X char(8) = '00:00:12';
SELECT SYSDATETIME();
WAITFOR DELAY @X;
SELECT SYSDATETIME();
GO

---------------------- ������� -------------------------------
DECLARE @office int, @city varchar(15),  @message varchar(80),
    @region varchar(10), @sales decimal(9, 2);
DECLARE office_cursor CURSOR FOR  
SELECT OFFICE, CITY, REGION, SALES FROM OFFICES;
 
OPEN office_cursor;
 
FETCH FROM office_cursor INTO @office, @city, @region, @sales;
 
WHILE @@FETCH_STATUS = 0 
BEGIN 
   SELECT @message = cast(@office as varchar(10))+ ' ' + @city + ' ' + @region+ ' ' +
      cast(@sales as varchar(10));
   PRINT @message; 
   FETCH FROM office_cursor INTO @office, @city, @region, @sales;
END ;
CLOSE office_cursor; 
DEALLOCATE office_cursor; 

---------------------- ������� ----- scroll --------------------
-- FIRST
-- LAST
-- PRIOR
-- NEXT
-- ABSOLUTE N
-- RELATIVE N
DECLARE @office int, @city varchar(15),  @message varchar(80),
    @region varchar(10), @sales decimal(9, 2);
DECLARE office_cursor CURSOR SCROLL
FOR  
SELECT OFFICE, CITY, REGION, SALES FROM OFFICES;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10)) -- @@CURSOR_ROWS
OPEN office_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
FETCH LAST FROM office_cursor INTO @office, @city, @region, @sales;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
WHILE @@FETCH_STATUS = 0 
BEGIN 
   SELECT @message = cast(@office as varchar(10))+ ' ' + @city + ' ' + @region+ ' ' +
      cast(@sales as varchar(10));
 
   PRINT @message; 
   FETCH PRIOR FROM office_cursor INTO @office, @city, @region, @sales;
   PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
END ;
CLOSE office_cursor; 
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
DEALLOCATE office_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
------------------------ ������� ----- @@CURSOR_ROWS -----------
DECLARE @office int, @city varchar(15),  @message varchar(80),
    @region varchar(10), @sales decimal(9, 2);
DECLARE office_cursor CURSOR --STATIC
FOR  
SELECT OFFICE, CITY, REGION, SALES FROM OFFICES;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10)) -- @@CURSOR_ROWS
OPEN office_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
FETCH FROM office_cursor INTO @office, @city, @region, @sales;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
WHILE @@FETCH_STATUS = 0 
BEGIN 
   SELECT @message = cast(@office as varchar(10))+ ' ' + @city + ' ' + @region+ ' ' +
      cast(@sales as varchar(10));
 
   PRINT @message; 
   FETCH FROM office_cursor INTO @office, @city, @region, @sales;
   PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
END ;
CLOSE office_cursor; 
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
DEALLOCATE office_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
----------������� � ���������� ---------------------
DECLARE @office int = 11, @message VARCHAR(80);
DECLARE @name nvarchar(50),  @title varchar(80);
 
DECLARE prep_cursor CURSOR FOR  
    SELECT  NAME, TITLE FROM SALESREPS
     WHERE REP_OFFICE = @office;
OPEN prep_cursor; 
  FETCH FROM prep_cursor INTO  @name, @title;
    IF @@FETCH_STATUS <> 0  
        PRINT '         <>';    
    WHILE @@FETCH_STATUS = 0 
     BEGIN 
        SELECT @message = @name + '    ' + @title;
        PRINT @message ;
        FETCH FROM prep_cursor INTO @name, @title;
     END; 
CLOSE prep_cursor;
DEALLOCATE prep_cursor;
----------������� UPDATE CURRENT OF ---------------------
DECLARE @name nvarchar(50),  @title varchar(80);
 
DECLARE prep_cursor CURSOR FOR  
    SELECT  NAME, TITLE FROM SALESREPS;
OPEN prep_cursor; 
  FETCH FROM prep_cursor INTO  @name, @title;
  WHILE @@FETCH_STATUS = 0 
     BEGIN 
        IF @name = 'Sam Clark' UPDATE SALESREPS SET TITLE = 'VIP SALES'
     WHERE CURRENT OF prep_cursor;
        FETCH FROM prep_cursor INTO @name, @title;
     END; 
CLOSE prep_cursor;
DEALLOCATE prep_cursor;      
---------- ��������� ������� ----- OFFICES --- SALESREPS -------------
DECLARE @office int, @city varchar(15),  @message varchar(80),
    @region varchar(10), @sales decimal(9, 2);
DECLARE @name nvarchar(50),  @title varchar(80);  
 
PRINT '-------- OFFICES Personal Report --------'; 
 
DECLARE office_cursor CURSOR FOR  
SELECT OFFICE, CITY, REGION, SALES
FROM OFFICES;
 
OPEN office_cursor;
 
FETCH NEXT FROM office_cursor 
INTO @office, @city, @region, @sales;
 
WHILE @@FETCH_STATUS = 0 
BEGIN 
    PRINT ' ' ;
    SELECT @message = '----- Personal From OFFICE: ' + ' ' + @city + ' ' + @region;
 
    PRINT @message; 
 
    -- Declare an inner cursor based    
    -- on office_id from the outer cursor
    DECLARE prep_cursor CURSOR FOR  
    SELECT  NAME,
   TITLE
    FROM SALESREPS
    WHERE REP_OFFICE = @office;  -- Variable value from the outer cursor 
 
    OPEN prep_cursor; 
    FETCH NEXT FROM prep_cursor INTO  @name, @title;
    IF @@FETCH_STATUS <> 0  
        PRINT '         <>';    
 
    WHILE @@FETCH_STATUS = 0 
     BEGIN 
        SELECT @message = '         ' +  @name + '    ' + @title;
        PRINT @message ;
        FETCH NEXT FROM prep_cursor INTO @name, @title ;
     END; 
    CLOSE prep_cursor;
    DEALLOCATE prep_cursor;
       
  -- Get the next office. 
    FETCH NEXT FROM office_cursor  
    INTO @office, @city, @region, @sales;
END ;
CLOSE office_cursor; 
DEALLOCATE office_cursor; 

---------------------sp_describe_cursor-----------------------
-- Declare and open a global cursor. 
DECLARE ABC CURSOR STATIC FOR 
SELECT NAME  FROM SALESREPS; 
 
OPEN ABC; 
 
-- Declare a cursor variable to hold the cursor output variable 
-- from sp_describe_cursor. 
DECLARE @Report CURSOR; 
 
-- Execute sp_describe_cursor into the cursor variable. 
EXEC master.dbo.sp_describe_cursor @cursor_return = @Report OUTPUT, 
        @cursor_source = N'global', @cursor_identity = N'abc'; 
 
-- Fetch all the rows from the sp_describe_cursor output cursor. 
FETCH NEXT from @Report; 
WHILE (@@FETCH_STATUS <> -1) 
BEGIN 
    FETCH NEXT from @Report; 
END 
 
-- Close and deallocate the cursor from sp_describe_cursor. 
CLOSE @Report; 
DEALLOCATE @Report; 
GO 
 
-- Close and deallocate the original cursor. 
CLOSE abc; 
DEALLOCATE abc; 
GO 