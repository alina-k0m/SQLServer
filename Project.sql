--Лабораторная работа № 15 – СУБД – 10 часов

--Итоговое задание.
--1.	Уточнить свой вариант у преподавателя. Результатом итогового задания являются скрипт 
--и пояснительная записка. Создание всех объектов должно быть отражено в скрипте. 
--Проектирование должно быть отражено в пояснительной записке.
--2.	Спроектировать базу данных по своему варианту. 
--2.1.	Перечислить решаемые задачи. Среди решаемых задач должны быть пространственные данные 
--и импорт-экспорт из/в XML.
--Пространственные данные обычно содержат информацию о географическом положении и форме объектов. 
--В Microsoft SQL Server для хранения таких данных используются типы `geometry` для плоских карт 
--и `geography` для хранения объектов на земной поверхности.
--Geography type point object (Los Angeles)
DECLARE @g geography;  
SET @g = geography::STGeomFromText('POINT (-118.2423 34.0225)', 4326)
SELECT @g

--Geometry type point object
DECLARE @h geometry;  
SET @h = geometry::STGeomFromText('POINT (-118.2423 34.0225)', 4326)
SELECT @h


--Экспорт данных из MS SQL в XML
SELECT *
FROM RESULT
FOR XML PATH('row'), ROOT('rows') --FOR XML позволяет форматировать результаты запроса XML напрямую в SQL запросе

--Импорт XML в MS SQL
INSERT INTO RESULT (XmlCol)
SELECT *
FROM OPENROWSET(
    BULK 'C:\Users\Alina\Microsoft SQL Server Management Studio 19\SQLServer\fileFROM.xml',
    SINGLE_BLOB) --SINGLE_BLOB - исользуя это можно избежать несоответствия между кодировкой XML-документа и строковой кодовой страницой, подразумеваемой сервером
AS x;



--2.2.	Перечислить пользователей и их возможности.
--Server Logins (учетные записи на сервере):
--1. sysadmin: Полный и неограниченный доступ ко всем функциям в SQL Server.
--2. serveradmin: Могут изменять конфигурацию сервера и останавливать сервер.
--3. securityadmin: Могут управлять учетными записями и привилегиями на уровне сервера.
--4. processadmin: Могут управлять процессами, выполняющимися на сервере.
--5. setupadmin: Могут управлять некоторыми опциями сервера, такими как связанные серверы.
--6. bulkadmin: Могут выполнять массовую загрузку данных.
--Database Users (пользователи базы данных):**
--1. db_owner: Полный доступ ко всем ресурсам в рамках базы данных.
--2. db_securityadmin: Могут управлять ролями и разрешениями внутри базы данных.
--3. db_accessadmin: Могут управлять доступом пользователей к базе данных.
--4. db_backupoperator: Могут выполнять резервное копирование.
--5. db_ddladmin: Могут выполнять DDL-операции (Data Definition Language), но не имеют доступа к данным.
--6. db_datawriter: Могут добавлять, удалять или изменять данные в базе данных.
--7. db_datareader: Могут читать все данные из всех таблиц базы данных.
--8. db_denydatawriter: Могут быть отстранены от добавления, изменения или удаления данных в базе данных.
--9. db_denydatareader: Могут быть отстранены от чтения данных в базе данных.



--2.3.	Перечислить ограничения.
--1. PRIMARY KEY: Определяет уникальный идентификатор для каждой записи в таблице. В каждой таблице может быть только один PRIMARY KEY, который может состоять из одного или нескольких полей.
--2. FOREIGN KEY: Устанавливает связь между полями в двух таблицах. Ограничение FOREIGN KEY на поле (или полях) ссылается на PRIMARY KEY другой таблицы и определяет связь родительского ключа с дочерним ключом.
--3. UNIQUE: Гарантирует, что все значения в колонке уникальны. В отличие от PRIMARY KEY, можно иметь несколько UNIQUE ограничений в таблице.
--4. CHECK: Позволяет определить диапазон допустимых значений для поля в таблице. CHECK ограничение может быть установлено для отдельного поля или для группы полей в таблице.
--5. DEFAULT: Устанавливает значение по умолчанию, которое будет вставлено в поле, если при вставке записи значение для этого поля не указано.
--6. INDEX: Технически не является ограничением, но часто используется в контексте обсуждения ограничений для улучшения производительности запроса через эффективный поиск данных. Однако, в отличие от ограничений, индекс не обеспечивает целостности данных.
--7. NOT NULL: Указывает, что поле не может содержать значение NULL, то есть каждая запись должна содержать значение в данном поле.



