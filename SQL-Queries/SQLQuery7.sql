-- ЛАБА 7
-- ЗАДАЧА 1
-- 1.1 
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
-- 1.2 
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
-- 1.3 
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
-- 1.4 
SELECT p.ProductID,
       p.Name AS ProductName,
       c.ParentProductCategoryName AS ParentCategory,
       c.ProductCategoryName AS Category
FROM SalesLT.Product AS p
JOIN dbo.ufnGetAllCategories() AS c
    ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;
-- ЗАДАЧА 2
-- 2.1 
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
-- 2.2
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