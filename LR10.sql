---
---  CREATE TABLE statements
---

--DROP TABLE ORDERS;
--DROP TABLE CUSTOMERS;
--DROP TABLE SALESREPS;
--DROP TABLE OFFICES;
--DROP TABLE PRODUCTS;


CREATE TABLE PRODUCTS
     (MFR_ID CHAR(3) NOT NULL,
  PRODUCT_ID CHAR(5) NOT NULL,
 DESCRIPTION VARCHAR(20) NOT NULL,
       PRICE MONEY NOT NULL,
 QTY_ON_HAND INTEGER NOT NULL,
 PRIMARY KEY (MFR_ID, PRODUCT_ID));


CREATE TABLE OFFICES
     (OFFICE INT NOT NULL,
        CITY VARCHAR(15) NOT NULL,
      REGION VARCHAR(10) NOT NULL,
         MGR INT,
      TARGET DECIMAL(9,2),
       SALES DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (OFFICE));


CREATE TABLE SALESREPS
   (EMPL_NUM INT NOT NULL,
             CHECK (EMPL_NUM BETWEEN 101 AND 199),
        NAME VARCHAR(15) NOT NULL,
         AGE INTEGER,
  REP_OFFICE INTEGER,
       TITLE VARCHAR(10),
   HIRE_DATE DATE NOT NULL,
     MANAGER INT,
       QUOTA DECIMAL(9,2),
       SALES DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (EMPL_NUM),
 FOREIGN KEY (MANAGER) REFERENCES SALESREPS(EMPL_NUM),
 CONSTRAINT WORKSIN FOREIGN KEY (REP_OFFICE)  
  REFERENCES OFFICES(OFFICE));


CREATE TABLE CUSTOMERS
   (CUST_NUM INTEGER    NOT NULL,
    COMPANY VARCHAR(20) NOT NULL,
    CUST_REP INTEGER,
    CREDIT_LIMIT DECIMAL(9,2),
 PRIMARY KEY (CUST_NUM),
 CONSTRAINT HASREP FOREIGN KEY (CUST_REP)
  REFERENCES SALESREPS(EMPL_NUM));


CREATE TABLE ORDERS
  (ORDER_NUM INTEGER NOT NULL,
             CHECK (ORDER_NUM > 100000),
  ORDER_DATE DATE NOT NULL,
        CUST INTEGER NOT NULL,
         REP INTEGER,
         MFR CHAR(3) NOT NULL,
     PRODUCT CHAR(5) NOT NULL,
         QTY INTEGER NOT NULL,
      AMOUNT DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (ORDER_NUM),
 CONSTRAINT PLACEDBY FOREIGN KEY (CUST)
  REFERENCES CUSTOMERS(CUST_NUM)
   ON DELETE CASCADE,
 CONSTRAINT TAKENBY FOREIGN KEY (REP)
  REFERENCES SALESREPS(EMPL_NUM),
 CONSTRAINT ISFOR FOREIGN KEY (MFR, PRODUCT)
  REFERENCES PRODUCTS(MFR_ID, PRODUCT_ID));


ALTER TABLE OFFICES
  ADD CONSTRAINT HASMGR
  FOREIGN KEY (MGR) REFERENCES SALESREPS(EMPL_NUM);

---
---  Inserts for sample schema
---

