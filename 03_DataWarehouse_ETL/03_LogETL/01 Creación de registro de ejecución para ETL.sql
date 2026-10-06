USE AdventureWorksDW_PC5;
GO

--Creación de registro de ejecución.
CREATE TABLE dbo.LogETL
(
    LogETLKey INT IDENTITY(1,1) NOT NULL,
    Proceso NVARCHAR(100) NOT NULL,
    FechaInicio DATETIME2 NOT NULL,
    FechaFin DATETIME2 NULL,
    RegistrosProcesados INT NULL,
    Estado NVARCHAR(20) NOT NULL,
    Mensaje NVARCHAR(500) NULL,

    CONSTRAINT PK_LogETL
        PRIMARY KEY (LogETLKey)
);
GO