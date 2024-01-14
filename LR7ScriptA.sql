-- �������� � - �������� ������� ����������
-- ��������� ��� �������� �����������, ��������� � ���� ����� - �� ������� �� ��������

INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00);

----- �������, ��� ������� ��������������� READ UNCOMMITTED ��������� ���������������� ������

-- 1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ��������� ����������, ���������:

-- 3
SELECT COUNT(*) FROM OFFICES -- ���������: , ������ ���������������� ������

-- 5
SELECT COUNT(*) FROM OFFICES -- ���������: , ����� ������ ���������� �
COMMIT TRAN

----- �������, ��� ������� ��������������� READ COMMITTED �� ��������� ���������������� ������

-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ��������� ����������, ���������:

-- 8
SELECT COUNT(*) FROM OFFICES -- ���������: ��������, ����������������� ������ ���

-- 10
SELECT COUNT(*) FROM OFFICES -- ����� ����� ������ ���������� � ���������: ,
COMMIT TRAN

----- �������, ��� ������� ��������������� READ COMMITTED ��������� ��������������� ������

-- 11
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ���������:

-- 13
SELECT COUNT(*) FROM OFFICES -- ���������:
-- ���� ������ ���������� ������� ������, ������ ������ ����������� ��-�������.
COMMIT TRAN

----- �������, ��� ������� ��������������� REPEATABLE READ �� ��������� ��������������� ������
INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00); -- ������ ������
-- 14
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ���������: 17

-- 16
COMMIT TRAN -- ����� ����� �������� ���������� � � ���� �
--- ����� ����������:1 - ������ ���������� ��������� ��������

----- �������, ��� ������� ��������������� REPEATABLE READ ��������� �������� ��������� �������
INSERT INTO OFFICES VALUES (28, 'Moscow', 'Eastern', 108, 725000.00, 835915.00); -- ������ ������
-- 18
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ���������:

-- 20
SELECT COUNT(*) FROM OFFICES -- ���������:
--- � ������ ����� ���������� � ��� ����������
COMMIT TRAN

----- �������, ��� ������� ��������������� SERIALIZABLE �� ��������� �������� ��������� �������
-- 21
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ���������:

-- 23
COMMIT TRAN -- ����� ���������� ���� ������� � �������� � - ����� ����������:1

-- ��������� ALLOW_SNAPSHOT_ISOLATION
USE master
GO
ALTER DATABASE B_BSTU SET ALLOW_SNAPSHOT_ISOLATION ON
GO

----- �������, ��� ������� ��������������� SNAPSHOT �� ��������� ������ ������� � ��� ���� ������������ ���������������
-- 24
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- ���������:
-- 26
SELECT COUNT(*) FROM OFFICES -- ���������: - ��������� �������

-- 28
SELECT COUNT(*) FROM OFFICES -- ���������: - � ��������� ��� ����� �������

-- 29
COMMIT -- ���������� ���������� �
SELECT COUNT(*) FROM OFFICES -- ���������: - ���������