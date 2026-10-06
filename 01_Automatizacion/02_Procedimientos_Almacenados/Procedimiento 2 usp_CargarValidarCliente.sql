USE AdventureWorksDW2014;
GO

--TABLA DE STAGING DE CLIENTES
--Almacenar temporalmente los datos necesarios de DimCustomer
--para realizar el proceso automatizado de validación.
DROP TABLE IF EXISTS dbo.StgDimCustomerCalidad;
GO

CREATE TABLE dbo.StgDimCustomerCalidad
(
    StgId INT IDENTITY(1,1)
        CONSTRAINT PK_StgDimCustomerCalidad PRIMARY KEY,

    CustomerKey INT NOT NULL,
    CustomerAlternateKey NVARCHAR(15) NULL,
    Nombre NVARCHAR(50) NULL,
    Apellido NVARCHAR(50) NULL,
    TotalNinos TINYINT NULL,
    NroNinosEnHogar TINYINT NULL,

    FechaCarga DATETIME2 NOT NULL
        CONSTRAINT DF_StgDimCustomerCalidad_FechaCarga
        DEFAULT SYSDATETIME()
);
GO

/* ============================================================
   PROCEDIMIENTO ALMACENADO 2
   usp_CargarValidarCliente

   Propósito:
   Automatizar la ingesta y validación de datos de DimCustomer.

   Regla de calidad:
   NumberChildrenAtHome mayor que TotalChildren.

   Control:
   - TRY/CATCH
   - BEGIN TRANSACTION
   - COMMIT
   - ROLLBACK
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_CargarValidarCliente
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        /* ========================================================
           1. LIMPIEZA DEL STAGING
           Elimina los datos de ejecuciones anteriores.
           ======================================================== */

        DELETE FROM dbo.StgDimCustomerCalidad;


        /* ========================================================
           2. INGESTA
           Se cargan los datos necesarios desde DimCustomer.
           ======================================================== */

        INSERT INTO dbo.StgDimCustomerCalidad
        (
            CustomerKey,
            CustomerAlternateKey,
            Nombre,
            Apellido,
            TotalNinos,
            NroNinosEnHogar
        )
        SELECT
            CustomerKey,
            CustomerAlternateKey,
            FirstName,
            LastName,
            TotalChildren,
            NumberChildrenAtHome
        FROM dbo.DimCustomer;


        /* ========================================================
           3. VALIDACIÓN
           Se identifican los clientes donde la cantidad de hijos
           en casa supera la cantidad total de hijos.
           ======================================================== */

        DECLARE @ClientesHijosInconsistentes INT;

        SELECT
            @ClientesHijosInconsistentes = COUNT(*)
        FROM dbo.StgDimCustomerCalidad
        WHERE NroNinosEnHogar > TotalNinos;


        /* ========================================================
           4. CONFIRMACIÓN DE LA TRANSACCIÓN
           ======================================================== */

        COMMIT TRANSACTION;


        /* ========================================================
           5. RESULTADO DEL PROCESO
           ======================================================== */

        SELECT
            COUNT(*) AS RegistrosIngresados,
            @ClientesHijosInconsistentes
                AS ClientesHijosInconsistentes,
            'PROCESO COMPLETADO' AS Estado
        FROM dbo.StgDimCustomerCalidad;

    END TRY

    BEGIN CATCH

        /* ========================================================
           6. MANEJO DEL ERROR
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

--Prueba de Procedimiento 2
EXEC dbo.usp_CargarValidarCliente;
GO