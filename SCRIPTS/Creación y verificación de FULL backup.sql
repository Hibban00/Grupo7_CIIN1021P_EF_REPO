USE AdventureWorksDW2014;
GO
--Consulta de configuración
SELECT
    name AS BaseDatos,
    recovery_model_desc AS ModeloRecuperacion
FROM sys.databases
WHERE name = 'AdventureWorksDW2014';
GO
SELECT
    SERVERPROPERTY('InstanceDefaultBackupPath') AS RutaBackup;
GO
--Crear Backup FULL dinámico
USE master;
GO
DECLARE @RutaBackup NVARCHAR(500);
DECLARE @ArchivoBackup NVARCHAR(500);
SET @RutaBackup = CAST(
    SERVERPROPERTY('InstanceDefaultBackupPath')
    AS NVARCHAR(500)
);
-- Asegurar que la ruta termine en "\"
IF RIGHT(@RutaBackup, 1) <> '\'
    SET @RutaBackup = @RutaBackup + '\';
SET @ArchivoBackup =
    @RutaBackup + 'AdventureWorksDW2014_PC3_FULL.bak';
BACKUP DATABASE AdventureWorksDW2014
TO DISK = @ArchivoBackup
WITH
    INIT,
    FORMAT,
    STATS = 10;
GO
--Verificar que el archivo de backup sea válido
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
    @RutaBackup + 'AdventureWorksDW2014_PC3_FULL.bak';
RESTORE VERIFYONLY
FROM DISK = @ArchivoBackup;
GO