USE AdventureWorksDW2014;
GO

/* ============================================================
  TRIGGER DE INTEGRIDAD
   Nombre:
   trg_DimProduct_IntegridadFecha
   Propósito:
   Evitar que se registren productos cuya fecha de finalización
   sea anterior a su fecha de inicio.
   Regla:
   EndDate < StartDate
   Operaciones controladas:
   INSERT y UPDATE.
   Si la regla se incumple:
   - Se cancela la operación.
   - Se ejecuta ROLLBACK.
   - Se genera un mensaje de error.
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_DimProduct_IntegridadFecha
ON dbo.DimProduct
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    /* ========================================================
       Verificar si existe algún registro con inconsistencia
       temporal.
       ======================================================== */
    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE StartDate IS NOT NULL
          AND EndDate IS NOT NULL
          AND EndDate < StartDate
    )
    BEGIN
    /* ====================================================
       Revertir la operación que intentó introducir
       la inconsistencia.
       ==================================================== */
        ROLLBACK TRANSACTION;
        THROW 50001,
              'Operacion rechazada: EndDate no puede ser anterior a StartDate.',
              1;
    END;
END;
GO

--prueba de UPDATE inválido
UPDATE dbo.DimProduct
SET
    StartDate = '2025-01-01',
    EndDate = '2024-01-01'
WHERE ProductKey = 210;

--Comprobacion
SELECT
    ProductKey,
    EnglishProductName,
    StartDate,
    EndDate
FROM dbo.DimProduct
WHERE ProductKey = 210;