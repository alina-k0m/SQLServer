--Подзапросы. Операции над множествами. DML. Представления

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



--1.	Напишите скрипт из следующих запросов к своей базе данных (в комментариях указывать текст задания):
--1.1.	Выбрать все заказы, выполненные определенным покупателем.
select *
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.CUST = 2103;

--1.2.	Выбрать всех покупателей в порядке уменьшения обшей стоимости заказов.
select C.CUST_NUM, 
		C.COMPANY, 
		C.CUST_REP, 
		C.CREDIT_LIMIT,
(select sum (O.AMOUNT) sum_amount
from  ORDERS O 
where O.CUST = C.CUST_NUM) sum_amount
from CUSTOMERS C 
order by sum_amount desc;

--1.3.	Выбрать все заказы, которые оформлялись менеджерами из восточного региона.
select S.NAME, ORD.ORDER_NUM, O.OFFICE, O.REGION
from SALESREPS S join OFFICES O
on S.REP_OFFICE = O.OFFICE
join ORDERS ORD
on O.MGR = ORD.REP
where O.REGION = 'Eastern';

--2й способ
select *
from ORDERS
where REP in (
select EMPL_NUM
from SALESREPS
where REP_OFFICE in (
	select OFFICE
	from OFFICES
	where REGION = 'Eastern'));

--1.4.	Найти описания товаров, приобретенные покупателем First Corp.
select C.COMPANY, P.DESCRIPTION
from CUSTOMERS C join ORDERS O
on C.CUST_REP = O.REP
join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID
where C.COMPANY = 'First Corp.';

--или

select * from PRODUCTS where PRODUCT_ID =
(select PRODUCT from ORDERS where CUST = 
(select CUST_NUM from CUSTOMERS where COMPANY = 'First Corp.'))
and
MFR_ID = (select MFR from ORDERS where  CUST =
(select CUST_NUM from CUSTOMERS where COMPANY = 'First Corp.'));

--или 


--1.5.	Выбрать всех сотрудников из Восточного региона и отсортировать по параметру Quota.
select *
from SALESREPS S join OFFICES O
on S.REP_OFFICE = O.OFFICE
where O.REGION = 'Eastern'
order by S.QUOTA asc; --desc - убывание, asc - возрастание;


select EMPL_NUM
from SALESREPS
where REP_OFFICE in (
	select OFFICE
	from OFFICES
	where REGION = 'Eastern')
order by QUOTA;

--1.6.	Выбрать заказы, сумма которых больше среднего значения.
select * from ORDERS
where AMOUNT > (select avg(amount) from ORDERS);

--1.7.1	Выбрать менеджеров, которые обслуживали одних и тех же покупателей.
select * from ORDERS where REP in 
(select * from SALESREPS where TITLE like '%Mgr%');

--1.7.2	Выбрать сотрудников, которые обслуживали одних и тех же покупателей.
select distinct o1.CUST, o1.REP from ORDERS o1 
where o1.CUST in
(select o2.CUST from ORDERS o2 where o1.REP <> o2.REP);

--1.8.	Выбрать покупателей с одинаковым кредитным лимитом.
select C1.COMPANY, C1.CREDIT_LIMIT, C2.COMPANY, C2.CREDIT_LIMIT
from CUSTOMERS C1 join CUSTOMERS C2
on C1.CREDIT_LIMIT = C2.CREDIT_LIMIT and C1.COMPANY <> C2.COMPANY  -- <> - не равно
order by C1.CREDIT_LIMIT;

select distinct C1.COMPANY, C1.CREDIT_LIMIT from CUSTOMERS C1
where C1.COMPANY in
(select C2.COMPANY from CUSTOMERS C2 where C1.CREDIT_LIMIT = C2.CREDIT_LIMIT);

--1.9.	Выбрать покупателей, сделавших заказы в один день.
select C.COMPANY, O.ORDER_DATE
from CUSTOMERS C join ORDERS O
on O.REP = C.CUST_REP
where O.ORDER_DATE = O.ORDER_DATE
order by O.ORDER_DATE;

