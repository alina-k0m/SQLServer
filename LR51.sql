----процедуры - есл сосредоточены на процессе
---- функция - если состредоточены на результате

----create procedure print_my_name
----as
----begin
----	print 'print_my_name';
----end;
----go

----exec print_my_name;

--create procedure print_my_name @v_name varchar(10)
--as
--begin
--	print 'Hello, ' + @v_name;
--end;
--go



--create procedure print_my_name_2 @v_name varchar(10)
--as 

create procedure new_product @v_mfr char(3), 
							@v_prod char(5), 
							@v_descr varchar(20),
							@v_price money,
							@v_qoh int
as 
begin
begin try
	insert into PRODUCTS values (@v_mfr, @v_prod, @v_descr, @v_price, @v_qoh);
end try
begin catch
	if ( = 2627)
	print 'Some error! Primary key dublicate'
	else
	print 'Unknown error'
end catch
end;
go

exec new_product 'ACI', '45007', 'New product', 100, 123;