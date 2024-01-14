--процессы

create procedure update_product @v_mfr_id char (3),
								@v_product_id char(5),
								@v_description varchar(20),
								@v_price money,
								@v_qty_on_hand int
as
begin
--if @v_description is null
--	if @v_price is null
--			update PRODUCTS
--			set QTY_ON_HAND = @v_qty_on_hand
--			where MFR_ID = @v_mfr_id and PRODUCT_ID = @v_product_id;
--		else
--			update PRODUCTS
--			set QTY_ON_HAND = @v_qty_on_hand, PRICE = @v_price
--			where MFR_ID = @v_mfr_id and PRODUCT_ID = @v_product_id;
--		else if @v_qty_on_hand is null
--			update PRODUCTS
--			set PRICE = @v_price
--			where MFR_ID = @v_mfr_id and PRODUCT_ID = @v_product_id;
--		else
--			update PRODUCTS
--			set DESCRIPTION = @v_description, 
--				QTY_ON_HAND = @v_qty_on_hand, 
--				PRICE = @v_price
--			where MFR_ID = @v_mfr_id and PRODUCT_ID = @v_product_id;
	update PRODUCTS
	set DESCRIPTION = isNull(@v_description, DESCRIPTION),
		PRICE = isNull(@v_price, PRICE),
		QTY_ON_HAND = isNull(@v_qty_on_hand, QTY_ON_HAND)
	where MFR_ID = @v_mfr_id and PRODUCT_ID = @v_product_id;
end;

--alter procedure update_product @v_mfr_id char(3), --								@v_product_id char(5),--								@v_description varchar(20),--								@v_price money,--								@v_qty_on_hand int--as--begin--	update products --			set description = isNull(@v_description, description),--				price = isNull(@v_price, price),--				QTY_ON_HAND = isNull(@v_qty_on_hand, QTY_ON_HAND)--			where mfr_id = @v_mfr_id and product_id = @v_product_id;--end;


exec update_product 'ACI', '45678', 'Update product', 230, 12;





--функции
create function sum_num (@a int, @b int) returns int
begin
	declare @rc int = 0; 
	set @rc = @a + @b;
	return @rc;
end;

select dbo.sum_num(4,5);


--средняя стоимость заказа по покупателю
create function avg_order_by_cust (@v_cust int) returns decimal(9, 2)
begin
	declare @rc int = -1;
	declare @vc int;
	set @vc = (select CUST_NUM 
				from CUSTOMERS 
				where CUST_NUM = @v_cust);
	if @vc is not null 
			set @rc = isNull((select avg(AMOUNT) from ORDERS where CUST = @vc),avg_order_by_cust);
	return @rc;
end;
go

select dbo.avg_order_by_cust(3101);

select CUST_NUM, COMPANY, CUST_REP, CREDIT_LIMIT, dbo.avg_order_by_cust(CUST_NUM) from CUSTOMERS;


--вернуть список заказов для каждого покупателя
create function order_list_by_cust (@v_cust int) returns table
as
	return
		select * from ORDERS where CUST = @v_cust;
go
select * from dbo.order_list_by_cust (2102);
go


--ф-я, кот. отображает товары выше определенной цены
create function products_more_expensive_than_p(@p money) returns table
as 
	return
		select top(100) * from PRODUCTS where PRICE > @p 
		order by PRICE desc;
go

select * from dbo.products_more_expensive_than_p(700);