---
---  PRODUCTS
---
INSERT INTO PRODUCTS VALUES('REI','2A45C','Ratchet Link',79.00,210);
INSERT INTO PRODUCTS VALUES('ACI','4100Y','Widget Remover',2750.00,25);
INSERT INTO PRODUCTS VALUES('QSA','XK47 ','Reducer',355.00,38);
INSERT INTO PRODUCTS VALUES('BIC','41627','Plate',180.00,0);
INSERT INTO PRODUCTS VALUES('IMM','779C ','900-LB Brace',1875.00,9);
INSERT INTO PRODUCTS VALUES('ACI','41003','Size 3 Widget',107.00,207);
INSERT INTO PRODUCTS VALUES('ACI','41004','Size 4 Widget',117.00,139);
INSERT INTO PRODUCTS VALUES('BIC','41003','Handle',652.00,3);
INSERT INTO PRODUCTS VALUES('IMM','887P ','Brace Pin',250.00,24);
INSERT INTO PRODUCTS VALUES('QSA','XK48 ','Reducer',134.00,203);
INSERT INTO PRODUCTS VALUES('REI','2A44L','Left Hinge',4500.00,12);
INSERT INTO PRODUCTS VALUES('FEA','112  ','Housing',148.00,115);
INSERT INTO PRODUCTS VALUES('IMM','887H ','Brace Holder',54.00,223);
INSERT INTO PRODUCTS VALUES('BIC','41089','Retainer',225.00,78);
INSERT INTO PRODUCTS VALUES('ACI','41001','Size 1 Wiget',55.00,277);
INSERT INTO PRODUCTS VALUES('IMM','775C ','500-lb Brace',1425.00,5);
INSERT INTO PRODUCTS VALUES('ACI','4100Z','Widget Installer',2500.00,28);
INSERT INTO PRODUCTS VALUES('QSA','XK48A','Reducer',177.00,37);
INSERT INTO PRODUCTS VALUES('ACI','41002','Size 2 Widget',76.00,167);
INSERT INTO PRODUCTS VALUES('REI','2A44R','Right Hinge',4500.00,12);
INSERT INTO PRODUCTS VALUES('IMM','773C ','300-lb Brace',975.00,28);
INSERT INTO PRODUCTS VALUES('ACI','4100X','Widget Adjuster',25.00,37);
INSERT INTO PRODUCTS VALUES('FEA','114  ','Motor Mount',243.00,15);
INSERT INTO PRODUCTS VALUES('IMM','887X ','Brace Retainer',475.00,32);
INSERT INTO PRODUCTS VALUES('REI','2A44G','Hinge Pin',350.00,14);


---
---  OFFICES
---
INSERT INTO OFFICES VALUES(22,'Denver','Western',null,300000.00,186042.00);
INSERT INTO OFFICES VALUES(11,'New York','Eastern',null,575000.00,692637.00);
INSERT INTO OFFICES VALUES(12,'Chicago','Eastern',null,800000.00,735042.00);
INSERT INTO OFFICES VALUES(13,'Atlanta','Eastern',null,350000.00,367911.00);
INSERT INTO OFFICES VALUES(21,'Los Angeles','Western',null,725000.00,835915.00);


---
---  SALESREPS
---
INSERT INTO SALESREPS VALUES (106,'Sam Clark',52,11,'VP Sales','2006-06-14',null,275000.00,299912.00);
INSERT INTO SALESREPS VALUES (109,'Mary Jones',31,11,'Sales Rep','2007-10-12',106,300000.00,392725.00);
INSERT INTO SALESREPS VALUES (104,'Bob Smith',33,12,'Sales Mgr','2005-05-19',106,200000.00,142594.00);
INSERT INTO SALESREPS VALUES (108,'Larry Fitch',62,21,'Sales Mgr','2007-10-12',106,350000.00,361865.00);
INSERT INTO SALESREPS VALUES (105,'Bill Adams',37,13,'Sales Rep','2006-02-12',104,350000.00,367911.00);
INSERT INTO SALESREPS VALUES (102,'Sue Smith',48,21,'Sales Rep','2004-12-10',108,350000.00,474050.00);
INSERT INTO SALESREPS VALUES (101,'Dan Roberts',45,12,'Sales Rep','2004-10-20',104,300000.00,305673.00);
INSERT INTO SALESREPS VALUES (110,'Tom Snyder',41,null,'Sales Rep','2008-01-13',101,null,75985.00);
INSERT INTO SALESREPS VALUES (103,'Paul Cruz',29,12,'Sales Rep','2005-03-01',104,275000.00,286775.00);
INSERT INTO SALESREPS VALUES (107,'Nancy Angelli',49,22,'Sales Rep','2006-11-14',108,300000.00,186042.00);


---
---   OFFICE MANAGERS
---
UPDATE OFFICES SET MGR=108 WHERE OFFICE=22;
UPDATE OFFICES SET MGR=106 WHERE OFFICE=11;
UPDATE OFFICES SET MGR=104 WHERE OFFICE=12;
UPDATE OFFICES SET MGR=105 WHERE OFFICE=13;
UPDATE OFFICES SET MGR=108 WHERE OFFICE=21;

