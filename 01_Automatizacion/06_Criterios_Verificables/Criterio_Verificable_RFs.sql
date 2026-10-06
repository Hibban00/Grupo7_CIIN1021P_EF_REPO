USE AdventureWorksDW2014;
GO

--RF01-Criterio Verificable
SELECT TOP 10
    fis.SalesOrderNumber AS NumeroVenta,
    CONCAT(dc.FirstName, ' ', dc.LastName) AS Cliente,
    dp.EnglishProductName AS Producto,
    dd.FullDateAlternateKey AS Fecha,
    dst.SalesTerritoryRegion AS Territorio
FROM FactInternetSales AS fis
INNER JOIN DimCustomer AS dc
    ON fis.CustomerKey = dc.CustomerKey
INNER JOIN DimProduct AS dp
    ON fis.ProductKey = dp.ProductKey
INNER JOIN DimDate AS dd
    ON fis.OrderDateKey = dd.DateKey
INNER JOIN DimSalesTerritory AS dst
    ON fis.SalesTerritoryKey = dst.SalesTerritoryKey
ORDER BY fis.SalesOrderNumber;

--RF02-Criterio verificable
--Ventas por producto
SELECT TOP 10
    dp.ProductKey,
    dp.EnglishProductName AS Producto,
    SUM(fis.SalesAmount) AS TotalVentas
FROM FactInternetSales AS fis
INNER JOIN DimProduct AS dp
    ON fis.ProductKey = dp.ProductKey
GROUP BY
    dp.ProductKey,
    dp.EnglishProductName
ORDER BY TotalVentas DESC;
--Ventas por cliente
SELECT TOP 10
    dc.CustomerKey,
    CONCAT(dc.FirstName, ' ', dc.LastName) AS Cliente,
    SUM(fis.SalesAmount) AS TotalVentas
FROM FactInternetSales AS fis
INNER JOIN DimCustomer AS dc
    ON fis.CustomerKey = dc.CustomerKey
GROUP BY
    dc.CustomerKey,
    dc.FirstName,
    dc.LastName
ORDER BY TotalVentas DESC;

--Ventas por fecha
SELECT TOP 10
    dd.FullDateAlternateKey AS Fecha,
    SUM(fis.SalesAmount) AS TotalVentas
FROM FactInternetSales AS fis
INNER JOIN DimDate AS dd
    ON fis.OrderDateKey = dd.DateKey
GROUP BY
    dd.FullDateAlternateKey
ORDER BY TotalVentas DESC;

--Ventas por territorio
SELECT
    dst.SalesTerritoryRegion AS Territorio,
    SUM(fis.SalesAmount) AS TotalVentas
FROM FactInternetSales AS fis
INNER JOIN DimSalesTerritory AS dst
    ON fis.SalesTerritoryKey = dst.SalesTerritoryKey
GROUP BY
    dst.SalesTerritoryRegion
ORDER BY TotalVentas DESC;

--Ventas por promoción
SELECT
    dp.PromotionKey,
    dp.EnglishPromotionName AS Promocion,
    SUM(fis.SalesAmount) AS TotalVentas
FROM FactInternetSales AS fis
INNER JOIN DimPromotion AS dp
    ON fis.PromotionKey = dp.PromotionKey
GROUP BY
    dp.PromotionKey,
    dp.EnglishPromotionName
ORDER BY TotalVentas DESC;

--Ventas por moneda
SELECT
    dc.CurrencyKey,
    dc.CurrencyName AS Moneda,
    SUM(fis.SalesAmount) AS TotalVentas
FROM FactInternetSales AS fis
INNER JOIN DimCurrency AS dc
    ON fis.CurrencyKey = dc.CurrencyKey
GROUP BY
    dc.CurrencyKey,
    dc.CurrencyName
ORDER BY TotalVentas DESC;

--RF03-Criterio Verificable
SELECT
    'EndDate < StartDate' AS Problema,
    200 AS ResultadoEsperado,
    (
        SELECT COUNT(*)
        FROM DimProduct
        WHERE EndDate < StartDate
    ) AS ResultadoObtenido;

SELECT
    'NumberChildrenAtHome > TotalChildren' AS Problema,
    1431 AS ResultadoEsperado,
    (
        SELECT COUNT(*)
        FROM DimCustomer
        WHERE NumberChildrenAtHome > TotalChildren
    ) AS ResultadoObtenido;

SELECT
    'Current sin StandardCost y ListPrice' AS Problema,
    2 AS ResultadoEsperado,
    (
        SELECT
            COUNT(*) AS RegistrosAfectados
        FROM DimProduct
        WHERE FinishedGoodsFlag = 1
          AND Status = 'Current'
          AND StandardCost IS NULL
          AND ListPrice IS NULL
    ) AS ResultadoObtenido;

GO