--3.1.	Выбрать фамилии и даты найма всех сотрудников.
select name, HIRE_DATE from SALESREPS;

--3.2.	Выбрать все заказы, выполненные после опреденной даты.
select * from ORDERS
where ORDER_DATE > '2006-02-12';

--3.3.	Выбрать все офисы из определенного региона и управляемые определенным сотрудником.
select *from OFFICES
where REGION = 'Eastern' and mgr = 105;

--3.4.	Выбрать заказы, сумма которых больше определенного значения.
select *from ORDERS
where AMOUNT > 5000;

--3.5.	Выбрать заказы определенного покупателя.
select *from ORDERS
where CUST = 2117;

--3.6.	Выбрать заказы, сделанные в определенный период.
select * from ORDERS
where ORDER_DATE between '2006-02-12' and '2008-03-02';

--3.7.	Выбрать офисы из 12, 13 и 21 региона.
select * from OFFICES
where OFFICE in (12, 13, 21);

--3.8.	Выбрать сотрудника, у которого нет менеджера (самого главного).
select * from SALESREPS
where manager is null;

--3.9.	Выбрать офисы из региона, который начинается на East.
select * from OFFICES
where region like 'East%'; 

--3.10.	Выбрать всех продукты с ценой больше определенного значения 
--и отсортировать в порядке убывания цены.
select * from PRODUCTS
where price > 500
order by price desc; --desc - убывание, asc - возрастание

--3.11.	Выбрать фамилии и даты найма всех сотрудников и отсортировать 
--по возрасту.
select name, HIRE_DATE from SALESREPS
order by AGE;

--3.12.	Выбрать все заказы и отсортировать вначале по стоиомсти 
--по убыванию, а затем по количеству заказанного по возрастанию.
select * from ORDERS
order by AMOUNT desc, QTY asc;

--заказы сортируем по продавцу, потом по убыванию стоимости
select * from ORDERS
order by CUST, AMOUNT desc;

--3.13.	Выбрать 5 самых дорогих товаров.
select top(5) * from PRODUCTS 
order by PRICE desc;

--3.14.	Выбрать 3 самых молодых сотрудников.
select top(3) *from SALESREPS
order by AGE;

--3.15.	Выбрать 20% самых дорогих заказов.
select top 20 percent *from ORDERS
order by AMOUNT desc;

--3.16.	Выбрать 11 покупателей с самым высоким кредитным лимитом.
select top(11) *from CUSTOMERS
order by CREDIT_LIMIT desc;

--3.17.	Выбрать сотрудников с 4 по 7, отсортированных по дате найма.
select * from SALESREPS
order by HIRE_DATE
offset 3 rows --пропустили 3 строки, начали с 4й
fetch next 4 rows only; --взяли 4строки: 4,5,6,7

--3.18.	Выбрать сотрудников с 4 по 7, отсортированных по возрасту и тех, кто с ними одного возраста.


--3.19.	Выбрать уникальные товары в заказах.
select distinct MFR, PRODUCT from ORDERS; --distinct - уникальные позиции

--посчитать кол-во сотрудников в отделе, макс и мин возраст (групповой запрос)
select REP_OFFICE, 
	count(*) count_of_salesrep, --count(*) - количество сотрудников в отделе
	max(age) max_age_in_office,
	min(age) min_age_in_office
from SALESREPS
group by REP_OFFICE
order by max_age_in_office; --отсортировать в порядке возрастания возраста 

--средняя цена товара по производителю
select MFR_ID, avg(PRICE) avg_price --avg среднее арифметическое
from PRODUCTS
group by MFR_ID
having avg(PRICE) > 800;

--найти отделы и кол-во сотрудников в них, где ср.возраст сотрудников не превышает 40 лет
select REP_OFFICE, count (*) count_of_office_reps
from SALESREPS
group by REP_OFFICE
having avg (age) <= 40;

--найти кол-во сотрудников в отделах, где работю сотрудники младше 40 лет
select count (*) count_of_office_reps
from SALESREPS
where age < 40;

--дать производителей, средняя цена товара которых > 500
select MFR_ID, avg (price) as avg_price
from PRODUCTS
group by MFR_ID
having avg (price) > 500;

--3.20.	Подсчитать количество заказов для каждого покупателя.
select CUST, count (*) cust_count
from ORDERS
group by CUST;

--3.21.	Подсчитать итоговую сумму заказа для каждого покупателя.
select CUST, sum (amount) sum_amount
from ORDERS
group by CUST;

--3.22.	Подсчитать среднюю цену заказа для каждого сотрудника.
select REP, avg (amount) avg_amount
from ORDERS
group by REP;

--3.23.	Найти сотрудников, у которых есть заказ стоимости выше определенного значения.
select distinct REP -- distinct - если повторяются
from ORDERS
where amount > 500;

--3.24.	Найти количество продуктов для каждого производителя.
select MFR_ID, count(*) as products_per_mfr
from PRODUCTS
group by MFR_ID;

--3.25.	Найти самый дорогой товар каждого производителя.
select MFR_ID, max(price) as max_price_per_mfr
from PRODUCTS
group by MFR_ID;

