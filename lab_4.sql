--1.	�������� ������ �� ��������� �������� � ����� ���� ������ (� ������������ ��������� ����� �������):
--1.1.	������� ��� ������, ����������� ������������ �����������.
select * from CUSTOMERS; --Acme Mfg.

select * from ORDERS
where cust = (select CUST_NUM from CUSTOMERS where company = 'Acme Mfg.');

--1.2.	������� ���� ����������� � ������� ���������� ����� ��������� �������.
select  c.CUST_NUM, 
		c.COMPANY, 
		c.CUST_REP, 
		c.CREDIT_LIMIT,  
		(select sum(o.amount) sum_amount
		 from orders o
		 where o.CUST = c.CUST_NUM) sum_amount
from customers c
order by sum_amount desc;

--1.3.	������� ��� ������, ������� ����������� ����������� �� ���������� �������.
select * 
from orders
where rep in (
select EMPL_NUM 
from SALESREPS 
where REP_OFFICE in (
		select office 
		from OFFICES 
		where region = 'Eastern'));

--1.4.	����� �������� �������, ������������� ����������� First Corp.
select description from products where PRODUCT_ID = 
(select product from orders where cust = (
select CUST_NUM from CUSTOMERS where company = 'First Corp.'))
and
mfr_ID = (select mfr from orders where cust = (
select CUST_NUM from CUSTOMERS where company = 'First Corp.'));

select description 
from products 
where concat(PRODUCT_ID, mfr_ID) = 
(select concat(product,mfr)  from orders where cust = (
select CUST_NUM from CUSTOMERS where company = 'First Corp.'));

--1.5.	������� ���� ����������� �� ���������� ������� � ������������� �� ��������� Quota.
select *
from SALESREPS 
where REP_OFFICE in (
		select office 
		from OFFICES 
		where region = 'Eastern')
order by quota;

--1.6.	������� ������, ����� ������� ������ �������� ��������.
select * from ORDERS
where amount > (select avg(amount) from ORDERS);

--1.7.1.	������� ����������, ������� ����������� ����� � ��� �� �����������.
(select * from SALESREPS where title like '%Mgr%');

-- 1.7.2 ������� �����������, ������� ����������� ����� � ��� �� �����������.
select distinct o1.cust, o1.rep from orders o1
where o1.cust in
(select o2.cust from orders o2 where o1.rep <> o2.rep);

--1.8.	������� ����������� � ���������� ��������� �������.
select distinct c.COMPANY, c.CREDIT_LIMIT
from CUSTOMERS c
where c.COMPANY in (
	select c1.company 
	from customers c1 
	where c.CREDIT_LIMIT = c1.CREDIT_LIMIT)
order by CREDIT_LIMIT;

--1.9.	������� �����������, ��������� ������ � ���� ����.


--1.10.	����������, �� ����� ����� ������ ���� �������� ������, � ������������� �� � ������� ��������. --40063
select o.office, o.city, o.region, o.sales,
		(select sum(o1.amount) sum_amount 
			from orders o1
			 where o1.rep in (select s.empl_num from salesreps s where s.rep_office = o.office)) sum_amount
from offices o;

--1.11.	������� �����������, ������� �������� ������������ (� ������� ���� �����������).
select distinct manager from salesreps --5
where manager is not null;

--1.12.	������� �����������, ������� �� �������� ������������ (� ������� ��� �����������). --7
select * from salesreps
where empl_num not in (select distinct manager from salesreps --5
where manager is not null); --0.0076149

select EMPL_NUM from salesreps
except
select distinct manager from salesreps 
where manager is not null;

select * from salesreps s1
where not exists (select 1 from salesreps s2 where s1.EMPL_NUM = s2.MANAGER);

--1.13.	������� ���� ��������, ����������� ����������� �� ���������� �������.

--1.14.	������� ������� � ���� ����� ���� ����������� � ������������� �� ����� �������, ������� ��� ���������.

--1.15.	������� ������, ����������� ����������� ��  ���������� ������� � ������������� �� ���������� ����������� �� �����������.

--1.16.	������� ������, ������� ������ �������, ���������� ��������� First Corp.
select * from products where price > all
	(select price from products where concat(mfr_id,product_id) in
		(select concat(mfr, product) from orders where cust = 
			(select cust_num from customers where company = 'Acme Mfg.')))
order by price;

--1.17.	������� ������, ������� �� ������ � ������, ���������� ��������� First Corp.
select * from products where concat(mfr_id,product_id) not in
		(select concat(mfr, product) from orders where cust = 
			(select cust_num from customers where company = 'Acme Mfg.'));

--1.18.	������� ������, ������� �� ��������� ���� �������� �������� ��������� ������ �� ����������.
select * from products
where price < all(select avg(amount) from orders group by CUST);

--1.19.	����� �����������, ��� �������� ������ � 2008, �� �� �������� � 2007 (��� ������� 2-�� ������� ���������).
--1.20.	����� �����������, ������� �� ������ ������ � 2008, �� ������ � 2007 (��� ������� 2-�� ������� ���������).
--1.21.	����� �����������, ������� ������ ������ � 2008 � � 2007 (��� ������� 2-�� ������� ���������).
--2.	��������� DML ��������:
--2.1.	�������� ������� ����� (����, ��������, �������������, ���) � ��� ����� �������������� ��� �������� ������ � ������� PRODUCTS.
--2.2.	�������� �� ��������� ������� ��� ������.
--2.3.	�������� � ��� �� ��������� ������� ������ � ������, ��������� ����������� NULL � DEFAULT.
--2.4.	�������� � ��� �� ��������� ������� ������ � ������, � ������������ �������� ��� �� ������ � ������� ������ (� ������� �������� ������� INSERT, � ������� ���� � ������� ����).
--2.5.	�������� ������ � ������� �� ��������� ������� � �������� 20% � ����.
--2.6.	�������� ������ � �������, ������� ���������� First Corp. �� ��������� ������� � �������� 10% � ����.
--2.7.	�������� ������ � ������ �� ��������� �������, � ������������ �������� ��� �� ������ � ������� ������ (� ������� �������� ������� UPDATE, � ������� ���� � ������� ����).
--2.8.	������� ������, ������� ���������� First Corp. �� ��������� �������.
--2.9.	������� ������ � �����-���� ������ �� ��������� �������, � ������������ �������� ��� ������ � ������� ������ (� ������� �������� ������� DELETE, � ������� ���� � ������� ����).
--3.	�������� �������������:
--3.1.	�����������, � ������� ���� ������ ���� ������������ �����.
--3.2.	�����������, � ������� ����� ��������� � ��������� �������.
--3.3.	������, ����������� � 2008 ����.
--3.4.	����������, ������� �� �������� �� ������ ������.
--3.5.	����� ���������� �����.
--4.	����������������� ���������� DML �������� ��� ���������������.
--5.	����������������� � ��������� ���������� ����� CHECK OPTION � SCHEMABINDING.
--6.	����������������� ������ ���������� �������� ��� �����������.
--7.	����������������� ���������� ������� TRUNCATE.
--8.	�������� ������ �� ����������� �������� � ���� ������ �� ��������. � �������� ����������� ������� ������� �������.
