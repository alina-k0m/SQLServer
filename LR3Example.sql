create table ##kom_table (x int); --# - локальные временные таблицы, ## - глобальные временные таблицы
drop table ##kom_table;

select *
into ##kom_table1
from OFFICES;

select * from ##kom_table1;



select *
from SALESREPS S join OFFICES O
on S.REP_OFFICE = O.OFFICE;


select * from SALESREPS
where REP_OFFICE in (select OFFICE from OFFICES
						where REGION = 'Eastern');


--select, from, having
select REP_OFFICE, avg(SALES) avg_sales
from SALESREPS
group by REP_OFFICE;


--сотрудники, которые по SALES работают выше среднего
select S.EMPL_NUM, S.NAME, S.SALES, S.REP_OFFICE, S1.avg_sales
from SALESREPS S join (select REP_OFFICE, avg(SALES) avg_sales
						from SALESREPS
						group by REP_OFFICE) S1
on S.REP_OFFICE = S1.REP_OFFICE
where S.SALES > S1.avg_sales;



select S.EMPL_NUM, S.NAME, S.SALES, S.REP_OFFICE
from SALESREPS S
where S.SALES > (select avg(S1.SALES) from SALESREPS S1 where S1.REP_OFFICE = S.REP_OFFICE);




--операции со множетсвами
--union, union all, except, intersect
select NAME
from SALESREPS 
where REP_OFFICE in (11, 12, 13)
union
select TITLE
from SALESREPS 
where REP_OFFICE in (11, 22);



--View
create view eastern_salesreps
as
select * from SALESREPS
where REP_OFFICE in (select OFFICE from OFFICES
						where REGION = 'Eastern')
--with check option; --чтобы запретить добавлять данные, не удовлетворяющие условию

select *from eastern_salesreps;

insert into eastern_salesreps values (122, 'Никита', 29, 22, 'SQL Dev', getdate(), 102, 100000, 0);

create view 