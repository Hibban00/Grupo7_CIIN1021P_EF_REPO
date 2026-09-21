USE AdventureWorksDW2014;
GO

--Medición de indice
--activa Ctrl + M
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    ProductKey,
    OrderDateKey,
    CustomerKey,
    SalesTerritoryKey,
    OrderQuantity,
    SalesAmount
FROM dbo.FactInternetSales
WHERE ProductKey = 310
  AND OrderDateKey BETWEEN 20130101 AND 20131231;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

--Comprobar índices existentes en FactInternetSales
SELECT
    i.name AS NombreIndice,
    i.type_desc AS TipoIndice,
    c.name AS Columna,
    ic.key_ordinal AS OrdenColumna
FROM sys.indexes i
INNER JOIN sys.index_columns ic
    ON i.object_id = ic.object_id
   AND i.index_id = ic.index_id
INNER JOIN sys.columns c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('dbo.FactInternetSales')
ORDER BY
    i.index_id,
    ic.key_ordinal;

--Crear un índice no clustered orientado
CREATE NONCLUSTERED INDEX IX_FactInternetSales_Product_OrderDate
ON dbo.FactInternetSales
(
    ProductKey,
    OrderDateKey
);
GO