--2.4.	Спроектировать таблицы, указать типы данных и ограничения целостности.
--2.5.	Уточнить направления дальнейшего развития. 
--3.	Создать базу данных. 
--4.	Настроить безопасность: 
--4.1.	Создать логины и пользователей. 
--создание логина
CREATE LOGIN [NewLogin] WITH PASSWORD = N'Password123!', 
	DEFAULT_DATABASE=[2023_Komarovskaya_Project], 
	CHECK_EXPIRATION=OFF, --не применять политику истечения срока действия пароля
	CHECK_POLICY=OFF --не проверять минимальное количество символов пароля
GO

--создание пользователя
USE [DBName] --DBName - имя базы данных, к которой надо предоставить доступ пользователю
GO
	CREATE USER [NewUser] --NewUser - имя пользователя базы данных, которое надо создать
	FOR LOGIN [NewLogin]
GO

--назначить роль
USE [DBName]
GO
	ALTER ROLE [db_datareader] ADD MEMBER [NewUser] --предоставляет права на чтение и запись в базе данных
GO
	ALTER ROLE [db_datawriter] ADD MEMBER [NewUser]
GO



--4.2.	Создать роли.
--CREATE ROLE NameRole
--AUTHORIZATION NameUser; --если не писать AUTHORIZATION NameUser, то не будет назначено владельца, владелец по умолчанию - dbo
--GO

----назначить разрешения роли
--GRANT SELECT ON [dbo].[STUDENTS] TO NameRole;
--GO

----добавить пользователя в роль
--ALTER ROLE NameRole 
--ADD MEMBER NameOtherUser; --NameOtherUser - пользователь, который должен войти в эту роль.
--GO
CREATE ROLE ADMIN
CREATE ROLE STUDENT
CREATE ROLE TEACHER;
GO

ALTER ROLE db_datareader ADD MEMBER STUDENT
GO
-- предоставление права на чтение для STUDENT на таблицу RESULT
GRANT SELECT ON RESULT TO STUDENT;
GO
ALTER ROLE db_datareader ADD MEMBER TEACHER
GO
ALTER ROLE db_datawriter ADD MEMBER TEACHER
GO
-- предоставление права на чтение и редактирование для TEACHER на таблицу RESULT и EXAM
GRANT SELECT ON RESULT TO STUDENT;
GO
GRANT SELECT ON EXAM TO STUDENT;
GO
ALTER ROLE db_datareader ADD MEMBER ADMIN
GO
ALTER ROLE db_datawriter ADD MEMBER ADMIN
GO
ALTER ROLE db_securityadmin ADD MEMBER ADMIN --изменять членство в роли (только для настраиваемых ролей) и управлять разрешениями
GO
ALTER ROLE db_accessadmin ADD MEMBER ADMIN --добавлять или удалять доступ к базе данных
GO
ALTER ROLE db_backupoperator ADD MEMBER ADMIN --могут создавать резервные копии базы данных
GO
--предоставление права для ADMIN
GRANT SELECT ON STUDENTS TO ADMIN;
GO
GRANT SELECT ON SUBJECTS TO ADMIN;
GO
GRANT SELECT ON EXAM TO ADMIN;
GO
GRANT SELECT ON RESULT TO ADMIN;
GO
-- удаление права на чтение для STUDENT на таблицу RESULT
REVOKE SELECT ON RESULT FROM STUDENT;
GO



--5.	Создать для своей базы данных:
--5.1.	Таблицы с тестовыми данными.
CREATE TABLE STUDENTS
     (	STUD_ID CHAR(3) NOT NULL,
		STUD_NAME VARCHAR(20) NOT NULL,
		ADDRESS VARCHAR(50) NOT NULL,
		PHONE INTEGER NOT NULL,
	PRIMARY KEY (STUD_ID));



CREATE TABLE SUBJECTS
     (	SUB_ID CHAR(4) NOT NULL,
        SUB_NAME VARCHAR(20) NOT NULL,
		VOL_MIN DECIMAL(9,2),
        VOL_LK INT,
        VOL_PZ INT,
        VOL_LR INT,
		GPA_MIN DECIMAL(9,2), --минимальный ср.балл
	                CHECK (GPA_MIN BETWEEN 1 AND 10),
		EXAM_GRADE_MIN DECIMAL(9,2) NOT NULL,
	                CHECK (EXAM_GRADE_MIN BETWEEN 1 AND 10),
	PRIMARY KEY (SUB_ID));



CREATE TABLE EXAM
   (	EXAM_ID CHAR(10) NOT NULL,
        SUB_ID CHAR(4) NOT NULL,
        STUD_ID CHAR(3) NOT NULL,
		EXAM_DATE DATE NOT NULL,
		EXAM_GRADE DECIMAL(9,2),
	                CHECK (EXAM_GRADE BETWEEN 1 AND 10),
	PRIMARY KEY (EXAM_ID),
CONSTRAINT EXAMSUB FOREIGN KEY (SUB_ID)
REFERENCES SUBJECTS(SUB_ID),
CONSTRAINT EXAMSTUD FOREIGN KEY (STUD_ID)
REFERENCES STUDENTS(STUD_ID));



CREATE TABLE RESULT
   (	RES_ID CHAR(10) NOT NULL,
		EXAM_ID CHAR(10) NOT NULL,
		ATTENDANCE DECIMAL(9,2), --посещаемость
		GPA DECIMAL(9,2), --ср.балл
	                CHECK (GPA BETWEEN 1 AND 10),
	PRIMARY KEY (RES_ID),
CONSTRAINT RESEXAM FOREIGN KEY (EXAM_ID)
REFERENCES EXAM(EXAM_ID));


INSERT INTO STUDENTS VALUES('SC1','Sam Clark','Denver',	1111111);
INSERT INTO STUDENTS VALUES('MJ2','Mary Jones','New York',2222222);
INSERT INTO STUDENTS VALUES('BS3','Bob Smith ','Chicago',3333333);
INSERT INTO STUDENTS VALUES('LF4','Larry Fitch','Atlanta',4444444);
INSERT INTO STUDENTS VALUES('BA5','Bill Adams ','Los Angeles',5555555);
select* from STUDENTS;



INSERT INTO SUBJECTS VALUES('ENG','English',	320.00,	80,	320,	null,	7.00,	5.50);
INSERT INTO SUBJECTS VALUES('LIT','Literature',	368.00,	60,	400,	20,		6.50,	6.00);
INSERT INTO SUBJECTS VALUES('MATH','Maths',		904.00,	90,	440,	600,	6.00,	5.50);
INSERT INTO SUBJECTS VALUES('GEO','Geography',	320.00,	50,	null,	350,	7.50,	7.00);
INSERT INTO SUBJECTS VALUES('HIST','History',	440.00,	50,	350,	150,	8.00,	7.50);
INSERT INTO SUBJECTS VALUES('BIO','Biology',	536.00,	40,	430,	200,	8.00,	7.50);
INSERT INTO SUBJECTS VALUES('CHEM','Chemistry',	880.00,	70,	480,	550,	6.00,	5.50);
select* from SUBJECTS;


UPDATE SUBJECTS SET EXAM_GRADE_MIN=5.00 WHERE SUB_ID='ENG';
select* from SUBJECTS;