select o1.ORDER_DATE
from ORDERS o1
where o1.ORDER_DATE in
(select o2.ORDER_DATE from ORDERS o2 where o1.ORDER_DATE = o2.ORDER_DATE);

--1.10.	Подсчитать, на какую сумму каждый офис выполнил заказы, и отсортировать их в порядке убывания.
select o.OFFICE, o.REGION, o.SALES,
	(select sum(o1.AMOUNT) sum_amount from ORDERS o1
	where o1.REP in 
		(select s.EMPL_NUM from SALESREPS s
		where s.REP_OFFICE = o.OFFICE)) sum_amount
from OFFICES o;

--1.11.	Выбрать сотрудников, которые являются начальниками (у которых есть подчиненные).
select distinct MANAGER from SALESREPS
where MANAGER is not NULL;

--1.12.	Выбрать сотрудников, которые не являются начальниками (у которых нет подчиненных).
select * from SALESREPS
where EMPL_NUM not in 
	(select distinct MANAGER from SALESREPS
	where MANAGER is not NULL);

select EMPL_NUM from SALESREPS
except
	select distinct MANAGER from SALESREPS
	where MANAGER is not NULL;

select * from SALESREPS s1
where not exists 
	(select s2.EMPL_NUM from SALESREPS s2
	where s1.EMPL_NUM = s2.MANAGER);

--1.13.	Выбрать всех продукты, продаваемые менеджерами из восточного региона.
select O.PRODUCT,
		S.NAME,
		OFS.REGION
from ORDERS O join SALESREPS S
on O.REP = S.EMPL_NUM
join OFFICES OFS
on S.REP_OFFICE = OFS.OFFICE
where OFS.REGION like 'Western';

--1.14.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по сумме заказов, которые они выполнили.
select NAME, HIRE_DATE, SALES
from SALESREPS
order by SALES asc;

--1.15.	Выбрать заказы, выполненные менеджерами из  восточного региона и отсортировать по количеству заказанного по возрастанию.
select O.PRODUCT,
		S.NAME,
		OFS.REGION,
		S.SALES
from ORDERS O join SALESREPS S
on O.REP = S.EMPL_NUM
join OFFICES OFS
on S.REP_OFFICE = OFS.OFFICE
where OFS.REGION like 'Western'
order by S.SALES asc;

--1.16.	Выбрать товары, которые дороже товаров, заказанных компанией Acme Mfg.
select * from PRODUCTS where PRICE >
	(select max(PRICE) from PRODUCTS
	where concat(MFR_ID, PRODUCT_ID) in 
		(select concat (MFR, PRODUCT) from ORDERS
		where CUST = 
			(select CUST_NUM from CUSTOMERS
			where COMPANY = 'Acme Mfg.')))
order by PRICE;

--1.17.	Выбрать товары, которые не входят в товары, заказанные компанией First Corp.
select * from PRODUCTS
where concat(MFR_ID, PRODUCT_ID) not in 
	(select concat (MFR, PRODUCT) from ORDERS
	where CUST = 
		(select CUST_NUM from CUSTOMERS
		where COMPANY = 'Acme Mfg.'));

--1.18.	Выбрать товары, которые по стоимости ниже среднего значения стоимости заказа по покупателю.
select * from PRODUCTS where PRICE < all 
	(select avg(AMOUNT) from ORDERS
	group by CUST);

----1.19.	Найти сотрудников, кто выполнял заказы в 2008, но не выполнял в 2007 (как минимум 2-мя разными способами).
select distinct REP from ORDERS
where YEAR(ORDER_DATE) = 2008
intersect
select distinct REP from ORDERS
where REP not in
(select REP from ORDERS where Year(ORDER_DATE) = 2007);

SELECT * FROM salesreps WHERE empl_num IN (
SELECT DISTINCT REP FROM orders WHERE order_date BETWEEN '2008-01-01' AND '2008-12-31'
AND REP NOT IN
(SELECT REP FROM orders  WHERE order_date BETWEEN '2007-01-01' AND '2007-12-31'));

