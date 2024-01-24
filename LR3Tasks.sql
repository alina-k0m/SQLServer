--3.1.	Выбрать фамилии и даты найма всех сотрудников.
select NAME, HIRE_DATE from SALESREPS;
create index idx_NAME_HIRE_DATE on SALESREPS(HIRE_DATE) include(name);

--3.2.	Выбрать все заказы, выполненные после опреденной даты.
select * from ORDERS
where ORDER_DATE > '2006-02-12';
create index idx_ORDER_DATE on ORDERS(ORDER_DATE);

--3.3.	Выбрать все офисы из определенного региона и управляемые определенным сотрудником.
select *from OFFICES
where REGION = 'Eastern' and mgr = 105;
create index idx_REGION_mgr on OFFICES(REGION, mgr);

--3.4.	Выбрать заказы, сумма которых больше определенного значения.
select *from ORDERS
where AMOUNT > 5000;
create index idx_AMOUNT on ORDERS(AMOUNT);

--3.5.	Выбрать заказы определенного покупателя.
select *from ORDERS
where CUST = 2117;
create index idx_CUST on ORDERS(CUST);

--3.6.	Выбрать заказы, сделанные в определенный период.
select * from ORDERS
where ORDER_DATE between '2006-02-12' and '2008-03-02';
create index idx_ORDER_DATE6 on ORDERS(ORDER_DATE);

--3.7.	Выбрать офисы из 12, 13 и 21 региона.
select * from OFFICES
where OFFICE in (12, 13, 21);
create index idx_OFFICE on OFFICES(OFFICE);

--3.8.	Выбрать сотрудника, у которого нет менеджера (самого главного).
select * from SALESREPS
where manager is null;
create index idx_manager on SALESREPS(manager);

--3.9.	Выбрать офисы из региона, который начинается на East.
select * from OFFICES
where region like 'East%'; 
create index idx_region on OFFICES(region);

--3.10.	Выбрать всех продукты с ценой больше определенного значения 
--и отсортировать в порядке убывания цены.
select * from PRODUCTS
where price > 500
order by price desc; --desc - убывание, asc - возрастание
create index idx_price on PRODUCTS(price);

--3.11.	Выбрать фамилии и даты найма всех сотрудников и отсортировать 
--по возрасту.
select name, HIRE_DATE from SALESREPS
order by AGE;
create index idx_NAME_HIRE_DATE11 on SALESREPS(HIRE_DATE) include(name);

--3.12.	Выбрать все заказы и отсортировать вначале по стоиомсти 
--по убыванию, а затем по количеству заказанного по возрастанию.
select * from ORDERS
order by AMOUNT desc, QTY asc; --0,0149059
create index idx_AMOUNT_QTY on ORDERS(AMOUNT, QTY);

--заказы сортируем по продавцу, потом по убыванию стоимости
select * from ORDERS
order by CUST, AMOUNT desc;
create index idx_AMOUNT_CUST on ORDERS(AMOUNT, CUST);

--3.13.	Выбрать 5 самых дорогих товаров.
select top(5) * from PRODUCTS 
order by PRICE desc;
create index idx_PRICE13 on PRODUCTS(PRICE);

--3.14.	Выбрать 3 самых молодых сотрудников.
select top(3) *from SALESREPS
order by AGE;
create index idx_AGE on SALESREPS(AGE);

--3.15.	Выбрать 20% самых дорогих заказов.
select top 20 percent *from ORDERS
order by AMOUNT desc;
create index idx_AMOUNT15 on ORDERS(AMOUNT);

--3.16.	Выбрать 11 покупателей с самым высоким кредитным лимитом.
select top(11) *from CUSTOMERS
order by CREDIT_LIMIT desc;
create index idx_CREDIT_LIMIT on CUSTOMERS(CREDIT_LIMIT);

--3.17.	Выбрать сотрудников с 4 по 7, отсортированных по дате найма.
select * from SALESREPS
order by HIRE_DATE
offset 3 rows --пропустили 3 строки, начали с 4й
fetch next 4 rows only; --взяли 4строки: 4,5,6,7
create index idx_HIRE_DATE on SALESREPS(HIRE_DATE);

--3.18.	Выбрать сотрудников с 4 по 7, отсортированных по возрасту и тех, кто с ними одного возраста.
select NAME, AGE from SALESREPS
order by AGE
offset 3 rows --пропустили 3 строки, начали с 4й
fetch next 4 rows only; --взяли 4строки: 4,5,6,7
create index idx_AGE18 on SALESREPS(AGE) include (NAME);

