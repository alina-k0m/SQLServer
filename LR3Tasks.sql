--3.1.	������� ������� � ���� ����� ���� �����������.
select name, HIRE_DATE from SALESREPS;

--3.2.	������� ��� ������, ����������� ����� ���������� ����.
select * from ORDERS
where ORDER_DATE > '2006-02-12';

--3.3.	������� ��� ����� �� ������������� ������� � ����������� ������������ �����������.
select *from OFFICES
where REGION = 'Eastern' and mgr = 105;

--3.4.	������� ������, ����� ������� ������ ������������� ��������.
select *from ORDERS
where AMOUNT > 5000;

--3.5.	������� ������ ������������� ����������.
select *from ORDERS
where CUST = 2117;

--3.6.	������� ������, ��������� � ������������ ������.
select * from ORDERS
where ORDER_DATE between '2006-02-12' and '2008-03-02';

--3.7.	������� ����� �� 12, 13 � 21 �������.
select * from OFFICES
where OFFICE in (12, 13, 21);

--3.8.	������� ����������, � �������� ��� ��������� (������ ��������).
select * from SALESREPS
where manager is null;

--3.9.	������� ����� �� �������, ������� ���������� �� East.
select * from OFFICES
where region like 'East%'; 

--3.10.	������� ���� �������� � ����� ������ ������������� �������� 
--� ������������� � ������� �������� ����.
select * from PRODUCTS
where price > 500
order by price desc; --desc - ��������, asc - �����������

--3.11.	������� ������� � ���� ����� ���� ����������� � ������������� 
--�� ��������.
select name, HIRE_DATE from SALESREPS
order by AGE;

--3.12.	������� ��� ������ � ������������� ������� �� ��������� 
--�� ��������, � ����� �� ���������� ����������� �� �����������.
select * from ORDERS
order by AMOUNT desc, QTY asc;

--������ ��������� �� ��������, ����� �� �������� ���������
select * from ORDERS
order by CUST, AMOUNT desc;

--3.13.	������� 5 ����� ������� �������.
select top(5) * from PRODUCTS 
order by PRICE desc;

--3.14.	������� 3 ����� ������� �����������.
select top(3) *from SALESREPS
order by AGE;

--3.15.	������� 20% ����� ������� �������.
select top 20 percent *from ORDERS
order by AMOUNT desc;

--3.16.	������� 11 ����������� � ����� ������� ��������� �������.
select top(11) *from CUSTOMERS
order by CREDIT_LIMIT desc;

--3.17.	������� ����������� � 4 �� 7, ��������������� �� ���� �����.
select * from SALESREPS
order by HIRE_DATE
offset 3 rows --���������� 3 ������, ������ � 4�
fetch next 4 rows only; --����� 4������: 4,5,6,7

--3.18.	������� ����������� � 4 �� 7, ��������������� �� �������� � ���, ��� � ���� ������ ��������.


--3.19.	������� ���������� ������ � �������.
select distinct MFR, PRODUCT from ORDERS; --distinct - ���������� �������

--��������� ���-�� ����������� � ������, ���� � ��� ������� (��������� ������)
select REP_OFFICE, 
	count(*) count_of_salesrep, --count(*) - ���������� ����������� � ������
	max(age) max_age_in_office,
	min(age) min_age_in_office
from SALESREPS
group by REP_OFFICE
order by max_age_in_office; --������������� � ������� ����������� �������� 

--������� ���� ������ �� �������������
select MFR_ID, avg(PRICE) avg_price --avg ������� ��������������
from PRODUCTS
group by MFR_ID
having avg(PRICE) > 800;

--����� ������ � ���-�� ����������� � ���, ��� ��.������� ����������� �� ��������� 40 ���
select REP_OFFICE, count (*) count_of_office_reps
from SALESREPS
group by REP_OFFICE
having avg (age) <= 40;

--����� ���-�� ����������� � �������, ��� ������ ���������� ������ 40 ���
select count (*) count_of_office_reps
from SALESREPS
where age < 40;

--���� ��������������, ������� ���� ������ ������� > 500
select MFR_ID, avg (price) as avg_price
from PRODUCTS
group by MFR_ID
having avg (price) > 500;

