CREATE TABLE OFFICES
     (OFFICE INT NOT NULL,
        CITY VARCHAR(15) NOT NULL,
      REGION VARCHAR(10) NOT NULL,
         MGR INT,
      TARGET DECIMAL(9,2),
       SALES DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (OFFICE));

INSERT INTO OFFICES VALUES(22,'Denver','Western',null,300000.00,186042.00);
INSERT INTO OFFICES VALUES(11,'New York','Eastern',null,575000.00,692637.00);
INSERT INTO OFFICES VALUES(12,'Chicago','Eastern',null,800000.00,735042.00);
INSERT INTO OFFICES VALUES(13,'Atlanta','Eastern',null,350000.00,367911.00);
INSERT INTO OFFICES VALUES(21,'Los Angeles','Western',null,725000.00,835915.00);


UPDATE OFFICES SET MGR=108 WHERE OFFICE=22;
UPDATE OFFICES SET MGR=106 WHERE OFFICE=11;
UPDATE OFFICES SET MGR=104 WHERE OFFICE=12;
UPDATE OFFICES SET MGR=105 WHERE OFFICE=13;
UPDATE OFFICES SET MGR=108 WHERE OFFICE=21;

select * from OFFICES;

--Лабораторная работа №7 – СУБД – 2 часа
--Транзакции в T-SQL.
--1.	Разработать скрипт, демонстрирующий работу в режиме неявной транзакции.
SET IMPLICIT_TRANSACTIONS ON; --устанавливаем режим неявных транзакций (в режим ON)
	INSERT INTO OFFICES (OFFICE, CITY, REGION, MGR, TARGET, SALES) VALUES (50, 'Minsk', 'Belarus', 200, 5000, 7500); --добавляем новую запись
select * from OFFICES;
	UPDATE OFFICES SET REGION = 'RB' WHERE OFFICE = 50; -- Обновление имени клиента в таблице Customers
COMMIT; -- Если операция прошла успешно, фиксируем изменения
	INSERT INTO OFFICES (OFFICE, CITY, REGION, MGR, TARGET, SALES) VALUES (30, 'Brest', 'Belarus', 200, 5000, 7500); -- Добавление еще одной записи, но с ошибкой, 																							--предполагая, что поле OFFICE должно быть уникальным
ROLLBACK; -- команда вызовет ошибку из-за дублирования OFFICE
SET IMPLICIT_TRANSACTIONS OFF; -- Выключаем режим неявных транзакций

----ИЛИ
----1.	Разработать скрипт, демонстрирующий работу в режиме неявной транзакции.
--SET IMPLICIT_TRANSACTIONS ON; --включаем режим неявных транзакций
--INSERT INTO OFFICES VALUES (60, 'Brest', 'Western', 150, 60000.00, 60000.00);
--COMMIT;

--INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00); --создаем новую строку, чтобы потом удалить ее
--ROLLBACK; --отменяем создание Grodno
--SET IMPLICIT_TRANSACTIONS OFF; --выключаем режим неявных транзакций

--2.	Разработать скрипт, демонстрирующий свойства ACID явной транзакции. В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
BEGIN TRY
    BEGIN TRANSACTION; -- Начало транзакции
    -- Делаем изменения в базе данных
		INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00);
		INSERT INTO OFFICES VALUES (70, 'Polock', 'Western', 150, 60000.00, 60000.00);
    COMMIT TRANSACTION; -- Фиксация транзакции
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION; -- Откат транзакции
    END

    -- Вывод сообщения об ошибке
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

----ИЛИ
----2.	Разработать скрипт, демонстрирующий свойства ACID явной транзакции. В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
--BEGIN TRY
--	BEGIN TRANSACTION
--		INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00);
--		INSERT INTO OFFICES VALUES (70, 'Polock', 'Western', 150, 60000.00, 60000.00);
--	COMMIT TRANSACTION               
--END TRY

--BEGIN CATCH --при возникновении ошибки,выполняется этот блок
--PRINT 'There is an error: '+ 
--	  CASE
--          WHEN error_number() = 2627 THEN 'All lines should be unique' 
--          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
--	  END; 
--	 IF @@trancount > 0 PRINT @@trancount ROLLBACK TRAN ; 	  
--END CATCH

