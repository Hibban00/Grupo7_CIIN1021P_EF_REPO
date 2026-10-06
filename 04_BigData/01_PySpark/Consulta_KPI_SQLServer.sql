USE AdventureWorksDW_PC5;
GO

SET STATISTICS TIME ON;

SELECT
    SUM(ImporteVenta) AS VentasTotales,
    SUM(ImporteVenta) - SUM(CostoTotalProducto) AS MargenBruto,
    SUM(Cantidad) AS CantidadVendida
FROM dbo.FactVentas;
GO

SET STATISTICS TIME OFF;
GO