INSERT INTO EXAM VALUES ('EXENGSC1',	'ENG',	'SC1','2023-06-14',5.50);
INSERT INTO EXAM VALUES ('EXLITMJ2',	'LIT',	'MJ2','2024-01-12',7.90);
INSERT INTO EXAM VALUES ('EXMATHMJ2',	'MATH',	'MJ2','2023-12-19',5.00);
INSERT INTO EXAM VALUES ('EXGEOBS3',	'GEO',	'BS3','2023-11-12',5.50);
INSERT INTO EXAM VALUES ('EXHISTBS3',	'HIST',	'BS3','2024-02-12',8.00);
INSERT INTO EXAM VALUES ('EXBIOBS3',	'BIO',	'BS3','2023-10-28',7.00);
INSERT INTO EXAM VALUES ('EXENGLF4',	'ENG',	'LF4','2023-06-14',9.00);
INSERT INTO EXAM VALUES ('EXMATHLF4',	'MATH',	'LF4','2023-12-19',9.00);
INSERT INTO EXAM VALUES ('EXCHEMLF4',	'CHEM',	'LF4','2024-01-30',6.00);
INSERT INTO EXAM VALUES ('EXBIOLF4',	'BIO',	'LF4','2023-10-28',8.00);
INSERT INTO EXAM VALUES ('EXHISTBA5',	'HIST',	'BA5','2024-02-12',8.50);
INSERT INTO EXAM VALUES ('EXGEOBA5',	'GEO',	'BA5','2023-11-12',8.00);
INSERT INTO EXAM VALUES ('EXMATHBA5',	'MATH',	'BA5','2023-12-19',6.50);
INSERT INTO EXAM VALUES ('EXLITBA5',	'LIT',	'BA5','2024-01-12',8.00);
INSERT INTO EXAM VALUES ('EXENGBA5',	'ENG',	'BA5','2024-06-14',null);
select* from EXAM;



INSERT INTO RESULT VALUES('RESENGSC1','EXENGSC1',		300.00,		8.00);
INSERT INTO RESULT VALUES('RESLITMJ2','EXLITMJ2',		440.00,		7.00);
INSERT INTO RESULT VALUES('RESMATHMJ2','EXMATHMJ2',		550.00,		6.00);
INSERT INTO RESULT VALUES('RESGEOBS3','EXGEOBS3',		550.00,		7.50);
INSERT INTO RESULT VALUES('RESHISTBS3','EXHISTBS3',		450.00,		5.00);
INSERT INTO RESULT VALUES('RESBIOBS3','EXBIOBS3',		550.00,		9.00);
INSERT INTO RESULT VALUES('RESENGLF4','EXENGLF4',		350.00,		6.00);
INSERT INTO RESULT VALUES('RESMATHLF4','EXMATHLF4',		1100.00,	5.00);
INSERT INTO RESULT VALUES('RESCHEMLF4','EXCHEMLF4',		900.00,		8.00);
INSERT INTO RESULT VALUES('RESBIOLF4','EXBIOLF4',		610.00,		8.00);
INSERT INTO RESULT VALUES('RESHISTBA5','EXHISTBA5',		600.00,		9.00);
INSERT INTO RESULT VALUES('RESGEOBA5','EXGEOBA5',		300.00,		8.50);
INSERT INTO RESULT VALUES('RESMATHBA5','EXMATHBA5',		1200.00,	4.00);
INSERT INTO RESULT VALUES('RESLITBA5','EXLITBA5',		430.00,		6.00);
INSERT INTO RESULT VALUES('RESENGBA5','EXENGBA5',		10.50,		5.00);
select* from RESULT;



--5.2.	Представления.
-- Поскольку представления зависят от базовых таблиц, 
--структурные изменения в этих таблицах могут привести 
--к необходимости обновления или повторного создания представлений.
--1. студенты, которые не сдали экзамены
CREATE VIEW View1 AS
SELECT E.STUD_ID, E.SUB_ID, R.EXAM_ID, R.GPA, E.EXAM_GRADE
FROM Result R join Exam E
ON R.EXAM_ID = E.EXAM_ID
WHERE E.EXAM_GRADE is null;
GO

--показать представление
SELECT * FROM View1;

--2.Экзамены, которые проходят в 2024
create view View2 as
select EXAM_ID, SUB_ID, STUD_ID, EXAM_DATE
from EXAM
where year(EXAM_DATE) = 2024;
--ИЛИ
--where EXAM_DATE between '2024-01-01' and '2024-12-31';
go

