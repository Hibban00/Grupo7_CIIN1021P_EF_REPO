use AdventureWorksDW2014

--Volumen de las 9 tablas
SELECT 
    t.name AS Tabla,
    SUM(p.rows) AS Registros
FROM sys.tables t
INNER JOIN sys.partitions p
    ON t.object_id = p.object_id
WHERE t.name IN (
    'FactInternetSales',
    'DimCustomer',
    'DimProduct',
    'DimProductSubcategory',
    'DimProductCategory',
    'DimDate',
    'DimSalesTerritory',
    'DimPromotion',
    'DimCurrency'
)
AND p.index_id IN (0,1)
GROUP BY t.name
ORDER BY t.name;

--PROBLEMA DE CALIDAD 1 EndDate anterior a StartDate
SELECT COUNT(*) AS ProductosFechaInconsistente
FROM DimProduct
WHERE EndDate IS NOT NULL
  AND StartDate IS NOT NULL
  AND EndDate < StartDate;
--Porcentaje sobre el total de productos
SELECT 
    COUNT(*) AS ProductosFechaInconsistente,
    CAST(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM DimProduct)
        AS DECIMAL(5,2)
    ) AS Porcentaje
FROM DimProduct
WHERE EndDate IS NOT NULL
  AND StartDate IS NOT NULL
  AND EndDate < StartDate;
--Evidencia complementaria del problema temporal Productos Current con ventas anteriores a StartDate
SELECT
    COUNT(DISTINCT p.ProductKey) AS ProductosCurrentInconsistentes,
    COUNT(*) AS VentasAfectadas
FROM FactInternetSales f
INNER JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
WHERE p.Status = 'Current'
  AND p.StartDate IS NOT NULL
  AND f.OrderDate < p.StartDate;

--PROBLEMA DE CALIDAD 2 NumberChildrenAtHome mayor que TotalChildren
SELECT COUNT(*) AS ClientesHijosInconsistentes
FROM DimCustomer
WHERE NumberChildrenAtHome > TotalChildren;
--Porcentaje sobre el total de clientes */
SELECT 
    COUNT(*) AS ClientesHijosInconsistentes,
    CAST(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM DimCustomer)
        AS DECIMAL(5,2)
    ) AS Porcentaje
FROM DimCustomer
WHERE NumberChildrenAtHome > TotalChildren;
--Evidencia de casos concretos
SELECT TOP 20
    CustomerKey,
    FirstName,
    LastName,
    TotalChildren,
    NumberChildrenAtHome
FROM DimCustomer
WHERE NumberChildrenAtHome > TotalChildren
ORDER BY TotalChildren, NumberChildrenAtHome;

--PROBLEMA DE CALIDAD 3 Productos terminados actuales sin StandardCost ni ListPrice
SELECT COUNT(*) AS ProductosTerminadosSinInformacionEconomica
FROM DimProduct
WHERE FinishedGoodsFlag = 1
  AND Status = 'Current'
  AND StandardCost IS NULL
  AND ListPrice IS NULL;
--Porcentaje sobre el total de productos */
SELECT 
    COUNT(*) AS ProductosTerminadosSinInformacionEconomica,
    CAST(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM DimProduct)
        AS DECIMAL(5,2)
    ) AS Porcentaje
FROM DimProduct
WHERE FinishedGoodsFlag = 1
  AND Status = 'Current'
  AND StandardCost IS NULL
  AND ListPrice IS NULL;
--Identificación de los productos afectados */
SELECT
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    FinishedGoodsFlag,
    StandardCost,
    ListPrice,
    Status
FROM DimProduct
WHERE FinishedGoodsFlag = 1
  AND Status = 'Current'
  AND StandardCost IS NULL
  AND ListPrice IS NULL;
--VERIFICACIÓN DEL IMPACTO EN VENTAS De los dos productos anteriores
SELECT
    p.ProductKey,
    p.EnglishProductName,
    COUNT(f.ProductKey) AS CantidadVentas
FROM DimProduct p
LEFT JOIN FactInternetSales f
    ON p.ProductKey = f.ProductKey
WHERE p.FinishedGoodsFlag = 1
  AND p.Status = 'Current'
  AND p.StandardCost IS NULL
  AND p.ListPrice IS NULL
GROUP BY
    p.ProductKey,
    p.EnglishProductName;

