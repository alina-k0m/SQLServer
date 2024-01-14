-- Сценарий В - изучение свойств транзакций
-- Запускаем два сценария параллельно, выполняем в двух окнах - по очереди по отметкам

--- 2
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE OFFICE=22 -- удаляем строку из таблицы

--- 4
ROLLBACK TRAN -- откатываем транзакцию

--- 7
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE OFFICE=26 -- удаляем строку из таблицы

--- 9
ROLLBACK TRAN -- откатываем транзакцию 

--- 12
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE OFFICE = 26 -- удаляем строку из таблицы
COMMIT TRAN

--- 15
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM OFFICES WHERE OFFICE = 26 -- удаляем строку из таблицы, результат - ожидание

--- 17
COMMIT TRAN -- завершаем транзакцию

--- 19
BEGIN TRAN
INSERT INTO OFFICES VALUES (28, 'Moscow', 'Eastern', 108, 75000.00, 80000.00); -- Строк обработано:1
COMMIT TRAN -- завершаем транзакцию

--- 22
BEGIN TRAN
INSERT INTO OFFICES VALUES (29, 'Mensk', 'Eastern', 108, 72000.00, 83000.00); -- ожидание

-- 24
COMMIT TRAN

--- 25
BEGIN TRAN 
INSERT INTO OFFICES VALUES (30, 'Kiev', 'Eastern', 108, 70000.00, 82000.00); -- выполняем вставку - Строк обработано:1

--27
COMMIT -- накатываем транзакцию В
