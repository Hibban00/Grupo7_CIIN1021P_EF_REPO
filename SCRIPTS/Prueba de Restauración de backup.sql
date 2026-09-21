USE AdventureWorksDW2014;
GO

--CICLO DE PRUEBA PARA RESTAURACIÓN
--Modificacion despues del diferencial
UPDATE dbo.DimProduct
SET EnglishProductName = 'Producto MODIFICADO DESPUES DEL BACKUP'
WHERE ProductKey = 610;
GO

SELECT
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    Status
FROM dbo.DimProduct
WHERE ProductKey = 610;
GO

--Restauracion FULL + NORECOVERY y luego DIFFERENTIAL + RECOVERY
USE master;
GO

DECLARE @RutaBackup NVARCHAR(500);
DECLARE @ArchivoFull NVARCHAR(500);
DECLARE @ArchivoDiff NVARCHAR(500);

SET @RutaBackup = CAST(
    SERVERPROPERTY('InstanceDefaultBackupPath')
    AS NVARCHAR(500)
);

IF RIGHT(@RutaBackup, 1) <> '\'
    SET @RutaBackup = @RutaBackup + '\';

SET @ArchivoFull =
    @RutaBackup + 'AdventureWorksDW2014_PC3_FULL.bak';

SET @ArchivoDiff =
    @RutaBackup + 'AdventureWorksDW2014_PC3_DIFF.bak';

-- 1. Restaurar FULL
RESTORE DATABASE AdventureWorksDW2014
FROM DISK = @ArchivoFull
WITH
    REPLACE,
    NORECOVERY,
    STATS = 10;

-- 2. Aplicar DIFFERENTIAL y finalizar recuperación
RESTORE DATABASE AdventureWorksDW2014
FROM DISK = @ArchivoDiff
WITH
    RECOVERY,
    STATS = 10;
GO

--Comprobacion del producto modificado
USE AdventureWorksDW2014;
GO

SELECT
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    Status
FROM dbo.DimProduct
WHERE ProductKey = 610;
GO

--Restauracion FULL + RECOVERY
USE master;
GO

DECLARE @RutaBackup NVARCHAR(500);
DECLARE @ArchivoFull NVARCHAR(500);

SET @RutaBackup = CAST(
    SERVERPROPERTY('InstanceDefaultBackupPath')
    AS NVARCHAR(500)
);

IF RIGHT(@RutaBackup, 1) <> '\'
    SET @RutaBackup = @RutaBackup + '\';

SET @ArchivoFull =
    @RutaBackup + 'AdventureWorksDW2014_PC3_FULL.bak';
-- Restaurar únicamente el FULL
RESTORE DATABASE AdventureWorksDW2014
FROM DISK = @ArchivoFull
WITH
    REPLACE,
    RECOVERY,
    STATS = 10;
GO

--Comprobacion del producto creado despues del full
USE AdventureWorksDW2014;
GO

SELECT
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    Status
FROM dbo.DimProduct
WHERE ProductKey = 611;
GO