-- �������� � - �������� ������� ����������
-- ��������� ��� �������� �����������, ��������� � ���� ����� - �� ������� �� ��������

--- 2
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE OFFICE=22 -- ������� ������ �� �������

--- 4
ROLLBACK TRAN -- ���������� ����������

--- 7
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE OFFICE=26 -- ������� ������ �� �������

--- 9
ROLLBACK TRAN -- ���������� ���������� 

--- 12
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE OFFICE = 26 -- ������� ������ �� �������
COMMIT TRAN

--- 15
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM OFFICES WHERE OFFICE = 26 -- ������� ������ �� �������, ��������� - ��������

--- 17
COMMIT TRAN -- ��������� ����������

--- 19
BEGIN TRAN
INSERT INTO OFFICES VALUES (28, 'Moscow', 'Eastern', 108, 75000.00, 80000.00); -- ����� ����������:1
COMMIT TRAN -- ��������� ����������

--- 22
BEGIN TRAN
INSERT INTO OFFICES VALUES (29, 'Mensk', 'Eastern', 108, 72000.00, 83000.00); -- ��������

-- 24
COMMIT TRAN

--- 25
BEGIN TRAN 
INSERT INTO OFFICES VALUES (30, 'Kiev', 'Eastern', 108, 70000.00, 82000.00); -- ��������� ������� - ����� ����������:1

--27
COMMIT -- ���������� ���������� �
