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

--������������ ������ �7 � ���� � 2 ����
--���������� � T-SQL.
--1.	����������� ������, ��������������� ������ � ������ ������� ����������.
SET IMPLICIT_TRANSACTIONS ON; --������������� ����� ������� ���������� (� ����� ON)
	INSERT INTO OFFICES (OFFICE, CITY, REGION, MGR, TARGET, SALES) VALUES (50, 'Minsk', 'Belarus', 200, 5000, 7500); --��������� ����� ������
select * from OFFICES;
	UPDATE OFFICES SET REGION = 'RB' WHERE OFFICE = 50; -- ���������� ����� ������� � ������� Customers
COMMIT; -- ���� �������� ������ �������, ��������� ���������
	INSERT INTO OFFICES (OFFICE, CITY, REGION, MGR, TARGET, SALES) VALUES (30, 'Brest', 'Belarus', 200, 5000, 7500); -- ���������� ��� ����� ������, �� � �������, 																							--�����������, ��� ���� OFFICE ������ ���� ����������
ROLLBACK; -- ������� ������� ������ ��-�� ������������ OFFICE
SET IMPLICIT_TRANSACTIONS OFF; -- ��������� ����� ������� ����������

----���
----1.	����������� ������, ��������������� ������ � ������ ������� ����������.
--SET IMPLICIT_TRANSACTIONS ON; --�������� ����� ������� ����������
--INSERT INTO OFFICES VALUES (60, 'Brest', 'Western', 150, 60000.00, 60000.00);
--COMMIT;

--INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00); --������� ����� ������, ����� ����� ������� ��
--ROLLBACK; --�������� �������� Grodno
--SET IMPLICIT_TRANSACTIONS OFF; --��������� ����� ������� ����������

--2.	����������� ������, ��������������� �������� ACID ����� ����������. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
BEGIN TRY
    BEGIN TRANSACTION; -- ������ ����������
    -- ������ ��������� � ���� ������
		INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00);
		INSERT INTO OFFICES VALUES (70, 'Polock', 'Western', 150, 60000.00, 60000.00);
    COMMIT TRANSACTION; -- �������� ����������
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION; -- ����� ����������
    END

    -- ����� ��������� �� ������
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

----���
----2.	����������� ������, ��������������� �������� ACID ����� ����������. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
--BEGIN TRY
--	BEGIN TRANSACTION
--		INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00);
--		INSERT INTO OFFICES VALUES (70, 'Polock', 'Western', 150, 60000.00, 60000.00);
--	COMMIT TRANSACTION               
--END TRY

--BEGIN CATCH --��� ������������� ������,����������� ���� ����
--PRINT 'There is an error: '+ 
--	  CASE
--          WHEN error_number() = 2627 THEN 'All lines should be unique' 
--          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
--	  END; 
--	 IF @@trancount > 0 PRINT @@trancount ROLLBACK TRAN ; 	  
--END CATCH

--3.	����������� ������, ��������������� ���������� ��������� SAVETRAN. � ����� CATCH ������������� 
--������ ��������������� ��������� �� �������. 
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO OFFICES VALUES (80, 'Berlin', 'Eastern', 150, 60000.00, 60000.00);
		SAVE TRANSACTION SavePointName --����� ����������
		INSERT INTO OFFICES VALUES (70, 'Grodno', 'Western', 150, 60000.00, 60000.00);
		INSERT INTO OFFICES VALUES (70, 'Polock', 'Western', 150, 60000.00, 60000.00);
	COMMIT TRANSACTION               
END TRY

BEGIN CATCH --��� ������������� ������,����������� ���� ����
PRINT 'There is an error: '+ 
	  CASE
          WHEN error_number() = 2627 THEN 'All lines should be unique' 
          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
	  END; 
	 IF @@trancount > 0 PRINT @@trancount ROLLBACK TRAN ; 	  
END CATCH

select * from OFFICES;
--4.	����������� ��� ������� A � B. ������������������ ����������������, ��������������� � ��������� ������. 
--�������� �������� ������� ���������������.
--��� ����������������� ������:
--������ A � ���������� 1:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;-- ��������� ������ �������� ��� ������������ ����������������� ������
	BEGIN TRANSACTION;
SELECT * FROM OFFICES WHERE MGR = 108; -- ������ �������
	WAITFOR DELAY '00:00:05'; -- ���� ����� ��������, ����� ������ B ��� ��������� �������/����������
COMMIT;

--������ B � ���������� 2:
BEGIN TRANSACTION;
UPDATE OFFICES SET REGION = 'Eastern' WHERE MGR = 108;-- ������� ��� ���������� ������, ������� ��� �� ������������
WAITFOR DELAY '00:00:10';-- ��������� ���������� ������ ��������� ����� ����� ������ ���������� A
COMMIT;

--��� ���������������� ������:
--������ A � ���������� 1:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;-- ��������� ������ �������� ��� ������������ ����������������� ������
	BEGIN TRANSACTION;
SELECT * FROM OFFICES WHERE MGR = 108; -- ������ �������
	WAITFOR DELAY '00:00:05'; -- ���� ����� ��������, ����� ������ B ��� ��������� �������/����������
COMMIT;

--������ B � ���������� 2:
BEGIN TRANSACTION;
UPDATE OFFICES SET REGION = 'Eastern' WHERE MGR = 108;-- ������� ��� ���������� ������, ������� ��� �� ������������
WAITFOR DELAY '00:00:10';-- ��������� ���������� ������ ��������� ����� ����� ������ ���������� A
COMMIT;

--��� ���������� ������:
--������ A � ���������� 1:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- ��������� ������ �������� ��� ������������ ����������������� ������
	BEGIN TRANSACTION
			INSERT INTO OFFICES VALUES (90, 'Belostok', 'Poland', 108, 60000.00, 60000.00);
SELECT * FROM OFFICES WHERE MGR = 108; -- ������ �������
	WAITFOR DELAY '00:00:05'; -- ���� ����� ��������, ����� ������ B ��� ��������� �������/����������
COMMIT;

--������ B � ���������� 2:
BEGIN TRANSACTION;
UPDATE OFFICES SET REGION = 'Eastern' WHERE MGR = 108;-- ������� ��� ���������� ������, ������� ��� �� ������������
WAITFOR DELAY '00:00:10';-- ��������� ���������� ������ ��������� ����� ����� ������ ���������� A
COMMIT;

--5.	����������� ������, ��������������� �������� ��������� ����������. 
BEGIN TRANSACTION; -- ������ �������� ����������
	INSERT INTO OFFICES VALUES (100, 'Podgorica', 'Montenegro', 108, 60000.00, 60000.00);
SAVE TRANSACTION SavePoint1; --����� ����������
BEGIN TRY
    INSERT INTO OFFICES VALUES (101, 'Budva', 'Montenegro', 108, 60000.00, 60000.00);-- ������
    SAVE TRANSACTION SavePoint2;-- ���� ��� ������, ������� ��������� ����� ����������
    BEGIN TRY -- ����� �������� ������� ��������
		UPDATE OFFICES SET REGION = 'Eastern' WHERE CITY = 'Budva';-- ������� ��� ���������� ������, ������� ��� �� ������������
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION SavePoint2;-- ���� ������ �� ������ ������, �� ���������� �� ����� ���������� 2
    END CATCH
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION SavePoint1;
END CATCH

COMMIT TRANSACTION; -- ���� ��� ����������� �������, ��������� ����������




	select * from OFFICES