--обновить представление (год изменен на 2023 и добавить оценки EXAM_GRADE) 
--Если представление состоит из нескольких таблиц, 
--его нельзя обновить из-за неоднозначности отношений между таблицами
ALTER VIEW View2 AS
select EXAM_ID, SUB_ID, STUD_ID, EXAM_DATE, EXAM_GRADE
from EXAM
where year(EXAM_DATE) = 2023;
--ИЛИ
--where EXAM_DATE between '2023-01-01' and '2023-12-31';
go

SELECT * FROM View2;

--удалить представление
DROP VIEW View1;
DROP VIEW View2;



--5.3.	Индексы.
--найти студентов, которые на экзамене по матем получили больше проходного балла (5,5)
select * from EXAM;
select * from SUBJECTS;
select GPA, RES_ID from RESULT --0.0032985 --0.0032831
where GPA = 4.00;
--средняя по группе
select RES_ID, avg(GPA) --0.0033 --0.0033
from RESULT
group by RES_ID;
create index idx_RES_GPA on RESULT (GPA) include (RES_ID);


--select E.STUD_ID, S.SUB_ID, S.SUB_NAME, S.EXAM_GRADE_MIN, E.EXAM_GRADE --0.0066022 --0.013
--from EXAM E join SUBJECTS S
--on E.SUB_ID = S.SUB_ID
--where E.SUB_ID = 'MATH' and E.EXAM_GRADE > S.EXAM_GRADE_MIN;
--create index idx_EXAM_EXAM_GRADE_SUB_ID on EXAM(EXAM_GRADE) include (SUB_ID);
--create index idx_SUB_EXAM_GRADE_MIN on SUBJECTS(EXAM_GRADE_MIN);



--5.4.	Процедуры (все обновление данных в БД допускаются только через процедуры. 
--Использовать обработку ошибок, курсоры и транзакции там, где это необходимо.)
CREATE PROCEDURE Procedure1
AS
BEGIN
    BEGIN TRANSACTION -- Начало транзакции

    BEGIN TRY
        -- Объявление курсора для построчного чтения из таблицы
        DECLARE myCursor CURSOR FOR
            SELECT RES_ID, GPA FROM RESULT WHERE GPA >= 9.00
       
        OPEN myCursor -- Открытие курсора и начало чтения

        DECLARE @GPA DECIMAL

        FETCH NEXT FROM myCursor INTO @GPA -- Чтение первой строки

        WHILE @@FETCH_STATUS = 0 -- Проход по строкам таблицы (читает, пока 0; перестает читать, когда 1)

        BEGIN
            -- обновление ATTENDANCE
            UPDATE RESULT
            SET ATTENDANCE = 2000.00
            WHERE GPA = @GPA

            FETCH NEXT FROM myCursor INTO @GPA -- Чтение следующей строки

        END

        CLOSE myCursor -- Закрытие курсора и освобождение ресурсов
        DEALLOCATE myCursor --освобождение ресурсов

        COMMIT TRANSACTION-- Если все прошло успешно, подтвердить транзакцию
    END TRY
    BEGIN CATCH
        -- Если произошла ошибка, закрыть курсор и откатить транзакцию
        IF CURSOR_STATUS('global','myCursor') >= 0
        BEGIN
            CLOSE myCursor
            DEALLOCATE myCursor
        END
        ROLLBACK TRANSACTION-- Откат транзакции
		
        -- Получение информации об ошибке и её выброс
        DECLARE @ErrorNumber INT = ERROR_NUMBER()
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO


create procedure add_student 
	@id CHAR(3),
	@name VARCHAR(20),
	@address VARCHAR(50),
	@phone INTEGER
as
begin 
	begin try
		insert into STUDENTS values (@id, @name, @address, @phone)
	end try
	begin catch
	declare @error_code int = @@ERROR;
		if @error_code = 2627 print 'Dublicate student!';
		if @error_code = 947 print 'No such rep!';
		end catch
end;
go

--вызов процедуры
exec add_student 'I11', 'Ivan', 'Minsk', 1234567;
		insert into STUDENTS values ('II0', 'Ivan', 'Minsk', 1234567)

go

select * from STUDENTS

CREATE PROCEDURE proc_STUDENTS
AS
SELECT
   *
