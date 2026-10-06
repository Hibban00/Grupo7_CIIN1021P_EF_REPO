USE AdventureWorksDW2014;
GO

--Creacion de un cambio para el diferencial
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
    'TEST-PC3-BACKUP',
    'Producto Prueba Backup',
    'Producto Prueba Backup',
    'Produit Test Backup',
    1,
    'Test',
    GETDATE(),
    NULL,
    'Current'
);
GO

--Verificacion de que registro existe
SELECT
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    Status
FROM dbo.DimProduct
WHERE ProductAlternateKey = 'TEST-PC3-BACKUP';
GO

--Crear el backup DIFFERENTIAL
USE master;
GO

DECLARE @RutaBackup NVARCHAR(500);
DECLARE @ArchivoBackup NVARCHAR(500);

SET @RutaBackup = CAST(
    SERVERPROPERTY('InstanceDefaultBackupPath')
    AS NVARCHAR(500)
);

IF RIGHT(@RutaBackup, 1) <> '\'
    SET @RutaBackup = @RutaBackup + '\';

SET @ArchivoBackup =
    @RutaBackup + 'AdventureWorksDW2014_PC3_DIFF.bak';

BACKUP DATABASE AdventureWorksDW2014
TO DISK = @ArchivoBackup
WITH
    INIT,
    DIFFERENTIAL,
    STATS = 10;
GO

--Verificar el diferencial con RESTORE VERIFYONLY
USE master;
GO

DECLARE @RutaBackup NVARCHAR(500);
DECLARE @ArchivoBackup NVARCHAR(500);

SET @RutaBackup = CAST(
    SERVERPROPERTY('InstanceDefaultBackupPath')
    AS NVARCHAR(500)
);

IF RIGHT(@RutaBackup, 1) <> '\'
    SET @RutaBackup = @RutaBackup + '\';

SET @ArchivoBackup =
    @RutaBackup + 'AdventureWorksDW2014_PC3_DIFF.bak';

RESTORE VERIFYONLY
FROM DISK = @ArchivoBackup;
GO