---
---   CUSTOMERS
---
INSERT INTO CUSTOMERS VALUES(2111,'JCP Inc.',103,50000.00);
INSERT INTO CUSTOMERS VALUES(2102,'First Corp.',101,65000.00);
INSERT INTO CUSTOMERS VALUES(2103,'Acme Mfg.',105,50000.00);
INSERT INTO CUSTOMERS VALUES(2123,'Carter \& Sons',102,40000.00);
INSERT INTO CUSTOMERS VALUES(2107,'Ace International',110,35000.00);
INSERT INTO CUSTOMERS VALUES(2115,'Smithson Corp.',101,20000.00);
INSERT INTO CUSTOMERS VALUES(2101,'Jones Mfg.',106,65000.00);
INSERT INTO CUSTOMERS VALUES(2112,'Zetacorp',108,50000.00);
INSERT INTO CUSTOMERS VALUES(2121,'QMA Assoc.',103,45000.00);
INSERT INTO CUSTOMERS VALUES(2114,'Orion Corp.',102,20000.00);
INSERT INTO CUSTOMERS VALUES(2124,'Peter Brothers',107,40000.00);
INSERT INTO CUSTOMERS VALUES(2108,'Holm \& Landis',109,55000.00);
INSERT INTO CUSTOMERS VALUES(2117,'J.P. Sinclair',106,35000.00);
INSERT INTO CUSTOMERS VALUES(2122,'Three Way Lines',105,30000.00);
INSERT INTO CUSTOMERS VALUES(2120,'Rico Enterprises',102,50000.00);
INSERT INTO CUSTOMERS VALUES(2106,'Fred Lewis Corp.',102,65000.00);
INSERT INTO CUSTOMERS VALUES(2119,'Solomon Inc.',109,25000.00);
INSERT INTO CUSTOMERS VALUES(2118,'Midwest Systems',108,60000.00);
INSERT INTO CUSTOMERS VALUES(2113,'Ian \& Schmidt',104,20000.00);
INSERT INTO CUSTOMERS VALUES(2109,'Chen Associates',103,25000.00);
INSERT INTO CUSTOMERS VALUES(2105,'AAA Investments',101,45000.00);

---
---  ORDERS
---
INSERT INTO ORDERS VALUES (112961,'2007-12-17',2117,106,'REI','2A44L',7,31500.00);
INSERT INTO ORDERS VALUES (113012,'2008-01-11',2111,105,'ACI','41003',35,3745.00);
INSERT INTO ORDERS VALUES (112989,'2008-01-03',2101,106,'FEA','114',6,1458.00);
INSERT INTO ORDERS VALUES (113051,'2008-02-10',2118,108,'QSA','XK47',4,1420.00);
INSERT INTO ORDERS VALUES (112968,'2007-10-12',2102,101,'ACI','41004',34,3978.00);
INSERT INTO ORDERS VALUES (113036,'2008-01-30',2107,110,'ACI','4100Z',9,22500.00);
INSERT INTO ORDERS VALUES (113045,'2008-02-02',2112,108,'REI','2A44R',10,45000.00);
INSERT INTO ORDERS VALUES (112963,'2007-12-17',2103,105,'ACI','41004',28,3276.00);
INSERT INTO ORDERS VALUES (113013,'2008-01-14',2118,108,'BIC','41003',1,652.00);
INSERT INTO ORDERS VALUES (113058,'2008-02-23',2108,109,'FEA','112',10,1480.00);
INSERT INTO ORDERS VALUES (112997,'2008-01-08',2124,107,'BIC','41003',1,652.00);
INSERT INTO ORDERS VALUES (112983,'2007-12-27',2103,105,'ACI','41004',6,702.00);
INSERT INTO ORDERS VALUES (113024,'2008-01-20',2114,108,'QSA','XK47',20,7100.00);
INSERT INTO ORDERS VALUES (113062,'2008-02-24',2124,107,'FEA','114',10,2430.00);
INSERT INTO ORDERS VALUES (112979,'2007-10-12',2114,102,'ACI','4100Z',6,15000.00);
INSERT INTO ORDERS VALUES (113027,'2008-01-22',2103,105,'ACI','41002',54,4104.00);
INSERT INTO ORDERS VALUES (113007,'2008-01-08',2112,108,'IMM','773C',3,2925.00);
INSERT INTO ORDERS VALUES (113069,'2008-03-02',2109,107,'IMM','775C',22,31350.00);
INSERT INTO ORDERS VALUES (113034,'2008-01-29',2107,110,'REI','2A45C',8,632.00);
INSERT INTO ORDERS VALUES (112992,'2007-11-04',2118,108,'ACI','41002',10,760.00);
INSERT INTO ORDERS VALUES (112975,'2007-10-12',2111,103,'REI','2A44G',6,2100.00);
INSERT INTO ORDERS VALUES (113055,'2008-02-15',2108,101,'ACI','4100X',6,150.00);
INSERT INTO ORDERS VALUES (113048,'2008-02-10',2120,102,'IMM','779C',2,3750.00);
INSERT INTO ORDERS VALUES (112993,'2007-01-04',2106,102,'REI','2A45C',24,1896.00);
INSERT INTO ORDERS VALUES (113065,'2008-02-27',2106,102,'QSA','XK47',6,2130.00);
INSERT INTO ORDERS VALUES (113003,'2008-01-25',2108,109,'IMM','779C',3,5625.00);
INSERT INTO ORDERS VALUES (113049,'2008-02-10',2118,108,'QSA','XK47',2,776.00);
INSERT INTO ORDERS VALUES (112987,'2007-12-31',2103,105,'ACI','4100Y',11,27500.00);
INSERT INTO ORDERS VALUES (113057,'2008-02-18',2111,103,'ACI','4100X',24,600.00);
INSERT INTO ORDERS VALUES (113042,'2008-02-20',2113,101,'REI','2A44R',5,22500.00);






