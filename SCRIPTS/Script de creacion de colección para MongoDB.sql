USE AdventureWorksDW2014;
GO

SELECT TOP 10
    p.ProductKey AS productKey,
    p.EnglishProductName AS nombre,
    p.StandardCost AS costoEstandar,
    p.ListPrice AS precioLista,
    p.FinishedGoodsFlag AS productoTerminado,
    p.Status AS estado,
    ps.EnglishProductSubcategoryName AS subcategoria,
    pc.EnglishProductCategoryName AS categoria
FROM dbo.DimProduct AS p
INNER JOIN dbo.DimProductSubcategory AS ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN dbo.DimProductCategory AS pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY p.ProductKey
FOR JSON PATH;