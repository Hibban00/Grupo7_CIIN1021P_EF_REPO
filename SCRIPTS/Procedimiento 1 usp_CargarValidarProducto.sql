Use AdventureWorksDW2014
GO

--TABLA DE STAGING
--Tabla de staging para la ingesta y validación
--de los datos de DimProduct.
DROP TABLE IF EXISTS dbo.StgDimProductCalidad;
GO

CREATE TABLE dbo.StgDimProductCalidad
(
    StgId INT IDENTITY(1,1)
        CONSTRAINT PK_StgDimProductCalidad PRIMARY KEY,

    ProductKey INT NOT NULL,
    ProductAlternateKey NVARCHAR(25) NULL,
    NombreProducto NVARCHAR(50) NULL,
    ProductoTerminado BIT NULL,
    CostoEstandar MONEY NULL,
    PrecioLista MONEY NULL,
    Estado NVARCHAR(7) NULL,
    FechaInicial DATETIME NULL,
    FechaFinal DATETIME NULL,

    FechaCarga DATETIME2 NOT NULL
        CONSTRAINT DF_StgDimProductCalidad_FechaCarga
        DEFAULT SYSDATETIME()
);
GO

/* ============================================================
   PROCEDIMIENTO ALMACENADO 1
   usp_CargarValidarProducto

   Propósito:
   Automatizar la ingesta y validación de datos de DimProduct.

   Reglas de calidad:
   1. EndDate anterior a StartDate.
   2. Producto terminado actual sin StandardCost ni ListPrice.

   Control:
   - TRY/CATCH
   - BEGIN TRANSACTION
   - COMMIT
   - ROLLBACK
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_CargarValidarProducto
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        /* ========================================================
           1. LIMPIEZA DEL STAGING
           Se eliminan los datos de una ejecución anterior.
           ======================================================== */

        DELETE FROM dbo.StgDimProductCalidad;


        /* ========================================================
           2. INGESTA
           Se cargan los datos seleccionados desde DimProduct.
           ======================================================== */

        INSERT INTO dbo.StgDimProductCalidad
        (
            ProductKey,
            ProductAlternateKey,
            NombreProducto,
            ProductoTerminado,
            CostoEstandar,
            PrecioLista,
            Estado,
            FechaInicial,
            FechaFinal
        )
        SELECT
            ProductKey,
            ProductAlternateKey,
            EnglishProductName,
            FinishedGoodsFlag,
            StandardCost,
            ListPrice,
            Status,
            StartDate,
            EndDate
        FROM dbo.DimProduct;


        /* ========================================================
           3. VALIDACIÓN DE LA REGLA 1
           FechaFinal anterior a FechaInicial.
           ======================================================== */

        DECLARE @ProductosFechaInconsistente INT;

        SELECT
            @ProductosFechaInconsistente = COUNT(*)
        FROM dbo.StgDimProductCalidad
        WHERE FechaInicial IS NOT NULL
          AND FechaFinal IS NOT NULL
          AND FechaFinal < FechaInicial;


        /* ========================================================
           4. VALIDACIÓN DE LA REGLA 2
           Producto terminado actual sin CostoEstandar ni PrecioLista.
           ======================================================== */

        DECLARE @ProductosSinInformacionEconomica INT;

        SELECT
            @ProductosSinInformacionEconomica = COUNT(*)
        FROM dbo.StgDimProductCalidad
        WHERE ProductoTerminado = 1
          AND Estado = 'Current'
          AND CostoEstandar IS NULL
          AND PrecioLista IS NULL;


        /* ========================================================
           5. CONFIRMACIÓN DE LA TRANSACCIÓN
           ======================================================== */

        COMMIT TRANSACTION;


        /* ========================================================
           6. RESULTADO DEL PROCESO
           ======================================================== */

        SELECT
            COUNT(*) AS RegistrosIngresados,
            @ProductosFechaInconsistente
                AS ProductosFechaInconsistente,
            @ProductosSinInformacionEconomica
                AS ProductosSinInformacionEconomica,
            'PROCESO COMPLETADO' AS Estado
        FROM dbo.StgDimProductCalidad;

    END TRY

    BEGIN CATCH

        /* ========================================================
           7. MANEJO DEL ERROR
           Si ocurre un error, se revierte la transacción.
           ======================================================== */

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT
            ERROR_NUMBER() AS NumeroError,
            ERROR_MESSAGE() AS MensajeError,
            ERROR_LINE() AS LineaError,
            'PROCESO REVERTIDO' AS Estado;

    END CATCH;
END;
GO

--Prueba de Procedimiento 1
EXEC dbo.usp_CargarValidarProducto;
GO