--Лабораторная работа №10 – СУБД – 2 часа
--Курсоры в T-SQL.
--1.	Разработать курсор, который выводит все данные о клиенте.
--select * from CUSTOMERS;
DECLARE @clientCUST_NUM INTEGER,
		@clientCOMPANY VARCHAR(20),
		@clientCUST_REP INTEGER,
		@clientCREDIT_LIMIT DECIMAL(9,2),
		@message varchar(80);

DECLARE client_cursor CURSOR FOR  --инициализация курсора для перебора информации о клиентах
SELECT CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT FROM CUSTOMERS;
 
OPEN client_cursor; --открытие курсора
 
FETCH FROM client_cursor INTO @clientCUST_NUM, @clientCOMPANY, @clientCUST_REP, @clientCREDIT_LIMIT; --получим 1ое значение из курсора
 
 --перебор всех записей до тех пор пока они есть (до того момента, пока запись не равно 0)
WHILE @@FETCH_STATUS = 0 
BEGIN 
--обработка данных (вывод сообщения)
   SELECT @message = cast(@clientCUST_NUM as varchar(10))+ 
					' ' + @clientCOMPANY + 
					' ' + cast(@clientCUST_REP as varchar(10))+ 
					' ' + cast(@clientCREDIT_LIMIT as varchar(10));

   PRINT @message; 
   FETCH NEXT FROM client_cursor INTO  @clientCUST_NUM, @clientCOMPANY, @clientCUST_REP, @clientCREDIT_LIMIT; --переход к следующей записи (можно без NEXT)
END ;
CLOSE client_cursor; --закрытие курсора
DEALLOCATE client_cursor; --освобождение ресурсов


--2.	Разработать курсор, который выводит все данные о сотрудниках офисов и их количество.
--select * from SALESREPS;
--select * from OFFICES;
DECLARE @office int, 
		@city varchar(15),  
		@message2 varchar(80),
		@region varchar(10), 
		@sales decimal(9, 2);
DECLARE @name nvarchar(50),  
		@title varchar(80),
		@count int;  
  
DECLARE office_cursor CURSOR FOR  
SELECT OFFICE, CITY, REGION, SALES
FROM OFFICES;
 
OPEN office_cursor;
 
FETCH NEXT FROM office_cursor 
INTO @office, @city, @region, @sales;
 
WHILE @@FETCH_STATUS = 0 
BEGIN 
    PRINT ' ' ;
    SELECT @message2 = 'Personal From OFFICE: ' + ' ' + @city + ' ' + @region;
 
    PRINT @message2; 
 
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
        SELECT @message2 = '         ' +  @name + '    ' + @title;
        PRINT @message2;
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