FROM STUDENTS;
GO
--вызов процедуры
exec proc_STUDENTS;
go




--5.5.	Функции.
--1. Скалярная функция (возвращает одно значение):
CREATE FUNCTION dbo.GetFormattedDate(@Date DATETIME)
RETURNS VARCHAR(30)
AS
BEGIN
    -- Возвращает дату в формате 'DD-MM-YYYY'
    RETURN CONVERT(VARCHAR(10), @Date, 105)
END
GO

--Чтобы использовать эту функцию, надо ее вызвать:
	SELECT dbo.GetFormattedDate(GETDATE()) AS FormattedDate


--2. Табличная функция (возвращает набор строк):
CREATE FUNCTION dbo.GetListStudents(@ListStudents NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM STUDENTS
);
GO

--Использовать табличную функцию:
	SELECT * FROM dbo.GetListStudents('');
	GO



--5.6.	Триггеры. 
--создание таблицы, в которую триггером добавляются записи об изменениях
CREATE TABLE StudentsAudit
     (	STUD_ID CHAR(3) NOT NULL,
		STUD_NAME VARCHAR(20) NOT NULL,
		ADDRESS VARCHAR(50) NOT NULL,
		PHONE INTEGER NOT NULL,
	PRIMARY KEY (STUD_ID));
GO
select * from STUDENTS;
select * from StudentsAudit;
GO
-- создание AFTER INSERT триггера (добавление)
CREATE TRIGGER trg_Insert ON STUDENTS
AFTER INSERT
AS
BEGIN
    -- при добавлении данных в таблице STUDENTS, старые данные сохраняются в таблицу StudentsAudit
    INSERT INTO StudentsAudit (STUD_ID, STUD_NAME, ADDRESS)
    SELECT i.STUD_ID, 'INSERT', GETDATE()
    FROM inserted i; --inserted - таблица, доступная внутри триггера, которая содержит копии всех строк, подвергающихся операции INSERT
END;
GO

-- создание AFTER UPDATE триггера (обновление)
CREATE TRIGGER trg_Update ON STUDENTS
AFTER UPDATE
AS
BEGIN
    -- при обновлении данных в таблице STUDENTS, старые данные сохраняются в таблицу StudentsAudit
    INSERT INTO StudentsAudit (STUD_ID, STUD_NAME, ADDRESS, PHONE)
	SELECT d.STUD_ID, 'UPDATE', GETDATE(), CONCAT(',', d.STUD_ID, d.STUD_NAME, d.ADDRESS, d.PHONE)
    FROM deleted d;
END;
GO

-- создание AFTER DELETE триггера (удаление)
CREATE TRIGGER trg_Delete ON STUDENTS
AFTER DELETE
AS
BEGIN
    -- при удалении данных в таблице STUDENTS, старые данные сохраняются в таблицу StudentsAudit
    INSERT INTO StudentsAudit (STUD_ID, STUD_NAME, ADDRESS)
    SELECT d.STUD_ID, 'DELETE', GETDATE()
    FROM deleted d;
END;
GO

--Удаление триггера
DROP TRIGGER trg_Insert;
DROP TRIGGER trg_Update;
DROP TRIGGER trg_Delete;


--Отключение и включение триггера
DISABLE TRIGGER trg_Insert ON STUDENTS; --выкл
ENABLE TRIGGER trg_Insert ON STUDENTS; --вкл



--5.7.	Выдать привилегии на запуск процедур и функций.
GRANT EXECUTE ON
dbo.Procedure1 TO ADMIN;



--6.	Добавить в скрипт проверку для всех созданных программных объектов.
--1. Проверка существования таблицы:
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'STUDENTS')
BEGIN
    -- Таблица существует
    PRINT 'Таблица существует.'
END
ELSE
BEGIN
    -- Таблица не найдена
    PRINT 'Таблица не найдена.'
END

--2. Проверка существования хранимой процедуры:
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Procedure1')
BEGIN
    -- Хранимая процедура существует
    PRINT 'Хранимая процедура существует.'
END
ELSE
BEGIN
    -- Хранимая процедура не найдена
    PRINT 'Хранимая процедура не найдена.'
END