--3.19.	Выбрать уникальные товары в заказах.
select distinct MFR, PRODUCT from ORDERS; --distinct - уникальные позиции
create index idx_MFR_PRODUCT on ORDERS(MFR, PRODUCT);

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
create index idx_CUST20 on ORDERS(CUST);

--3.21.	Подсчитать итоговую сумму заказа для каждого покупателя.
select CUST, sum (amount) sum_amount
from ORDERS
group by CUST;
create index idx_CUST_amount on ORDERS(CUST) include (amount);

--3.22.	Подсчитать среднюю цену заказа для каждого сотрудника.
select REP, avg (amount) avg_amount
from ORDERS
group by REP;
create index idx_REP_amount on ORDERS(REP) include (amount);

--3.23.	Найти сотрудников, у которых есть заказ стоимости выше определенного значения.
select distinct REP -- distinct - если повторяются
from ORDERS
where amount > 500;
create index idx_amount_REP on ORDERS(amount) include (REP);

--3.24.	Найти количество продуктов для каждого производителя.
select MFR_ID, count(*) as products_per_mfr
from PRODUCTS
group by MFR_ID;
create index idx_MFR_ID on PRODUCTS(MFR_ID);

--3.25.	Найти самый дорогой товар каждого производителя.
select MFR_ID, max(price) as max_price_per_mfr
from PRODUCTS
group by MFR_ID;
create index idx_MFR_ID25 on PRODUCTS(MFR_ID);

--3.26.	Найти покупателей и их заказы (в результирующем наборе должны быть: 
--наименование покупателя, наименование товара, производитель, 
--количество и итоговая сумма).
select C.COMPANY,
		O.MFR,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT,
		O.ORDER_NUM,
		S.NAME
from CUSTOMERS C join ORDERS O -- join - берет данные из нескольких таблиц: CUSTOMERS и ORDERS
on C.CUST_NUM = O.CUST
join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR
join SALESREPS S
on S.EMPL_NUM = O.REP;
create index idx_COMPANY on CUSTOMERS(COMPANY);
create index idx_ORDER_NUM on ORDERS(ORDER_NUM);

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
		O.MFR,
		O.PRODUCT,
		P.DESCRIPTION,
		O.QTY,
		O.AMOUNT
from CUSTOMERS C left join ORDERS O -- join - берет данные из нескольких таблиц: CUSTOMERS и ORDERS
on C.CUST_NUM = O.CUST
left join PRODUCTS P
on O.PRODUCT = P.PRODUCT_ID and P.MFR_ID = O.MFR;
create index idx_COMPANY27 on CUSTOMERS(COMPANY);
create index idx_ORDER_NUM27 on ORDERS(ORDER_NUM);

--3.28.	Найти покупателей, у которых нет заказов.
select C.COMPANY,
		O.ORDER_NUM
from CUSTOMERS C left join ORDERS O -- join - берет данные из нескольких таблиц: CUSTOMERS и ORDERS
on C.CUST_NUM = O.CUST
where O.ORDER_NUM is null;
create index idx_COMPANY28 on CUSTOMERS(COMPANY);
create index idx_ORDER_NUM28 on ORDERS(ORDER_NUM);

--3.29.	Найти покупателей, у которых есть заказы в определенный период.
select C.CUST_NUM,
		O.ORDER_DATE
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.ORDER_DATE between '2007-12-12' and '2008-02-02';
create index idx_COMPANY29 on CUSTOMERS(COMPANY);
create index idx_ORDER_DATE_ORDER_NUM on ORDERS(ORDER_DATE) include (ORDER_NUM);

--3.30.	Найти покупателей, у которых есть заказы выше определенной суммы.
select C.CUST_NUM,
		O.AMOUNT
from CUSTOMERS C join ORDERS O
on C.CUST_NUM = O.CUST
where O.AMOUNT > 10000;


--3.31.	Найти заказы, которые оформляли менеджеры из региона EAST.
select O.ORDER_NUM,
		S.NAME,
		OFS.REGION
from ORDERS O join SALESREPS S
on O.ORDER_NUM = S.NAME
join OFFICES OFS
on S.NAME = OFS.OFFICE
where OFS.REGION like 'East%';


--3.32.	Найти товары, которые купили покупатели с кредитным лимитом больше 40000.


--3.33.	Найти всех сотрудников из региона EAST и все их заказы.


--3.34.	Найти сотрудников, которые не оформили ни одного заказа.


--3.35.	Найти сотрудников одного возраста.
select S1.NAME, S1.AGE, S2.NAME, S2.AGE
from SALESREPS as S1 join SALESREPS as S2
on S1.AGE = S2.AGE and S1.NAME <> S2.NAME; -- <> - не равно
