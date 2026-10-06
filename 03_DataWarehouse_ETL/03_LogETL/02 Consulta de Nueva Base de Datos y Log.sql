USE AdventureWorksDW_PC5;
GO

SELECT 'DimFecha' AS Tabla, COUNT(*) AS Registros FROM dbo.DimFecha
UNION ALL
SELECT 'DimCliente', COUNT(*) FROM dbo.DimCliente
UNION ALL
SELECT 'DimProducto', COUNT(*) FROM dbo.DimProducto
UNION ALL
SELECT 'DimTerritorio', COUNT(*) FROM dbo.DimTerritorio
UNION ALL
SELECT 'DimPromocion', COUNT(*) FROM dbo.DimPromocion
UNION ALL
SELECT 'DimMoneda', COUNT(*) FROM dbo.DimMoneda
UNION ALL
SELECT 'FactVentas', COUNT(*) FROM dbo.FactVentas;


SELECT TOP 5
    LogETLKey,
    Proceso,
    FechaInicio,
    FechaFin,
    RegistrosProcesados,
    Estado,
    Mensaje
FROM dbo.LogETL
ORDER BY LogETLKey DESC;