--3.	Разработать локальный курсор, который выводит все сведения о товарах и их среднюю цену.
--select * from PRODUCTS;
DECLARE @DESCRIPTION VARCHAR(20),
		@PRICE MONEY;
DECLARE @AveragePrice money; -- переменная для хранения средней цены

SELECT @AveragePrice = AVG(PRICE) FROM PRODUCTS;-- Вычисляем среднюю цену и сохраняем в переменную

-- Создаем курсор
DECLARE product_cursor CURSOR FOR
SELECT DESCRIPTION, PRICE FROM PRODUCTS;

OPEN product_cursor;-- Открываем курсор

FETCH NEXT FROM product_cursor INTO @DESCRIPTION, @PRICE; -- Получаем первую строку данных

-- Перебираем строки в цикле
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Выводим данные
    PRINT 'Product Name: ' + @DESCRIPTION
        + '; Price: ' + CAST(@PRICE AS nvarchar(20));

    FETCH NEXT FROM product_cursor INTO @DESCRIPTION, @PRICE; -- следующая запись
END;

BEGIN
    -- Выводим среднюю цену
    PRINT 'Average Price: ' + CAST(@AveragePrice AS nvarchar(20));

    FETCH NEXT FROM product_cursor INTO @DESCRIPTION, @PRICE; -- следующая запись
END;

CLOSE product_cursor; -- Закрываем курсор
DEALLOCATE product_cursor; -- Освобождаем ресурсы, связанные с курсором


--4.	Разработать глобальный курсор, который выводит сведения о заказах, выполненных в 2008 году.
--select * from ORDERS;
DECLARE @ORDER_NUM INTEGER,
		@ORDER_DATE DATE,
        @CUST INTEGER,
        @REP INTEGER,
        @MFR CHAR(3),
		@PRODUCT CHAR(5),
        @QTY INTEGER,
		@AMOUNT DECIMAL(9,2);

-- Объявляем курсор для выборки заказов 2008 года
DECLARE orders_cursor CURSOR GLOBAL FOR
SELECT ORDER_NUM, ORDER_DATE, CUST, REP, MFR, PRODUCT, QTY, AMOUNT
FROM ORDERS
WHERE YEAR(ORDER_DATE) = 2008;

OPEN orders_cursor;-- Открываем курсор

FETCH NEXT FROM orders_cursor INTO @ORDER_NUM, @ORDER_DATE, @CUST, @REP, @MFR, @PRODUCT, @QTY, @AMOUNT; -- Получаем первую строку данных

-- Цикл по всем строкам
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ORDER_NUM: ' + CAST(@ORDER_NUM AS nvarchar(20))
        + '; ORDER_DATE: ' + CAST(@ORDER_DATE AS nvarchar(20))
        + '; CUST: ' + CAST(@CUST AS nvarchar(20))
        + '; REP: ' + CAST(@REP AS nvarchar(20))
        + '; MFR: ' + @MFR
        + '; PRODUCT: ' + @PRODUCT
        + '; QTY: ' + CAST(@QTY AS nvarchar(20))
        + '; AMOUNT: ' + CAST(@AMOUNT AS nvarchar(20));
   
    FETCH NEXT FROM orders_cursor INTO @ORDER_NUM, @ORDER_DATE, @CUST, @REP, @MFR, @PRODUCT, @QTY, @AMOUNT;-- Переходим к следующей записи
END;

CLOSE orders_cursor;-- Закрываем курсор
DEALLOCATE orders_cursor;-- Снимаем выделение памяти с курсора


--5.	Разработать статический курсор, который выводит сведения о покупателях и их заказах.
--select * from CUSTOMERS;
--select * from ORDERS;
DECLARE customer_order_cursor CURSOR STATIC FOR -- Объявляем статический курсор
SELECT c.CUST_NUM, c.COMPANY, o.ORDER_NUM, o.ORDER_DATE, o.AMOUNT
FROM CUSTOMERS c join ORDERS o 
on c.CUST_NUM = o.CUST;

DECLARE @CUST_NUM INTEGER,
		@COMPANY VARCHAR(20);
DECLARE @ORDER_NUM5 INTEGER,
		@ORDER_DATE5 DATE,
		@AMOUNT5 DECIMAL(9,2);

OPEN customer_order_cursor;-- Открытие курсора

FETCH FROM customer_order_cursor INTO @CUST_NUM, @COMPANY, @ORDER_NUM5, @ORDER_DATE5, @AMOUNT5;-- Извлечение первой строки

-- Цикл по всем строкам
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'CUST_NUM: ' + CAST(@CUST_NUM AS NVARCHAR) 
        + ', COMPANY: ' + @COMPANY
        + ', ORDER_NUM: ' + CAST(@ORDER_NUM5 AS NVARCHAR)
        + ', ORDER_DATE: ' + CONVERT(NVARCHAR, @ORDER_DATE5, 104)
        + ', AMOUNT: ' + CONVERT(NVARCHAR, @AMOUNT5);

    FETCH NEXT FROM customer_order_cursor INTO @CUST_NUM, @COMPANY, @ORDER_NUM5, @ORDER_DATE5, @AMOUNT5; -- Cледующая строка
END;

-- Закрытие курсора
CLOSE customer_order_cursor;
DEALLOCATE customer_order_cursor;


--6.	Разработать динамический курсор, который обновляет данные о сотруднике в зависимости от суммы выполненных заказов (поле SALES).
--select * from SALESREPS;
DECLARE @EMPL_NUM INT,
        @NAME6 VARCHAR(15),
        @AGE INTEGER,
		@REP_OFFICE INTEGER,
		@TITLE6 VARCHAR(10),
		@HIRE_DATE DATE,
		@MANAGER INT,
		@QUOTA DECIMAL(9,2),
		@SALES6 DECIMAL(9,2);
		
DECLARE employee_cursor CURSOR DYNAMIC FOR -- Объявляем динамический курсор
SELECT * FROM SALESREPS;

OPEN employee_cursor

FETCH FROM employee_cursor INTO @EMPL_NUM, @NAME6, @AGE, @REP_OFFICE, @TITLE6, @HIRE_DATE, @MANAGER, @QUOTA, @SALES6 -- Извлечение первой строки

-- Цикл по всем строкам
WHILE @@FETCH_STATUS = 0
BEGIN
  -- Обновляем сумму заказов для сотрудника
	UPDATE SALESREPS
	SET EMPL_NUM = @EMPL_NUM,
		NAME = @NAME6,
		AGE = @AGE,
		REP_OFFICE = @REP_OFFICE,
		TITLE = @TITLE6,
		HIRE_DATE = @HIRE_DATE,
		MANAGER = @MANAGER,
		QUOTA = @QUOTA
	WHERE SALES = @SALES6

	FETCH NEXT FROM employee_cursor INTO @EMPL_NUM, @NAME6, @AGE, @REP_OFFICE, @TITLE6, @HIRE_DATE, @MANAGER, @QUOTA, @SALES6 -- Получаем следующую строку

END

-- Закрываем курсор и освобождаем ресурсы
CLOSE employee_cursor
DEALLOCATE employee_cursor

--7.	Продемонстрировать свойства SCROLL.
DECLARE @office7 int, 
		@city7 varchar(15),  
		@message7 varchar(80),
		@region7 varchar(10), 
		@sales7 decimal(9, 2);
DECLARE office_cursor CURSOR SCROLL
FOR  
SELECT OFFICE, CITY, REGION, SALES FROM OFFICES;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10)) -- @@CURSOR_ROWS
OPEN office_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
FETCH LAST FROM office_cursor INTO @office7, @city7, @region7, @sales7;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
WHILE @@FETCH_STATUS = 0 
BEGIN 
   SELECT @message7 = cast(@office7 as varchar(10))
					+ ' ' + @city7 
					+ ' ' + @region7+ ' ' 
					+ cast(@sales7 as varchar(10));
 
   PRINT @message7; 
   FETCH PRIOR FROM office_cursor INTO @office7, @city7, @region7, @sales7;
   PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
END ;
CLOSE office_cursor; 
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10))
DEALLOCATE office_cursor;
PRINT CAST(@@CURSOR_ROWS  AS VARCHAR(10));

