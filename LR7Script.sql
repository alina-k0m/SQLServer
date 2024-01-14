-- не€вна€ транзакци€
create table WEATHER (w varchar(10) unique);

DECLARE @flag int = 2 ; --объ€вл€ем переменную
SET IMPLICIT_TRANSACTIONS ON; --устанавливаем режим не€вных транзакций (в режим ON)
INSERT weather VALUES ('Sun'), ('Rain'), ('Wind');
IF @flag = 2  COMMIT ELSE ROLLBACK; -- выполнитс€ вставка в таблицу, если значение флага 2

SELECT * FROM weather;  -- проверка

INSERT weather VALUES ('Snow');

SET IMPLICIT_TRANSACTIONS OFF; --отключаем режим не€вных транзакций (в режим OFF)

delete WEATHER where w ='Rain';

-- атомарность €вной транзакции - выполн€ютс€ все операторы или ни один

BEGIN TRY
	BEGIN TRANSACTION
	 DELETE  weather WHERE w = 'Sun';
	 INSERT weather VALUES ('Rain');
	COMMIT TRAN               
END TRY
		
BEGIN CATCH
PRINT 'There is an error: '+ 
	  CASE
          WHEN error_number() = 2627 THEN 'All lines should be unique' 
          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
	  END; 
	 IF @@trancount > 0 PRINT @@trancount ROLLBACK TRAN ; 	  
END CATCH

SELECT * FROM weather;

-- —оздание контрольных точек
	 INSERT weather VALUES ('Sun');
	 INSERT weather VALUES ('Foggy');


DECLARE @point VARCHAR(6)
BEGIN TRY
	BEGIN TRANSACTION
	 DELETE  weather WHERE w = 'Sun';
	 SET @point = 'point1'; 
	 SAVE TRAN @point;  
	 INSERT weather VALUES ('Rain');
	 SET @point = 'point2'; 
	 SAVE TRAN @point;  
	 INSERT weather VALUES ('Rain');
	COMMIT TRAN               
END TRY
		
BEGIN CATCH
PRINT 'There is an error: '+ 
	  CASE
          WHEN error_number() = 2627 THEN 'All lines should be unique' 
          ELSE 'Error: '+ cast(error_number() as  varchar(5))+ error_message()  
	  END; 
	 IF @@trancount > 0 
	 BEGIN
	   PRINT 'Control point: '+ @point;
	   ROLLBACK TRAN @point;                                  
	   COMMIT TRAN;                  
	END;     
   END CATCH;	  

SELECT * FROM weather;

--- ¬ложенные транзакции
	 DELETE  weather WHERE w = 'Snow';

PRINT 'TRANCOUNT 1 = ' + cast(@@TRANCOUNT as varchar (20)); 
BEGIN TRAN													--  ¬Ќ≈ЎЌяя “–јЌ«ј ÷»я   
 INSERT weather VALUES ('Sun');
 PRINT 'TRANCOUNT 2 = ' + cast(@@TRANCOUNT as varchar (20)); 
 BEGIN TRAN													--  ¬Ќ”“–≈ЌЌяя “–јЌ«ј ÷»я  
	UPDATE weather SET w = 'Snow' WHERE w = 'Rain';
	PRINT 'TRANCOUNT 3 = ' + cast(@@TRANCOUNT as varchar (20)); 
 COMMIT;													--  ¬Ќ”“–≈ЌЌяя “–јЌ«ј ÷»я
 PRINT 'TRANCOUNT 4 = ' + cast(@@TRANCOUNT as varchar (20));                                               
 IF @@TRANCOUNT > 0  
ROLLBACK;													--  ¬Ќ≈ЎЌяя “–јЌ«ј ÷»я 
PRINT 'TRANCOUNT 5 = ' + cast(@@TRANCOUNT as varchar (20));  

