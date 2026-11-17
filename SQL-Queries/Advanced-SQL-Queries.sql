-- Обработка и анализ данных в Microsoft SQL Server
-- Получение информации о товарах
-- Объединение данных о товарах, моделях и описаниях
SELECT
    p.ProductID,
    p.Name AS ProductName,
    pm.Name AS ProductModel,
    v.Summary
FROM SalesLT.Product AS p
JOIN SalesLT.ProductModel AS pm
    ON p.ProductModelID = pm.ProductModelID
JOIN SalesLT.vProductModelCatalogDescription AS v
    ON pm.ProductModelID = v.ProductModelID
ORDER BY p.ProductID;
-- Использование табличной переменной для обработки цветов товаров
DECLARE @Colors TABLE (
    Color VARCHAR(15) COLLATE DATABASE_DEFAULT
);
INSERT INTO @Colors
SELECT DISTINCT Color
FROM SalesLT.Product
WHERE Color IS NOT NULL;
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.Color
FROM SalesLT.Product AS p
JOIN @Colors AS c
    ON p.Color COLLATE DATABASE_DEFAULT =
       c.Color COLLATE DATABASE_DEFAULT
ORDER BY p.Color;
-- Использование временной таблицы для обработки размеров товаров
DROP TABLE IF EXISTS #Sizes;
CREATE TABLE #Sizes (
    Size VARCHAR(5) COLLATE DATABASE_DEFAULT
);
INSERT INTO #Sizes
SELECT DISTINCT Size
FROM SalesLT.Product
WHERE Size IS NOT NULL;
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.Size
FROM SalesLT.Product AS p
JOIN #Sizes AS s
    ON p.Size COLLATE DATABASE_DEFAULT =
       s.Size COLLATE DATABASE_DEFAULT
ORDER BY p.Size DESC;
DROP TABLE #Sizes;
-- Получение категорий товаров с помощью табличной функции
SELECT p.ProductID,
       p.Name AS ProductName,
       c.ParentProductCategoryName AS ParentCategory,
       c.ProductCategoryName AS Category
FROM SalesLT.Product AS p
JOIN dbo.ufnGetAllCategories() AS c
    ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;
-- Анализ продаж по клиентам
-- Расчёт выручки по клиентам с использованием подзапроса
SELECT
    CompanyContact,
    SUM(TotalDue) AS Revenue
FROM (
    SELECT
        c.CompanyName + ' (' + c.FirstName + ' ' +
        c.LastName + ')' AS CompanyContact,
        soh.TotalDue
    FROM SalesLT.Customer AS c
    JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
) AS CustomerSales
GROUP BY CompanyContact
ORDER BY CompanyContact;
--Расчёт выручки по клиентам с использованием CTE
;WITH CustomerSales AS (
    SELECT
        c.CompanyName + ' (' + c.FirstName + ' ' +
        c.LastName + ')' AS CompanyContact,
        soh.TotalDue
    FROM SalesLT.Customer AS c
    JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
)
SELECT
    CompanyContact,
    SUM(TotalDue) AS Revenue
FROM CustomerSales
GROUP BY CompanyContact
ORDER BY CompanyContact;