--3.20.	���������� ���������� ������� ��� ������� ����������.
select CUST, count (*) cust_count
from ORDERS
group by CUST;

--3.21.	���������� �������� ����� ������ ��� ������� ����������.
select CUST, sum (amount) sum_amount
from ORDERS
group by CUST;

--3.22.	���������� ������� ���� ������ ��� ������� ����������.
select REP, avg (amount) avg_amount
from ORDERS
group by REP;

--3.23.	����� �����������, � ������� ���� ����� ��������� ���� ������������� ��������.
select distinct REP -- distinct - ���� �����������
from ORDERS
where amount > 500;

--3.24.	����� ���������� ��������� ��� ������� �������������.
select MFR_ID, count(*) as products_per_mfr
from PRODUCTS
group by MFR_ID;

--3.25.	����� ����� ������� ����� ������� �������������.
select MFR_ID, max(price) as max_price_per_mfr
from PRODUCTS
group by MFR_ID;

--3.26.	����� ����������� � �� ������ (� �������������� ������ ������ ����: 
--������������ ����������, ������������ ������, �������������, 
--���������� � �������� �����).
select C.COMPANY,
		O.MFR,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT,
		S.NAME
from CUSTOMERS C join ORDERS O -- join - ����� ������ �� ���������� ������: CUSTOMERS � ORDERS
on C.CUST_NUM = O.CUST
join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR
join SALESREPS S
on S.EMPL_NUM = O.REP;


--???���������� ��� ����������, ���� ��, ������� ������ �� ��������
select C.COMPANY,
		O.MFR,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT
from CUSTOMERS C left join ORDERS O -- join - ����� ������ �� ���������� ������: CUSTOMERS � ORDERS
on C.CUST_NUM = O.CUST
left join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR
;


--� ����� ����� �������� ��������� � ���� ��� ����
select SALESREPS.NAME, 
		OFFICES.OFFICE, 
		OFFICES.CITY
from SALESREPS join OFFICES
on SALESREPS.REP_OFFICE = OFFICES.OFFICE;
-- �� �����:
select S.NAME, 
		O.OFFICE, 
		O.CITY
from SALESREPS S join OFFICES O
on S.REP_OFFICE = O.OFFICE;

--3.27.	����� ���� ����������� � �� ������.
select C.COMPANY,
		O.MFR,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT
from CUSTOMERS C left join ORDERS O -- join - ����� ������ �� ���������� ������: CUSTOMERS � ORDERS
on C.CUST_NUM = O.CUST
left join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR;

--3.28.	����� �����������, � ������� ��� �������.
select C.COMPANY,
		O.ORDER_NUM
from CUSTOMERS C left join ORDERS O -- join - ����� ������ �� ���������� ������: CUSTOMERS � ORDERS
on C.CUST_NUM = O.CUST
where O.ORDER_NUM is null;

--3.29.	����� �����������, � ������� ���� ������ � ������������ ������.
select C.CUST_NUM,
		O.ORDER_DATE
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.ORDER_DATE between '2007-12-12' and '2008-02-02';

--3.30.	����� �����������, � ������� ���� ������ ���� ������������ �����.
select C.CUST_NUM,
		O.AMOUNT
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.AMOUNT > 10000;

--3.31.	����� ������, ������� ��������� ��������� �� ������� EAST.
select O.ORDER_NUM,
		S.NAME,
		OFS.REGION
from ORDERS O join SALESREPS S
on O.ORDER_NUM = S.NAME
join OFFICES OFS
on S.NAME = OFS.OFFICE
where OFS.REGION like 'East%';

--3.32.	����� ������, ������� ������ ���������� � ��������� ������� ������ 40000.


--3.33.	����� ���� ����������� �� ������� EAST � ��� �� ������.


--3.34.	����� �����������, ������� �� �������� �� ������ ������.


--3.35.	����� ����������� ������ ��������.
select S1.NAME, S1.AGE, S2.NAME, S2.AGE
from SALESREPS as S1 join SALESREPS as S2
on S1.AGE = S2.AGE and S1.NAME <> S2.NAME; -- <> - �� �����

