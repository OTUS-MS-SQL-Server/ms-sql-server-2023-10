use WideWorldImporters;

-----------------------
--where - фильтрация строк по условию
--условие - логическое выражение
--для каждой строки проверяем условие 
--	true - строка попадает в выборку
--	false - не попадет
-----------------------
-- логическое выражение: true, false и неопределено (если в поле null)
select Size, * from Warehouse.StockItems where 0=1

--227 строк
select Size, * from Warehouse.StockItems

--9 строк
select Size, * from Warehouse.StockItems where Size = '1/12 scale'

--154 строки
select Size, * from Warehouse.StockItems where Size != '1/12 scale'

select Size, * from Warehouse.StockItems where Size = null --логическое выражение

-----------------------
--обработка null
--where: is null, is not null
--колонки: isnull(), coalesce()

select Size, * from Warehouse.StockItems where Size is null

select Size, ColorId, isnull(Size, 0), coalesce(Size, ColorId, -1e6), * 
from Warehouse.StockItems 
where Size is null


--isnull() vs coalesce
;with cte as (
	select 1 as val
	union all select null
)
select val, isnull(val, 1.4) as [isnull], coalesce(val, 1.4) as [coalesce]
from cte
--isnull() - преобразование к типу 1го параметра 
--coalesce() - тип данных сохраняется


----------------
--SARGable - предикаты (условия, позволяющие использовать индекс) - посмотреть индексы
--план запроса!
select StockItemID from Warehouse.StockItems where StockItemID = 10 --sargable - план запроса - index seek

select StockItemID from Warehouse.StockItems where sqrt(StockItemID) = 10 --не sargable (функция) план запроса - index scan
--по возможности - преобразовать в sargable sqrt(StockItemID) = 10 -> StockItemID = 10 * 10
select StockItemID from Warehouse.StockItems where StockItemID = 100 --не sargable (функция) план запроса - index seek


select StockItemID from Warehouse.StockItems where StockItemID between 10 and 20 --sargable поиск по индексу

--like 
select * from Warehouse.StockItems where StockItemName like 'USB%'
select * from Warehouse.StockItems where StockItemName like '%USB%'


-------------
-- несколько условий
-- условие - логическое выражение 
-- операции с логическими выражениями AND, OR, NOT
-------------
-- Нужно вывести StockItems, где цена от 350 до 500 и
-- название начинается с USB или Ride.

select RecommendedRetailPrice, *
from Warehouse.StockItems
where
    RecommendedRetailPrice between 350 and 500 --цена от 350 до 500
	AND StockItemName like 'USB%' --название начинается с USB
 	OR StockItemName like 'Ride%' --название начинается с Ride

-- почему попали строки с ценой < 350? 
--pgdn







--AND, OR - есть очередность выполнения - вначале все AND, затем OR
--смена приоритета - скобки
-- Нужно вывести StockItems, где цена от 350 до 500 и
-- название начинается с USB или Ride.
select RecommendedRetailPrice, *
from Warehouse.StockItems
where
    RecommendedRetailPrice between 350 and 500 --цена от 350 до 500
	and (StockItemName like 'USB%' --название начинается с USB
    or StockItemName like 'Ride%') --название начинается с Ride


--работа с датами
--псевдонимы или алиасы
declare @dt datetime = getdate()
select year(@dt) as [Год]  
	, [Месяц] = month(@dt)
	, datepart(quarter, @dt) as [Квартал !]
	, datename(month, @dt) as "Месяц "
	, format(@dt, 'MMMM', 'ru-ru') as [Месяц Ru]
	, convert(varchar, @dt, 104) as [Дата] 
	, datetrunc(month, @dt) as begin_of_month
	, eomonth(@dt) as end_of_month --SQL2022

--дата в условии where - удобен формат 'yyyyMMdd'
select OrderDate from Sales.Orders where OrderDate = '20150501'
select OrderDate from Sales.Orders where OrderDate = '01.05.2015'

--почему разное кол-во?





select @@language
--на уровне сеанса
SET LANGUAGE 'French'
select @@language;  --Français

select format(getdate(),'d')

SET LANGUAGE 'Russian'
select format(getdate(),'d')

