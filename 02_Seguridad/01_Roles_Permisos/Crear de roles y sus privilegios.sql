USE AdventureWorksDW2014;
GO

-- Rol para administración de la base de datos
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'rol_Administrador'
)
    CREATE ROLE rol_Administrador;
GO

-- Rol para análisis de datos
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'rol_Analista'
)
    CREATE ROLE rol_Analista;
GO

-- Rol para auditoría
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'rol_Auditor'
)
    CREATE ROLE rol_Auditor;
GO

SELECT
    name AS Rol,
    type_desc AS Tipo
FROM sys.database_principals
WHERE name IN (
    'rol_Administrador',
    'rol_Analista',
    'rol_Auditor'
);
GO

-- Asignacion de permisos para Administrador
-- Acceso completo sobre las tablas del MER
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.FactInternetSales TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimCustomer TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimProduct TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimProductSubcategory TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimProductCategory TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimDate TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimSalesTerritory TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimPromotion TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DimCurrency TO rol_Administrador;
-- Acceso al registro de auditoría creado en Practica de Campo 2
GRANT SELECT
ON dbo.LogAuditoriaDimProduct TO rol_Administrador;
GO

-- Asignacion de permisos para Analista
-- Solo acceso select sobre las tablas del MER
GRANT SELECT
ON dbo.FactInternetSales TO rol_Analista;
GRANT SELECT
ON dbo.DimCustomer TO rol_Analista;
GRANT SELECT
ON dbo.DimProduct TO rol_Analista;
GRANT SELECT
ON dbo.DimProductSubcategory TO rol_Analista;
GRANT SELECT
ON dbo.DimProductCategory TO rol_Analista;
GRANT SELECT
ON dbo.DimDate TO rol_Analista;
GRANT SELECT
ON dbo.DimSalesTerritory TO rol_Analista;
GRANT SELECT
ON dbo.DimPromotion TO rol_Analista;
GRANT SELECT
ON dbo.DimCurrency TO rol_Analista;
GO

-- Asignacion de permisos para Auditor
-- Solo acceso select sobre las tablas del MER y LogAuditoria
GRANT SELECT
ON dbo.FactInternetSales TO rol_Auditor;
GRANT SELECT
ON dbo.DimCustomer TO rol_Auditor;
GRANT SELECT
ON dbo.DimProduct TO rol_Auditor;
GRANT SELECT
ON dbo.DimProductSubcategory TO rol_Auditor;
GRANT SELECT
ON dbo.DimProductCategory TO rol_Auditor;
GRANT SELECT
ON dbo.DimDate TO rol_Auditor;
GRANT SELECT
ON dbo.DimSalesTerritory TO rol_Auditor;
GRANT SELECT
ON dbo.DimPromotion TO rol_Auditor;
GRANT SELECT
ON dbo.DimCurrency TO rol_Auditor;
GRANT SELECT
ON dbo.LogAuditoriaDimProduct TO rol_Auditor;
GO

-- CREACIÓN DE USUARIOS DE PRUEBA
-- Usuario de prueba: Administrador
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'usr_Administrador'
)
    CREATE USER usr_Administrador WITHOUT LOGIN;
GO

-- Usuario de prueba: Analista
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'usr_Analista'
)
    CREATE USER usr_Analista WITHOUT LOGIN;
GO

-- Usuario de prueba: Auditor
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'usr_Auditor'
)
    CREATE USER usr_Auditor WITHOUT LOGIN;
GO

-- Asociar cada usuario con su rol
ALTER ROLE rol_Administrador ADD MEMBER usr_Administrador;
ALTER ROLE rol_Analista ADD MEMBER usr_Analista;
ALTER ROLE rol_Auditor ADD MEMBER usr_Auditor;
GO

-- Verificación de usuarios
SELECT
    u.name AS Usuario,
    r.name AS Rol
FROM sys.database_role_members drm
INNER JOIN sys.database_principals r
    ON drm.role_principal_id = r.principal_id
INNER JOIN sys.database_principals u
    ON drm.member_principal_id = u.principal_id
WHERE u.name IN (
    'usr_Administrador',
    'usr_Analista',
    'usr_Auditor'
)
ORDER BY r.name;

--Prueba del Administrador
EXECUTE AS USER = 'usr_Administrador';
-- Operación permitida: consulta
SELECT TOP 5
    ProductKey,
    EnglishProductName,
    ListPrice
FROM dbo.DimProduct;
-- Verificar que puede modificar
UPDATE dbo.DimProduct
SET EnglishProductName = EnglishProductName
WHERE ProductKey = 210;
REVERT;
GO

--Prueba del Analista
EXECUTE AS USER = 'usr_Analista';
-- Operación permitida
SELECT TOP 5
    ProductKey,
    EnglishProductName,
    ListPrice
FROM dbo.DimProduct;
-- Operación que debe ser rechazada
UPDATE dbo.DimProduct
SET EnglishProductName = EnglishProductName
WHERE ProductKey = 210;
REVERT;
GO

--Prueba del Auditor
EXECUTE AS USER = 'usr_Auditor';
-- Operación permitida: consulta
SELECT TOP 5
    ProductKey,
    EnglishProductName,
    ListPrice
FROM dbo.DimProduct;
-- Operación que debe ser rechazada
UPDATE dbo.DimProduct
SET EnglishProductName = EnglishProductName
WHERE ProductKey = 210;
-- Operación permitida: consultar auditoría
SELECT TOP 5
    LogId,
    ProductKey,
    Operacion,
    FechaOperacion,
    UsuarioSQL
FROM dbo.LogAuditoriaDimProduct
ORDER BY LogId DESC;
REVERT;
GO