----1.20.	Найти организации, которые не делали заказы в 2008, но делали в 2007 (как минимум 2-мя разными способами).
select distinct COMPANY from CUSTOMERS where exists
	(select * from ORDERS 
		where CUSTOMERS.CUST_NUM = ORDERS.CUST and YEAR(ORDER_DATE) = 2007)
and not exists 
	(select ORDER_DATE from ORDERS 
		where CUSTOMERS.CUST_NUM = ORDERS.CUST and YEAR(ORDER_DATE) = 2008);
	
--1.21.	Найти организации, которые делали заказы в 2008 и в 2007 (как минимум 2-мя разными способами).
select distinct REP from ORDERS
where YEAR(ORDER_DATE) = 2008
intersect
select distinct REP from ORDERS
where YEAR(ORDER_DATE) = 2007;

SELECT * FROM CUSTOMERS where cust_num IN(
SELECT DISTINCT CUST FROM ORDERS WHERE 
        (order_date BETWEEN '2008-01-01' AND '2008-12-31') 
        AND CUST IN (SELECT cust FROM orders WHERE (order_date BETWEEN '2007-01-01' AND '2007-12-31') ));
		 		 
--2.	Выполните DML операции:
--2.1.	Создайте таблицу Аудит (дата, операция, производитель, код) – она будет 
--использоваться для контроля записи в таблицу PRODUCTS.
create table Audit (audit_date date, audit_op varchar(7), audit_mfr char(3), audit_prod char(5));

insert into Audit values (getdate(), 'insert', 'ACI', '42010')

--2.2.	Добавьте во временную таблицу все товары.
select * 
into #AlinaKom_prod
from PRODUCTS;

select * from #AlinaKom_prod;

--2.3.	Добавьте в эту же временную таблицу запись о товаре, используя ограничения NULL и DEFAULT.
insert into #AlinaKom_prod (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE, QTY_ON_HAND) 
	values ('ACI', '42010', 'Some new product', default, 10);

alter table #AlinaKom_prod
	drop constraint qty_on_hand;

alter table #AlinaKom_prod add constraint def_price
	default 100 for PRICE;

alter table #AlinaKom_prod add constraint null_qty
	null for QTY_ON_HAND;

--2.4.	Добавьте в эту же временную таблицу запись о товаре, и одновременно добавьте 
--эти же данные в таблицу аудита (в столбце операция укажите INSERT, в столбце даты – текущую дату).
insert into #AlinaKom_prod (MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE, QTY_ON_HAND) 
output GETDATE(), 'insert', inserted.MFR_ID, inserted.PRODUCT_ID into Audit
values ('ACI', '42010', 'Some new product', default, 10);

--2.5.	Обновите данные о товарах во временной таблице – добавьте 20% к цене.
update #AlinaKom_prod set PRICE = 1.2 * PRICE;

--2.6.	Обновите данные о товарах, которые заказывала First Corp. во временной таблице – 
--добавьте 10% к цене.
update #AlinaKom_prod set PRICE = PRICE * 1.1 
where concat (MFR_ID, PRODUCT_ID) in (
	select concat (MFR_ID, PRODUCT_ID) from PRODUCTS p join ORDERS o
	on p.PRODUCT_ID = o.PRODUCT and p.MFR_ID = o.MFR
	join CUSTOMERS c
	on c.CUST_NUM = o.CUST
	where c.COMPANY = 'First Corp.');

--2.7.	Обновите данные о товаре во временной таблице, и одновременно добавьте эти же 
--данные в таблицу аудита (в столбце операция укажите UPDATE, в столбце даты – текущую дату).
update #AlinaKom_prod set DESCRIPTION = 'New new product'
output GETDATE(), 'update', inserted.MFR_ID, inserted.PRODUCT_ID into Audit
where MFR_ID = 'ACI' and PRODUCT_ID = '42010';