--3.	Разработать скрипт, демонстрирующий применение оператора SAVETRAN. В блоке CATCH предусмотреть 
--выдачу соответствующих сообщений об ошибках. 
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO OFFICES VALUES (80, 'Berlin', 'Eastern', 150, 60000.00, 60000.00);
		SAVE TRANSACTION SavePointName --точка сохранения
		INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00);
		INSERT INTO OFFICES VALUES (70, 'Polock', 'Western', 150, 60000.00, 60000.00);
	COMMIT TRANSACTION               
END TRY

BEGIN CATCH --при возникновении ошибки,выполняется этот блок
PRINT 'There is an error: '+ 
	  CASE
          WHEN error_number() = 2627 THEN 'All lines should be unique' 
          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
	  END; 
	 IF @@trancount > 0 PRINT @@trancount ROLLBACK TRAN ; 	  
END CATCH

select * from OFFICES;
--4.	Разработать два скрипта A и B. Продемонстрировать неподтвержденное, неповторяющееся и фантомное чтение. 
--Показать усиление уровней изолированности.
--Для неподтвержденного чтения:
--Скрипт A — транзакция 1:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;-- Установка уровня изоляции для демонстрации неподтвержденного чтения
	BEGIN TRANSACTION;
SELECT * FROM OFFICES WHERE MGR = 108; -- Чтение записей
	WAITFOR DELAY '00:00:05'; -- ждем перед коммитом, чтобы Скрипт B мог выполнить вставку/обновление
COMMIT;

--Скрипт B — транзакция 2:
BEGIN TRANSACTION;
UPDATE OFFICES SET REGION = 'Eastern' WHERE MGR = 108;-- Вставка или обновление записи, которая еще не подтверждена
WAITFOR DELAY '00:00:10';-- Завершаем транзакцию спустя некоторое время после начала транзакции A
COMMIT;

--Для неповторяющегося чтения:
--Скрипт A — транзакция 1:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;-- Установка уровня изоляции для демонстрации неподтвержденного чтения
	BEGIN TRANSACTION;
SELECT * FROM OFFICES WHERE MGR = 108; -- Чтение записей
	WAITFOR DELAY '00:00:05'; -- ждем перед коммитом, чтобы Скрипт B мог выполнить вставку/обновление
COMMIT;

--Скрипт B — транзакция 2:
BEGIN TRANSACTION;
UPDATE OFFICES SET REGION = 'Eastern' WHERE MGR = 108;-- Вставка или обновление записи, которая еще не подтверждена
WAITFOR DELAY '00:00:10';-- Завершаем транзакцию спустя некоторое время после начала транзакции A
COMMIT;

--Для фантомного чтения:
--Скрипт A — транзакция 1:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- Установка уровня изоляции для демонстрации неподтвержденного чтения
	BEGIN TRANSACTION
			INSERT INTO OFFICES VALUES (90, 'Belostok', 'Poland', 108, 60000.00, 60000.00);
SELECT * FROM OFFICES WHERE MGR = 108; -- Чтение записей
	WAITFOR DELAY '00:00:05'; -- ждем перед коммитом, чтобы Скрипт B мог выполнить вставку/обновление
COMMIT;

--Скрипт B — транзакция 2:
BEGIN TRANSACTION;
UPDATE OFFICES SET REGION = 'Eastern' WHERE MGR = 108;-- Вставка или обновление записи, которая еще не подтверждена
WAITFOR DELAY '00:00:10';-- Завершаем транзакцию спустя некоторое время после начала транзакции A
COMMIT;

--5.	Разработать скрипт, демонстрирующий свойства вложенных транзакций. 
BEGIN TRANSACTION; -- Начало основной транзакции
	INSERT INTO OFFICES VALUES (100, 'Podgorica', 'Montenegro', 108, 60000.00, 60000.00);
SAVE TRANSACTION SavePoint1; --точка сохранения
BEGIN TRY
    INSERT INTO OFFICES VALUES (101, 'Budva', 'Montenegro', 108, 60000.00, 60000.00);-- ошибка
    SAVE TRANSACTION SavePoint2;-- Если все хорошо, создаем следующую точку сохранения
    BEGIN TRY -- Более глубокий уровень операций
		UPDATE OFFICES SET REGION = 'Eastern' WHERE CITY = 'Budva';-- Вставка или обновление записи, которая еще не подтверждена
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION SavePoint2;-- Если ошибка на втором уровне, то откатываем до точки сохранения 2
    END CATCH
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION SavePoint1;
END CATCH

COMMIT TRANSACTION; -- Если все выполнилось успешно, фиксируем транзакцию




	select * from OFFICES
