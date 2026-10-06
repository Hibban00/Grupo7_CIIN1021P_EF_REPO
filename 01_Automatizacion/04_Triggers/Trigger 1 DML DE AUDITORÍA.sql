USE AdventureWorksDW2014;
GO

--TABLA DE LOG DE AUDITORÍA
--Registrar las operaciones DML realizadas sobre DimProduct.
--Operaciones registradas: INSERT, UPDATE y DELETE.
DROP TABLE IF EXISTS dbo.LogAuditoriaDimProduct;
GO

CREATE TABLE dbo.LogAuditoriaDimProduct
(
    LogId INT IDENTITY(1,1)
        CONSTRAINT PK_LogAuditoriaDimProduct PRIMARY KEY,

    ProductKey INT NULL,

    Operacion VARCHAR(10) NOT NULL,

    FechaOperacion DATETIME2 NOT NULL
        CONSTRAINT DF_LogAuditoriaDimProduct_FechaOperacion
        DEFAULT SYSDATETIME(),

    UsuarioSQL SYSNAME NOT NULL
        CONSTRAINT DF_LogAuditoriaDimProduct_UsuarioSQL
        DEFAULT SUSER_SNAME(),

    NombreProductoAnterior NVARCHAR(100) NULL,
    NombreProductoNuevo NVARCHAR(100) NULL,

    FechaInicioAnterior DATETIME NULL,
    FechaInicioNuevo DATETIME NULL,

    FechaFinalAnterior DATETIME NULL,
    FechaFinalNuevo DATETIME NULL
);
GO

/* ============================================================
   TRIGGER DML DE AUDITORÍA
   Nombre:
   trg_DimProduct_Auditoria
   Propósito:
   Registrar automáticamente las operaciones INSERT, UPDATE
   y DELETE realizadas sobre DimProduct.
   inserted:
   Contiene los valores nuevos.
   deleted:
   Contiene los valores anteriores.
   ============================================================ */
CREATE OR ALTER TRIGGER dbo.trg_DimProduct_Auditoria
ON dbo.DimProduct
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    /* ========================================================
       INSERT
       Existe en inserted, pero no en deleted.
       ======================================================== */
    INSERT INTO dbo.LogAuditoriaDimProduct
    (
        ProductKey,
        Operacion,
        NombreProductoNuevo,
        FechaInicioNuevo,
        FechaFinalNuevo
    )
    SELECT
        i.ProductKey,
        'INSERT',
        i.EnglishProductName,
        i.StartDate,
        i.EndDate
    FROM inserted i
    LEFT JOIN deleted d
        ON i.ProductKey = d.ProductKey
    WHERE d.ProductKey IS NULL;
    /* ========================================================
       UPDATE
       Existe tanto en inserted como en deleted.
       ======================================================== */
    INSERT INTO dbo.LogAuditoriaDimProduct
    (
        ProductKey,
        Operacion,
        NombreProductoAnterior,
        NombreProductoNuevo,
        FechaInicioAnterior,
        FechaInicioNuevo,
        FechaFinalAnterior,
        FechaFinalNuevo
    )
    SELECT
        i.ProductKey,
        'UPDATE',
        d.EnglishProductName,
        i.EnglishProductName,
        d.StartDate,
        i.StartDate,
        d.EndDate,
        i.EndDate
    FROM inserted i
    INNER JOIN deleted d
        ON i.ProductKey = d.ProductKey;
    /* ========================================================
       DELETE
       Existe en deleted, pero no en inserted.
       ======================================================== */
    INSERT INTO dbo.LogAuditoriaDimProduct
    (
        ProductKey,
        Operacion,
        NombreProductoAnterior,
        FechaInicioAnterior,
        FechaFinalAnterior
    )
    SELECT
        d.ProductKey,
        'DELETE',
        d.EnglishProductName,
        d.StartDate,
        d.EndDate
    FROM deleted d
    LEFT JOIN inserted i
        ON d.ProductKey = i.ProductKey
    WHERE i.ProductKey IS NULL;
END;
GO

--Verificacion de Log vacio
SELECT *
FROM dbo.LogAuditoriaDimProduct;

--Prueba de UPDATE usando transacción
BEGIN TRANSACTION;

UPDATE dbo.DimProduct
SET EnglishProductName = EnglishProductName
WHERE ProductKey = 210;

SELECT *
FROM dbo.LogAuditoriaDimProduct
ORDER BY LogId DESC;

ROLLBACK TRANSACTION;

--Prueba de Insert usando transacción
BEGIN TRANSACTION;

INSERT INTO dbo.DimProduct
(
    ProductAlternateKey,
    EnglishProductName,
    SpanishProductName,
    FrenchProductName,
    FinishedGoodsFlag,
    Color,
    StartDate,
    EndDate,
    Status
)
VALUES
(
    'TEST-PC2',
    'Producto Prueba PC2',
    'Producto Prueba PC2',
    'Produit Test PC2',
    1,
    'Test',
    GETDATE(),
    NULL,
    'Current'
);

SELECT TOP 1
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
ORDER BY LogId DESC;

ROLLBACK TRANSACTION;

--Prueba de Delete usando transacción
BEGIN TRANSACTION;

-- 1. Crear producto de prueba
INSERT INTO dbo.DimProduct
(
    ProductAlternateKey,
    EnglishProductName,
    SpanishProductName,
    FrenchProductName,
    FinishedGoodsFlag,
    Color,
    StartDate,
    EndDate,
    Status
)
VALUES
(
    'TEST-PC2-DELETE',
    'Producto Prueba DELETE',
    'Producto Prueba DELETE',
    'Produit Test DELETE',
    1,
    'Test',
    GETDATE(),
    NULL,
    'Current'
);

-- 2. Obtener la clave asignada
DECLARE @ProductKeyPrueba INT;

SELECT @ProductKeyPrueba = ProductKey
FROM dbo.DimProduct
WHERE ProductAlternateKey = 'TEST-PC2-DELETE';

-- 3. Eliminar el producto de prueba
DELETE FROM dbo.DimProduct
WHERE ProductKey = @ProductKeyPrueba;

-- 4. Verificar la auditoría
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
WHERE ProductKey = @ProductKeyPrueba
ORDER BY LogId;

-- 5. Revertir toda la prueba
ROLLBACK TRANSACTION;