-- ������� ����������
create table WEATHER (w varchar(10) unique);

DECLARE @flag int = 2 ;
SET IMPLICIT_TRANSACTIONS ON;
INSERT weather VALUES ('Sun'), ('Rain'), ('Wind');
IF @flag = 1  COMMIT ELSE ROLLBACK; -- ���������� ������� � �������, ���� �������� ����� 1

SELECT * FROM weather;  -- ��������

INSERT weather VALUES ('Sun');

-- ����������� ����� ���������� - ����������� ��� ��������� ��� �� ����

BEGIN TRY
	BEGIN TRANSACTION
	 DELETE  weather WHERE w = 'Sun';
	 INSERT weather VALUES ('Rain');
	 INSERT weather VALUES ('Rain');
	COMMIT TRAN               
END TRY
		
BEGIN CATCH
PRINT 'There is an error: '+ 
	  CASE
          WHEN error_number() = 2627 THEN 'All lines should be unique' 
          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
	  END; 
	 IF @@trancount > 0 PRINT @@trancount ROLLBACK TRAN ; 	  
END CATCH

SELECT * FROM weather;

-- �������� ����������� �����
DECLARE @point VARCHAR(6)
BEGIN TRY
	BEGIN TRANSACTION
	 DELETE  weather WHERE w = 'Sun';
	 SET @point = 'point1'; 
	 SAVE TRAN @point;  
	 INSERT weather VALUES ('Rain');
	 SET @point = 'point2'; 
	 SAVE TRAN @point;  
	 INSERT weather VALUES ('Rain');
	COMMIT TRAN               
END TRY
		
BEGIN CATCH
PRINT 'There is an error: '+ 
	  CASE
          WHEN error_number() = 2627 THEN 'All lines should be unique' 
          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
	  END; 
	 IF @@trancount > 0 
	 BEGIN
	   PRINT 'Control point: '+ @point;
	   ROLLBACK TRAN @point;                                  
	   COMMIT TRAN;                  
	END;     
   END CATCH;	  

SELECT * FROM weather;

--- ��������� ����������
PRINT 'TRANCOUNT 1 = ' + cast(@@TRANCOUNT as varchar (20)); 
BEGIN TRAN													--  ������� ����������   
 INSERT weather VALUES ('Sun');
 PRINT 'TRANCOUNT 2 = ' + cast(@@TRANCOUNT as varchar (20)); 
 BEGIN TRAN													--  ���������� ����������  
	UPDATE weather SET w = 'Snow' WHERE w = 'Rain';
	PRINT 'TRANCOUNT 3 = ' + cast(@@TRANCOUNT as varchar (20)); 
 COMMIT;													--  ���������� ����������
 PRINT 'TRANCOUNT 4 = ' + cast(@@TRANCOUNT as varchar (20));                                               
 IF @@TRANCOUNT > 0  
ROLLBACK;													--  ������� ���������� 
PRINT 'TRANCOUNT 5 = ' + cast(@@TRANCOUNT as varchar (20));  





-- AUDIT  
 CREATE TABLE AUDIT 
   (
     ID   INT  IDENTITY,    
     ST   VARCHAR(20) CHECK (ST IN ('INS', 'DEL','UPD')), 
     TRN  VARCHAR(50),
     C    VARCHAR(300)
    ) 
GO
-- TR_INS
CREATE  TRIGGER TR_INS ON WEATHER AFTER INSERT  
      AS
      DECLARE @IN VARCHAR(30);
      PRINT 'INSERT';
      SET @IN = (SELECT w FROM INSERTED);
      INSERT INTO AUDIT(ST, TRN, C) VALUES('INS', 'TR_INS ', @IN);	         
      RETURN;  
GO

-------------------
INSERT INTO WEATHER VALUES ('Snow');
GO

SELECT * FROM  AUDIT;
GO

-- TR_DEL
CREATE  TRIGGER TR_DEL ON WEATHER AFTER DELETE  
      AS
      DECLARE @IN VARCHAR(300);
      PRINT 'DELETE';
      SET @IN = (SELECT w FROM DELETED);
      INSERT INTO AUDIT(ST, TRN, C) VALUES('DEL', 'TR_DEL', @IN);	         
      RETURN;  
GO

-------------------------
DELETE FROM WEATHER WHERE w ='Snow';
GO

SELECT * FROM  AUDIT;
SELECT * FROM  WEATHER;
GO