--3. Проверка существования функции:
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('dbo.GetFormattedDate'))
BEGIN
    -- Функция существует
    PRINT 'Функция существует.'
END
ELSE
BEGIN
    -- Функция не найдена
    PRINT 'Функция не найдена.'
END

--4. Проверка существования триггера:
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_Update')
BEGIN
    -- Триггер существует
    PRINT 'Триггер существует.'
END
ELSE
BEGIN
    -- Триггер не найден
    PRINT 'Триггер не найден.'
END

--5. Проверка существования представления:
IF EXISTS (SELECT * FROM sys.views WHERE name = 'View2')
BEGIN
    -- Представление существует
    PRINT 'Представление существует.'
END
ELSE
BEGIN
    -- Представление не найдено
    PRINT 'Представление не найдено.'
END



--7.	Импортировать данные из внешних источников. 
--Импорт должен быть отражен в скрипте или в пояснительной записке.
--1. Откройте SQL Server Management Studio (SSMS)** и подключитесь к серверу, на который хотите импортировать данные.
--2. Щелкните правой кнопкой мыши по базе данных, в которую хотите импортировать данные, выберите "Tasks" > "Import Data...".
--3. Мастер импорта данных запустится. Щелкните "Next" для продолжения.
--4. Выберите источник данных из предоставленного списка и настройте его параметры.
--5. Выберите целевую базу данных и таблицу.
--6. Можно настроить отображение (mapping) столбцов, если это необходимо.
--7. Последние шаги мастера позволяют выполнить импорт сразу или сохранить его как SSIS пакет для последующего использования.
--8. Просмотрите сводку и нажмите "Finish", чтобы выполнить импорт.
--BULK INSERT: для импорта данных из файла в SQL Server таблицу.



--8.	Создать процедуру для экспорта данных. 
--Экспорт должен быть отражен в скрипте или в пояснительной записке.
USE [2023_Komarovskaya_Project];
GO

-- Создаем процедуру экспорта
CREATE PROCEDURE ExportData
    @tableName VARCHAR(256), -- имя таблицы, данные которой вы хотите экспортировать
    @exportPath NVARCHAR(256) --путь файла, куда будет произведен экспорт данных
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sqlCmd NVARCHAR(MAX) = 'sqlcmd -S ' 
	+ @@SERVERNAME 
	+ ' -d ' 
	+ DB_NAME() 
	+ ' -E -Q "SET NOCOUNT ON; SELECT * FROM ' 
	+ @tableName 
	+ '" -o "' 
	+ @exportPath 
	+ '" -h-1 -s"," -w 700';
    EXEC xp_cmdshell @sqlCmd;

    SET NOCOUNT OFF;
END;
GO

--Перед тем, как использовать эту процедуру, удостоверьтесь, что служба 'xp_cmdshell' включена:
-- Активируем xp_cmdshell
--НЕ НАЖИМАТЬ
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

--выполняе процедуру
EXEC ExportData @tableName = 'Export', @exportPath = 'C:\Users\Alina\Microsoft SQL Server Management Studio 19\SQLServer\Export.csv';



--9.	Настроить резервное копирование базы данных. 
--Резервное копирование должно быть отражено в скрипте или 
--в пояснительной записке.
BACKUP DATABASE [2023_Komarovskaya_08]
TO DISK = 'C:\Users\Alina\Microsoft SQL Server Management Studio 19\SQLServer\BACKUP.bak'
WITH NOFORMAT, -- NOFORMAT говорит о том, что не нужно форматировать накопитель, использовать существующий.
	NOINIT,-- указывает, что файл резервной копии не должен инициализироваться заново, но новая резервная копия будет добавляться в существующий файл.
    SKIP, -- означает пропустить проверку метки резервной медии и метки окончания ленты.
-- `NOREWIND` и `NOUNLOAD` применяются в случае использования ленточных накопителей, инструктируя SQL Server не перематывать и не извлекать ленту после окончания резервного копирования.
	NOREWIND, 
	NOUNLOAD, 
	STATS = 10;-- определяет процент выполнения операции, который будет отображаться во время резервного копирования.
-- STATS = 10 отображает прогресс выполнения каждые 10%.