--3.26.	Найти покупателей и их заказы (в результирующем наборе должны быть: 
--наименование покупателя, наименование товара, производитель, 
--количество и итоговая сумма).
select C.COMPANY,
		O.MFR,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT,
		S.NAME
from CUSTOMERS C join ORDERS O -- join - берет данные из нескольких таблиц: CUSTOMERS и ORDERS
on C.CUST_NUM = O.CUST
join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR
join SALESREPS S
on S.EMPL_NUM = O.REP;


--???добавились все покупатели, даже те, которые ничего не покупали
select C.COMPANY,
		O.MFR,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT
from CUSTOMERS C left join ORDERS O -- join - берет данные из нескольких таблиц: CUSTOMERS и ORDERS
on C.CUST_NUM = O.CUST
left join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR
;


--в каком офисе работает сотрудник и инфа про офис
select SALESREPS.NAME, 
		OFFICES.OFFICE, 
		OFFICES.CITY
from SALESREPS join OFFICES
on SALESREPS.REP_OFFICE = OFFICES.OFFICE;
-- же самое:
select S.NAME, 
		O.OFFICE, 
		O.CITY
from SALESREPS S join OFFICES O
on S.REP_OFFICE = O.OFFICE;

--3.27.	Найти всех покупателей и их заказы.
select C.COMPANY,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT
from CUSTOMERS C left join ORDERS O -- join - берет данные из нескольких таблиц: CUSTOMERS и ORDERS
on C.CUST_NUM = O.CUST
left join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR;

--3.28.	Найти покупателей, у которых нет заказов.
select C.COMPANY,
		O.ORDER_NUM
from CUSTOMERS C left join ORDERS O -- join - берет данные из нескольких таблиц: CUSTOMERS и ORDERS
on C.CUST_NUM = O.CUST
where O.ORDER_NUM is null;

--3.29.	Найти покупателей, у которых есть заказы в определенный период.
select C.CUST_NUM,
		O.ORDER_DATE
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.ORDER_DATE between '2007-11-11' and '2008-02-02';

--3.30.	Найти покупателей, у которых есть заказы выше определенной суммы.
select C.CUST_NUM,
		O.AMOUNT
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.AMOUNT > 10000;

--3.31.	Найти заказы, которые оформляли менеджеры из региона EAST.
select O.ORDER_NUM,
		S.EMPL_NUM,
		S.NAME,
		OFFS.REGION
from ORDERS O join SALESREPS S
on O.REP = S.EMPL_NUM
join OFFICES OFFS
on S.REP_OFFICE = OFFS.OFFICE
where OFFS.REGION like 'East%';

--3.32.	Найти товары, которые купили покупатели с кредитным лимитом больше 40000.
--select *
--from ORDERS O join CUSTOMERS C
--on C.CUST_NUM = O.CUST
--where C.CREDIT_LIMIT > 40000;
select distinct P,MFR_ID,
		P.PRODUCT_ID,
		P.DESCRIPTION,
		P.PRICE
from ORDERS O join PRODUCTS P
on O.MFR = P.MFR_ID and O.PRODUCT = P.PRODUCT_ID
join CUSTOMERS C
on C.CUST_NUM = O.CUST
where C.CREDIT_LIMIT > 40000;


--3.33.	Найти всех сотрудников из региона EAST и все их заказы.
select * 
from SALESREPS S join OFFICES OFFS
on S.REP_OFFICE = OFFS.OFFICE
join ORDERS O
on O.REP = S.EMPL_NUM
where REGION = 'Eastern';

--???3.34.	Найти сотрудников, которые не оформили ни одного заказа.
--select * 
--from SALESREPS S join ORDERS O
--on O.REP = S.MANAGER
--where QUOTA is null;
select SALESREPS.EMPL_NUM,
		ORDERS.ORDER_NUM
from SALESREPS left join ORDERS
on SALESREPS.EMPL_NUM = ORDERS.REP
where ORDERS.ORDER_NUM is null;

--3.35.	Найти сотрудников одного возраста.
select S1.NAME, S1.AGE, S2.NAME, S2.AGE
from SALESREPS as S1 join SALESREPS as S2
on S1.AGE = S2.AGE and S1.NAME <> S2.NAME; -- <> - не равно

--4.	Поместить результирующие наборы из запроса 3.30 в локальную временную таблицу.
select C.CUST_NUM,
		O.AMOUNT
into #kom_table1
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.AMOUNT > 10000;

--5.	Просмотреть данные из локальной временной таблицы.
select * from #kom_table1;

--6.	Поместить результирующие наборы из запроса 3.31 в глобальную временную таблицу.
select O.ORDER_NUM,
		S.EMPL_NUM,
		S.NAME,
		OFFS.REGION
into ##kom_table2
from ORDERS O join SALESREPS S
on O.REP = S.MANAGER
join OFFICES OFFS
on S.REP_OFFICE = OFFS.OFFICE
where OFFS.REGION like 'East%';

--7.	Просмотреть данные из глобальных временных таблиц.
select * from ##kom_table2;

--8.	Написать скрипт из аналогичных запросов к базе данных по варианту. В качестве комментария указать условие запроса.


--9.	Продемонстрировать оба скрипта преподавателю.