--2.8.	Удалите товары, которые заказывала First Corp. во временной таблице.
delete #AlinaKom_prod
	where concat (MFR_ID, PRODUCT_ID) in (
		select concat (MFR_ID, PRODUCT_ID) from PRODUCTS p join ORDERS o
		on p.PRODUCT_ID = o.PRODUCT and p.MFR_ID = o.MFR
		join CUSTOMERS c
		on c.CUST_NUM = o.CUST
		where c.COMPANY = 'First Corp.');

--2.9.	Удалите данные о каком-либо товаре во временной таблице, и одновременно добавьте 
--эти данные в таблицу аудита (в столбце операция укажите DELETE, в столбце даты – текущую дату).
delete #AlinaKom_prod
output GETDATE(), 'delete', deleted.MFR_ID, deleted.PRODUCT_ID into Audit
where MFR_ID = 'ACI' and PRODUCT_ID = '41001';
go

--3.	Создайте представления:
--3.1.	Покупателей, у которых есть заказы выше определенной суммы.
create view Customers31Orders as
select *
from CUSTOMERS C join ORDERS O
on C.CUST_REP = O.REP
where O.AMOUNT > 10000;
go

--3.2.	Сотрудников, у которых офисы находятся в восточном регионе.
create view Salesreps32Offices as
select S.NAME, O.OFFICE, O.REGION
from SALESREPS S join OFFICES O
on S.REP_OFFICE = O.OFFICE
where O.REGION like 'Eastern';
go

--3.3.	Заказы, оформленные в 2008 году.
create view Orders33 as
select *
from ORDERS
where year(ORDER_DATE) = 2008;
--where ORDER_DATE between '2008-01-01' and '2008-12-31';
go

--3.4.	Сотрудники, которые не оформили ни одного заказа.
create view Salesreps34 as
select *
from SALESREPS
where SALES is null;
go

--3.5.	Самый популярный товар.
drop view most_popular_product;
go

create view Products35 as
select p.MFR_ID, p.PRODUCT_ID, p.DESCRIPTION, p.PRICE, p.QTY_ON_HAND, t.sum_qty 
from PRODUCTS p join
	(select top(1) MFR, PRODUCT, sum(QTY) sum_qty
	from ORDERS
	group by MFR, PRODUCT
	order by sum_qty desc) as t
	on t.MFR = p.MFR_ID and t.PRODUCT = p.PRODUCT_ID;
go
select * from most_popular_product;

--4.	Продемонстрируйте применение DML операций над представлениями.
select * from Orders33;

insert into Orders33 values(222223, '2008-01-01', 3333, 102, 'ALI', 14523, 102, 35594);
go


--5.	Продемонстрируйте и объясните применение опций CHECK OPTION и SCHEMABINDING.
create view Orders5
as
select ORDER_DATE
from ORDERS
where year(ORDER_DATE) < 2008
WITH CHECK OPTION;
go

create view Orders5
WITH SCHEMABINDING
as
select ORDER_DATE
from dbo.ORDERS;

--6.	Продемонстрируйте пример применения операций над множествами.
SELECT CUST_NUM FROM CUSTOMERS
	UNION --объединение (повторяющиеся значения удаляются)
SELECT CUST FROM ORDERS;

SELECT CUST_NUM FROM CUSTOMERS
	INTERSECT -- пересечение строк (остаются строки, присутствующие в результатах обоих запросов)
SELECT CUST FROM ORDERS;

SELECT CUST_NUM FROM CUSTOMERS
	EXCEPT -- исключение строк (из строк первого запроса исключаются строки второго запроса)
SELECT CUST FROM ORDERS;

--7.	Продемонстрируйте применение команды TRUNCATE.
--(не нажимать)
TRUNCATE TABLE  ORDERS;-- TRUNCATE для удаления всех данных из существующей таблицы

--8.	Напишите скрипт из аналогичных запросов к базе данных по варианту. В качестве комментария укажите условие запроса.
--9.	Продемонстрируйте оба скрипта преподавателю.

