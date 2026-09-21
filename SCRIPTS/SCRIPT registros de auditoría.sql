use AdventureWorksDW2014
GO

--Mostrar los registros de auditoría
--generados por el trigger
SELECT
    LogId,
    ProductKey,
    Operacion,
    FechaOperacion,
    UsuarioSQL,
    NombreProductoAnterior,
    NombreProductoNuevo,
    FechaInicioAnterior,
    FechaInicioNuevo,
    FechaFinalAnterior,
    FechaFinalNuevo
FROM dbo.LogAuditoriaDimProduct
ORDER BY LogId;