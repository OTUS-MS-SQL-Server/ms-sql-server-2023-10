--выбор базы
use WideWorldImporters;

--варианты обращения к таблице
select * from WideWorldImporters.Application.Cities
select * from Application.Cities
--select * from Cities


--* - все колонки
-- (*) с осторожностью на больших таблицах, лучше указать нужные колонки
-- сравним планы (Ctrl+M)
select * from Sales.OrderLines
select OrderID from Sales.OrderLines


--------------------------
select CityName from Application.Cities
--избавимся от дублей
select distinct CityName from Application.Cities


--------------------------
--ограничение вывода кол-ва строк (вся таблица не нужна)
--top 10 - в каком порядке выведет информацию?
select top 10 CityID, CityName, StateProvinceID from Application.Cities

-- без сортировки порядок не гарантирован
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by CityName asc, StateProvinceID desc


-- так будет работать?
select top 10 CityID, CityName, StateProvinceID from Application.Cities order by 2, 3 desc
-- pgdn





--сортировка изменится при добавлении колонок => сортировать лучше не по номеру колонки
select top 10 CityName, StateProvinceID, LastEditedBy from Application.Cities order by 2, 3 desc

--порядок сортировки зависит от типа данных
; with cte as (
	select 1 as val --число
	union all select 5
	union all select 10
)
select * from cte order by val
--все то же самое, но тип - строка
--что получим при order by val?
; with cte as (
	select '1' as val --строка
	union all select '5'
	union all select '10'
)
select * from cte order by val







-- вывести товары, входящие в 3ку самых дорогих
SELECT TOP 10 StockItemID, StockItemName, UnitPrice FROM Warehouse.StockItems ORDER BY UnitPrice DESC










SELECT TOP 3 StockItemID, StockItemName, UnitPrice FROM Warehouse.StockItems ORDER BY UnitPrice DESC

SELECT TOP 3 WITH TIES StockItemID, StockItemName, UnitPrice FROM Warehouse.StockItems ORDER BY UnitPrice DESC

-- -------------------------------
-- SELECT TOP N WITH TIES ... - выводит N строк + все строки с граничным значением столбцов сортировки
-- сортировка обязательна!!!
-- -------------------------------

------------------------------------------
-- Постраничная выборка
--сортировка обязательна 
DECLARE 
    @pagesize BIGINT = 20, -- Размер страницы
    @pagenum  BIGINT = 1;  -- Номер страницы

SELECT StockItemID, StockItemName, UnitPrice FROM Warehouse.StockItems ORDER BY UnitPrice DESC
OFFSET (@pagenum - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY
