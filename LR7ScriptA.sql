-- Сценарий А - изучение свойств транзакций
-- Запускаем два сценария параллельно, выполняем в двух окнах - по очереди по отметкам

INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00);

----- Покажем, что уровень изолированности READ UNCOMMITTED допускает неподтвержденное чтение

-- 1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- запускаем транзакцию, Результат:

-- 3
SELECT COUNT(*) FROM OFFICES -- Результат: , налицо неподтвержденное чтение

-- 5
SELECT COUNT(*) FROM OFFICES -- Результат: , после отката транзакции В
COMMIT TRAN

----- Покажем, что уровень изолированности READ COMMITTED не допускает неподтвержденное чтение

-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- запускаем транзакцию, Результат:

-- 8
SELECT COUNT(*) FROM OFFICES -- Результат: ожидание, неподтвержденного чтения нет

-- 10
SELECT COUNT(*) FROM OFFICES -- сразу после отката транзакции В Результат: ,
COMMIT TRAN

----- Покажем, что уровень изолированности READ COMMITTED допускает неповторяющееся чтение

-- 11
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- Результат:

-- 13
SELECT COUNT(*) FROM OFFICES -- Результат:
-- пока вторая транзакция удаляла запись, данные дважды прочитались по-разному.
COMMIT TRAN

----- Покажем, что уровень изолированности REPEATABLE READ не допускает неповторяющееся чтение
INSERT INTO OFFICES VALUES (26, 'Warsaw', 'Eastern', 108, 72000.00, 81000.00); -- вернем запись
-- 14
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- Результат: 17

-- 16
COMMIT TRAN -- сразу после фиксации транзакции А в окне В
--- Строк обработано:1 - прошло выполнение оператора удаления

----- Покажем, что уровень изолированности REPEATABLE READ допускает проблему фантомных записей
INSERT INTO OFFICES VALUES (28, 'Moscow', 'Eastern', 108, 725000.00, 835915.00); -- вернем запись
-- 18
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- Результат:

-- 20
SELECT COUNT(*) FROM OFFICES -- Результат:
--- в рамках одной транзакции А два результата
COMMIT TRAN

----- Покажем, что уровень изолированности SERIALIZABLE не допускает проблему фантомных записей
-- 21
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- Результат:

-- 23
COMMIT TRAN -- после выполнения этой команды в сценарии В - Строк обработано:1

-- Установим ALLOW_SNAPSHOT_ISOLATION
USE master
GO
ALTER DATABASE B_BSTU SET ALLOW_SNAPSHOT_ISOLATION ON
GO

----- Покажем, что уровень изолированности SNAPSHOT не блокирует строки таблицы и при этом обеспечивает изолированность
-- 24
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
SELECT COUNT(*) FROM OFFICES -- Результат:
-- 26
SELECT COUNT(*) FROM OFFICES -- Результат: - результат прежний

-- 28
SELECT COUNT(*) FROM OFFICES -- Результат: - а результат все равно прежний

-- 29
COMMIT -- накатываем транзакцию А
SELECT COUNT(*) FROM OFFICES -- Результат: - изменился