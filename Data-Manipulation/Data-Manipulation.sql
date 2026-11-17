--ЛАБА 10
--1.1
-- Объявляем и инициализируем переменные
DECLARE @OrderDate datetime = GETDATE() -- Текущая дата
DECLARE @DueDate datetime = DATEADD(day, 7, @OrderDate) --Дата оплаты
DECLARE @CustomerID int = 1
DECLARE @SalesOrderID int
-- Добавляем новый заказ в таблицу заголовков заказов
INSERT INTO SalesLT.SalesOrderHeader
    (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES
    (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5')
SET @SalesOrderID = SCOPE_IDENTITY()
PRINT @SalesOrderID

--1.2
-- Объявляем переменные для хранения информации о товаре
DECLARE @ProductID int = 760
DECLARE @OrderQty smallint = 1
DECLARE @UnitPrice money = 782.99
-- Проверяем, существует ли заказ с указанным идентификатором
IF EXISTS
(
    SELECT *
    FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID
)
BEGIN
    INSERT INTO SalesLT.SalesOrderDetail
        (SalesOrderID, ProductID, OrderQty, UnitPrice)
    VALUES
        (@SalesOrderID, @ProductID, @OrderQty, @UnitPrice)
END
ELSE
BEGIN
    PRINT N'Заказ не существует'
END
GO

--2.1
-- Объявляем переменные для средней и максимальной цены
DECLARE @AvgPrice money
DECLARE @MaxPrice money
SELECT @AvgPrice = AVG(p.ListPrice),
       @MaxPrice = MAX(p.ListPrice)
FROM SalesLT.Product AS p
JOIN SalesLT.vGetAllCategories AS c
ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.ParentProductCategoryName = 'Bikes'
WHILE @AvgPrice < 2000 AND @MaxPrice < 5000
BEGIN
    UPDATE SalesLT.Product
    SET ListPrice = ListPrice * 1.1
    WHERE ProductCategoryID IN
    (
        SELECT ProductCategoryID
        FROM SalesLT.vGetAllCategories
        WHERE ParentProductCategoryName = 'Bikes'
    )
    SELECT @AvgPrice = AVG(p.ListPrice),
           @MaxPrice = MAX(p.ListPrice)
    FROM SalesLT.Product AS p
    JOIN SalesLT.vGetAllCategories AS c
    ON p.ProductCategoryID = c.ProductCategoryID
    WHERE c.ParentProductCategoryName = 'Bikes'
    IF @MaxPrice >= 5000
        BREAK
END
PRINT N'Новая средняя цена на велосипед: '
      + CONVERT(varchar(30), @AvgPrice)
PRINT N'Новая максимальная цена велосипеда: '
      + CONVERT(varchar(30), @MaxPrice)
GO