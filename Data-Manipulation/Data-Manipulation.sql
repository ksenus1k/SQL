--Управление данными в Microsoft SQL Server
--Добавление записей в базу данных
--Добавление нового товара и получение его идентификатора
DELETE FROM SalesLT.Product
WHERE ProductNumber = 'LT-L123';
INSERT INTO SalesLT.Product
    (Name, ProductNumber, StandardCost, ListPrice,
     ProductCategoryID, SellStartDate)
VALUES
    ('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE());
SELECT SCOPE_IDENTITY() AS ProductID;
SELECT *
FROM SalesLT.Product
WHERE ProductNumber = 'LT-L123';

--Создание товарной категории и добавление связанных товаров
INSERT INTO SalesLT.ProductCategory 
    (ParentProductCategoryID, Name)
VALUES
    (4, 'Bells and Horns');
INSERT INTO SalesLT.Product
    (Name, ProductNumber, StandardCost, ListPrice,
     ProductCategoryID, SellStartDate)
VALUES
    ('Bicycle Bell', 'BB-RING', 2.47, 4.99,
     (SELECT ProductCategoryID
      FROM SalesLT.ProductCategory
      WHERE Name = 'Bells and Horns'), GETDATE()),
    ('Bicycle Horn', 'BB-PARP', 1.29, 3.75,
     (SELECT ProductCategoryID
      FROM SalesLT.ProductCategory
      WHERE Name = 'Bells and Horns'), GETDATE());
SELECT *
FROM SalesLT.Product
INNER JOIN SalesLT.ProductCategory
    ON SalesLT.Product.ProductCategoryID =
       SalesLT.ProductCategory.ProductCategoryID
WHERE SalesLT.ProductCategory.Name = 'Bells and Horns';
--Обновление существующих записей
--Увеличение стоимости товаров выбранной категории на 10%
UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.10
WHERE SalesLT.Product.ProductCategoryID =
(
    SELECT SalesLT.ProductCategory.ProductCategoryID
    FROM SalesLT.ProductCategory
    WHERE SalesLT.ProductCategory.Name = 'Bells and Horns'
);
SELECT *
FROM SalesLT.Product
WHERE SalesLT.Product.ProductCategoryID =
(
    SELECT SalesLT.ProductCategory.ProductCategoryID
    FROM SalesLT.ProductCategory
    WHERE SalesLT.ProductCategory.Name = 'Bells and Horns'
);

--Установка даты прекращения продаж для выбранных товаров
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE() 
WHERE ProductCategoryID = 37
AND ProductNumber <> 'LT-L123';
SELECT
    ProductID,
    Name,
    ProductNumber,
    ProductCategoryID,
    DiscontinuedDate
FROM SalesLT.Product
WHERE ProductCategoryID = 37;

--Удаление связанных записей из таблиц товаров и категорий
DELETE FROM SalesLT.Product
WHERE ProductCategoryID =
(
    SELECT ProductCategoryID
    FROM SalesLT.ProductCategory
    WHERE Name = 'Bells and Horns'
);
DELETE FROM SalesLT.ProductCategory
WHERE Name = 'Bells and Horns';
SELECT *
FROM SalesLT.ProductCategory
WHERE Name = 'Bells and Horns';
SELECT *
FROM SalesLT.Product
WHERE ProductNumber IN ('BB-RING', 'BB-PARP');