-- constraint
INSERT INTO WEATHER VALUES ('Sun'); 
GO

SELECT * FROM  AUDIT;
GO

-- sys.triggers
select * from sys.triggers;


select * from sys.trigger_events;


select * from sys.trigger_event_types;
go

-- Trigger order
CREATE  TRIGGER TR_DEL1 ON WEATHER AFTER DELETE  
      AS
      DECLARE @IN VARCHAR(30);
      PRINT 'DELETE';
      SET @IN = (SELECT w FROM DELETED);
      INSERT INTO AUDIT(ST, TRN, C) VALUES('DEL', 'TR_DEL1', @IN);	         
      RETURN;  
GO


SELECT T.NAME, E.TYPE_DESC 
  FROM SYS.TRIGGERS  T JOIN  SYS.TRIGGER_EVENTS E  ON T.OBJECT_ID = E.OBJECT_ID  
  WHERE OBJECT_NAME(T.PARENT_ID)='weather' AND E.TYPE_DESC = 'DELETE' ; 
  
--  ��������� ������ ������� ���������� ���������
EXEC  SP_SETTRIGGERORDER @TRIGGERNAME = 'TR_DEL1', @ORDER='FIRST', @STMTTYPE = 'DELETE';
EXEC  SP_SETTRIGGERORDER @TRIGGERNAME = 'TR_DEL', @ORDER='LAST', @STMTTYPE = 'DELETE';
GO

-- Transaction part
CREATE TRIGGER weather_check 
	ON WEATHER AFTER INSERT, UPDATE  
	AS   
	DECLARE @C char(10) = (SELECT w FROM INSERTED); 	 
	 IF (@C = 'Showers') 
	 BEGIN
		RAISERROR('Cannot insert showers', 10, 1);
		ROLLBACK; 
	 END; 
RETURN;          

INSERT INTO WEATHER VALUES ('Showers');
GO

-- INSTEAD OF-trigger

CREATE TRIGGER weather_INSTEAD_OF 
	ON WEATHER INSTEAD OF UPDATE 
	AS 
RAISERROR (N'Cannot update', 10, 1);
	RETURN;

-----------------------
UPDATE WEATHER set W = 'Hot' where W = 'Sun';
GO
SELECT * FROM WEATHER;
GO

-- DDL
CREATE TRIGGER table_weather_drop ON DATABASE 
	FOR DROP_TABLE
AS 
BEGIN
   PRINT 'You must ask your DBA to drop or alter tables!' 
   ROLLBACK TRANSACTION
END
GO


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

CREATE TABLE AUDIT1
     (OFFICE INT NOT NULL,
        CITY VARCHAR(15) NOT NULL,
      REGION VARCHAR(10) NOT NULL,
         MGR INT,
      TARGET DECIMAL(9,2),
       SALES DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (OFFICE));

select * from OFFICES;
select * from AUDIT1;
select * from WEATHER;
GO

--������������ ������ �8 � ���� � 2 ����
--�������� � T-SQL.
--1.	����������� ��������� DML �������� � ������������������ ����������������� ���������: 
--1.1.	��� ���������� ������ ����� ��������� ������ � ������� ����� � ������� Audit.
CREATE TRIGGER trg_AfterInsertOffice
ON OFFICES
AFTER INSERT
AS
BEGIN
    INSERT INTO AUDIT1(OFFICE, CITY, REGION, MGR, TARGET, SALES)
    SELECT i.OFFICE, 'INSERT', GETDATE()
    FROM inserted i;
END;
GO

--1.2.	��� ���������� ������ ����� ��������� ������ � ����������� ������� ����� � ������� Audit.
CREATE TRIGGER trg_AfterUpdateOffice
ON OFFICES
AFTER UPDATE
AS
BEGIN
    INSERT INTO AUDIT1(OFFICE, CITY, REGION, MGR, TARGET, SALES)
    SELECT d.OFFICE, 'UPDATE', GETDATE(), CONCAT_WS(',', d.OFFICE, d.CITY, d.REGION, d.MGR, d.TARGET, d.SALES)
    FROM deleted d;
END;
GO

--1.3.	��� �������� ������ � ����� ��������� ������ � ������� ����� � ������� Audit. 
CREATE TRIGGER trg_AfterDeleteOffice
ON OFFICES
AFTER DELETE
AS
BEGIN
    INSERT INTO AUDIT1(OFFICE, CITY, REGION, MGR, TARGET, SALES)
    SELECT d.OFFICE, 'DELETE', GETDATE(), CONCAT_WS(',', d.OFFICE, d.CITY, d.REGION, d.MGR, d.TARGET, d.SALES)
    FROM deleted d;
END;
GO

--2.	����������� ������, ������� �������������, ��� �������� ����������� ����������� ����������� �� ������������ AFTER-��������.
CREATE TABLE TestConstraint ( -- ������� ������� � ������������
    ID INT PRIMARY KEY,
    Number INT NOT NULL CHECK (Number > 0)
);
CREATE TRIGGER trg_AfterInsertTestConstraint --������� �������
ON TestConstraint
AFTER INSERT AS
BEGIN
    PRINT 'AFTER-������� ��������';
END;
-- ������, ������� ������������� �����������
-- ��� ������� ������, ������� �� ���������
INSERT INTO TestConstraint (ID, Number) VALUES (1, -1);

--3.	 ������� 3 ��������, ������������� �� ������� �������� � ������� � ����������� ��.
CREATE TRIGGER trg_FirstDelete ON OFFICES
AFTER DELETE AS
BEGIN
    PRINT '�������� 1�� ��������';
END;
GO

CREATE TRIGGER trg_SecondDelete ON OFFICES
AFTER DELETE AS
BEGIN
    PRINT '�������� 2�� ��������';
END;
GO

CREATE TRIGGER trg_ThirdDelete ON OFFICES
AFTER DELETE AS
BEGIN
    PRINT '�������� 3�� ��������';
END;
GO

-- �������������� ���������
EXEC sp_settriggerorder @triggername='trg_FirstDelete', @order='First', @stmttype='DELETE';
EXEC sp_settriggerorder @triggername='trg_SecondDelete', @order='Second', @stmttype='DELETE';
EXEC sp_settriggerorder @triggername='trg_ThirdDelete', @order='Last', @stmttype='DELETE';

--4.	����������� ������, ���������������, ��� AFTER-������� �������� ������ ����������, 
--� ������ �������� ����������� ��������, ���������������� �������.
BEGIN TRANSACTION;
-- ���������� ��������, ������� ���������� AFTER-�������
DELETE FROM OFFICES WHERE OFFICE = 13;
-- ���� ������� �������� ������, ��������� �������� ROLLBACK ����� ��������
ROLLBACK TRANSACTION;
GO

select * from OFFICES;
GO

--5.	 ������� ������� �� ���������� ��� �������������. ������������������ ����������������� ��������.
CREATE VIEW View_Offices AS -- ������� �������������
SELECT OFFICE, CITY FROM OFFICES;

CREATE TRIGGER trg_UpdateViewOffices -- ������� �� �������������
ON View_Offices
INSTEAD OF UPDATE
AS
BEGIN
    -- ����� ������ ���� ������ ���������� �������� ������� Offices � ������������ � ����������� �������������
	UPDATE OFFICES
    SET OFFICE = INSERTED.OFFICE, CITY = INSERTED.CITY
    FROM INSERTED
    WHERE OFFICES.OFFICE = INSERTED.OFFICE;
END;

-- ���������� ���������� ������������� ��� ������������ ������ ��������
UPDATE View_Offices
SET CITY='DENVER1'
WHERE OFFICE=22;

--6.	������� ������� ������ ���� ������. ������������������ ����������������� ��������.
CREATE TRIGGER trg_DatabaseScope -- ������� �� ������� CREATE_TABLE
ON DATABASE
FOR CREATE_TABLE
AS 
PRINT '������� ���� ������� � ���� ������';
GO

--7.	������� ��� ��������.
DROP TRIGGER IF EXISTS trg_AfterInsertOffice ON OFFICES;
DROP TRIGGER IF EXISTS trg_AfterUpdateOffice ON OFFICES;
DROP TRIGGER IF EXISTS trg_AfterDeleteOffice ON OFFICES;
DROP TRIGGER IF EXISTS trg_AfterInsertTestConstraint ON OFFICES;
DROP TRIGGER IF EXISTS trg_FirstDelete ON OFFICES;
DROP TRIGGER IF EXISTS trg_SecondDelete ON OFFICES;
DROP TRIGGER IF EXISTS trg_ThirdDelete ON OFFICES;
DROP TRIGGER IF EXISTS trg_UpdateViewOffices ON OFFICES;
DROP TRIGGER IF EXISTS trg_DatabaseScope ON OFFICES;
