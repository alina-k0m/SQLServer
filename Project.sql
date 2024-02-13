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
USE [2023_Komarovskaya_Project]
GO
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
USE [2023_Komarovskaya_Project];
GO
	CREATE ROLE NameRole
	AUTHORIZATION NameUser; --если не писать AUTHORIZATION NameUser, то не будет назначено владельца, владелец по умолчанию - dbo
GO

--назначить разрешения роли
	GRANT SELECT ON [dbo].[STUDENTS] TO NameRole;
GO

--добавить пользователя в роль
	ALTER ROLE NameRole 
	ADD MEMBER NameOtherUser; --NameOtherUser - пользователь, который должен войти в эту роль.
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
select * from RESULT --0.0032985 --0.0032985
where GPA > 6.00;
--средняя по группе
select RES_ID, avg(GPA) --0.0033 --0.0033
from RESULT
group by RES_ID;
create index idx_RES_GPA on RESULT (GPA);


--select E.STUD_ID, S.SUB_ID, S.SUB_NAME, S.EXAM_GRADE_MIN, E.EXAM_GRADE --0.0066022 --0.013
--from EXAM E join SUBJECTS S
--on E.SUB_ID = S.SUB_ID
--where E.SUB_ID = 'MATH' and E.EXAM_GRADE > S.EXAM_GRADE_MIN;
--create index idx_EXAM_EXAM_GRADE_SUB_ID on EXAM(EXAM_GRADE) include (SUB_ID);
--create index idx_SUB_EXAM_GRADE_MIN on SUBJECTS(EXAM_GRADE_MIN);



--5.4.	Процедуры (все обновление данных в БД допускаются только через процедуры. 
--Использовать обработку ошибок, курсоры и транзакции там, где это необходимо.)
--5.5.	Функции.
--5.6.	Триггеры. 
--5.7.	Выдать привилегии на запуск процедур и функций.
--6.	Добавить в скрипт проверку для всех созданных программных объектов.
--7.	Импортировать данные из внешних источников. Импорт должен быть отражен в скрипте 
--или в пояснительной записке.
--8.	Создать процедуру для экспорта данных. Экспорт должен быть отражен в скрипте 
--или в пояснительной записке.
--9.	Настроить резервное копирование базы данных. 
--Резервное копирование должно быть отражено в скрипте или в пояснительной записке.
--10.	Продемонстрировать преподавателю готовый скрипт и записку.

