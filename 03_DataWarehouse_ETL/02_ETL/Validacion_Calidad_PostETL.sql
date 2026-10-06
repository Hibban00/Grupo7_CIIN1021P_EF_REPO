USE AdventureWorksDW_PC5;
GO

SELECT COUNT(*) AS TotalFactVentas
FROM dbo.FactVentas;

-- 1. Inconsistencias de fechas
SELECT COUNT(*) AS ProductosFechaInconsistente
FROM dbo.DimProducto
WHERE FechaFin IS NOT NULL
  AND FechaInicio IS NOT NULL
  AND FechaFin < FechaInicio;

-- 2. Inconsistencia en cantidad de hijos
SELECT COUNT(*) AS ClientesHijosInconsistentes
FROM dbo.DimCliente
WHERE HijosEnCasa > TotalHijos;

-- PROBLEMA DE CALIDAD 3
-- Productos terminados actuales sin CostoEstandar ni PrecioLista

SELECT COUNT(*) AS ProductosSinInformacionEconomica
FROM dbo.DimProducto
WHERE ProductoTerminado = 1
  AND Estado = 'Current'
  AND CostoEstandar IS NULL
  AND PrecioLista IS NULL;