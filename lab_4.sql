--1.	Напишите скрипт из следующих запросов к своей базе данных (в комментариях указывать текст задания):
--1.1.	Выбрать все заказы, выполненные определенным покупателем.
select * from CUSTOMERS; --Acme Mfg.

select * from ORDERS
where cust = (select CUST_NUM from CUSTOMERS where company = 'Acme Mfg.');

--1.2.	Выбрать всех покупателей в порядке уменьшения обшей стоимости заказов.
select  c.CUST_NUM, 
		c.COMPANY, 
		c.CUST_REP, 
		c.CREDIT_LIMIT,  
		(select sum(o.amount) sum_amount
		 from orders o
		 where o.CUST = c.CUST_NUM) sum_amount
from customers c
order by sum_amount desc;

--1.3.	Выбрать все заказы, которые оформлялись менеджерами из восточного региона.
select * 
from orders
where rep in (
select EMPL_NUM 
from SALESREPS 
where REP_OFFICE in (
		select office 
		from OFFICES 
		where region = 'Eastern'));

--1.4.	Найти описания товаров, приобретенные покупателем First Corp.
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

--1.5.	Выбрать всех сотрудников из Восточного региона и отсортировать по параметру Quota.
select *
from SALESREPS 
where REP_OFFICE in (
		select office 
		from OFFICES 
		where region = 'Eastern')
order by quota;

--1.6.	Выбрать заказы, сумма которых больше среднего значения.
select * from ORDERS
where amount > (select avg(amount) from ORDERS);

--1.7.1.	Выбрать менеджеров, которые обслуживали одних и тех же покупателей.
(select * from SALESREPS where title like '%Mgr%');

-- 1.7.2 Выбрать сотрудников, которые обслуживали одних и тех же покупателей.
select distinct o1.cust, o1.rep from orders o1
where o1.cust in
(select o2.cust from orders o2 where o1.rep <> o2.rep);

--1.8.	Выбрать покупателей с одинаковым кредитным лимитом.
select distinct c.COMPANY, c.CREDIT_LIMIT
from CUSTOMERS c
where c.COMPANY in (
	select c1.company 
	from customers c1 
	where c.CREDIT_LIMIT = c1.CREDIT_LIMIT)
order by CREDIT_LIMIT;

--1.9.	Выбрать покупателей, сделавших заказы в один день.


--1.10.	Подсчитать, на какую сумму каждый офис выполнил заказы, и отсортировать их в порядке убывания. --40063
select o.office, o.city, o.region, o.sales,
		(select sum(o1.amount) sum_amount 
			from orders o1
			 where o1.rep in (select s.empl_num from salesreps s where s.rep_office = o.office)) sum_amount
from offices o;

--1.11.	Выбрать сотрудников, которые являются начальниками (у которых есть подчиненные).
select distinct manager from salesreps --5
where manager is not null;

--1.12.	Выбрать сотрудников, которые не являются начальниками (у которых нет подчиненных). --7
select * from salesreps
where empl_num not in (select distinct manager from salesreps --5
where manager is not null); --0.0076149

select EMPL_NUM from salesreps
except
select distinct manager from salesreps 
where manager is not null;

select * from salesreps s1
where not exists (select 1 from salesreps s2 where s1.EMPL_NUM = s2.MANAGER);

--1.13.	Выбрать всех продукты, продаваемые менеджерами из восточного региона.

--1.14.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по сумме заказов, которые они выполнили.

--1.15.	Выбрать заказы, выполненные менеджерами из  восточного региона и отсортировать по количеству заказанного по возрастанию.

--1.16.	Выбрать товары, которые дороже товаров, заказанных компанией First Corp.
select * from products where price > all
	(select price from products where concat(mfr_id,product_id) in
		(select concat(mfr, product) from orders where cust = 
			(select cust_num from customers where company = 'Acme Mfg.')))
order by price;

--1.17.	Выбрать товары, которые не входят в товары, заказанные компанией First Corp.
select * from products where concat(mfr_id,product_id) not in
		(select concat(mfr, product) from orders where cust = 
			(select cust_num from customers where company = 'Acme Mfg.'));

--1.18.	Выбрать товары, которые по стоимости ниже среднего значения стоимости заказа по покупателю.
select * from products
where price < all(select avg(amount) from orders group by CUST);

--1.19.	Найти сотрудников, кто выполнял заказы в 2008, но не выполнял в 2007 (как минимум 2-мя разными способами).
--1.20.	Найти организации, которые не делали заказы в 2008, но делали в 2007 (как минимум 2-мя разными способами).
--1.21.	Найти организации, которые делали заказы в 2008 и в 2007 (как минимум 2-мя разными способами).
--2.	Выполните DML операции:
--2.1.	Создайте таблицу Аудит (дата, операция, производитель, код) – она будет использоваться для контроля записи в таблицу PRODUCTS.
--2.2.	Добавьте во временную таблицу все товары.
--2.3.	Добавьте в эту же временную таблицу запись о товаре, используя ограничения NULL и DEFAULT.
--2.4.	Добавьте в эту же временную таблицу запись о товаре, и одновременно добавьте эти же данные в таблицу аудита (в столбце операция укажите INSERT, в столбце даты – текущую дату).
--2.5.	Обновите данные о товарах во временной таблице – добавьте 20% к цене.
--2.6.	Обновите данные о товарах, которые заказывала First Corp. во временной таблице – добавьте 10% к цене.
--2.7.	Обновите данные о товаре во временной таблице, и одновременно добавьте эти же данные в таблицу аудита (в столбце операция укажите UPDATE, в столбце даты – текущую дату).
--2.8.	Удалите товары, которые заказывала First Corp. во временной таблице.
--2.9.	Удалите данные о каком-либо товаре во временной таблице, и одновременно добавьте эти данные в таблицу аудита (в столбце операция укажите DELETE, в столбце даты – текущую дату).
--3.	Создайте представления:
--3.1.	Покупателей, у которых есть заказы выше определенной суммы.
--3.2.	Сотрудников, у которых офисы находятся в восточном регионе.
--3.3.	Заказы, оформленные в 2008 году.
--3.4.	Сотрудники, которые не оформили ни одного заказа.
--3.5.	Самый популярный товар.
--4.	Продемонстрируйте применение DML операций над представлениями.
--5.	Продемонстрируйте и объясните применение опций CHECK OPTION и SCHEMABINDING.
--6.	Продемонстрируйте пример применения операций над множествами.
--7.	Продемонстрируйте применение команды TRUNCATE.
--8.	Напишите скрипт из аналогичных запросов к базе данных по варианту. В качестве комментария укажите условие запроса.
