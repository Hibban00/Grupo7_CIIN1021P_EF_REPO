USE AdventureWorksDW2014;
GO

--Creacion de la función escalar
--para uno de los problemas de calidad
--NumberChildrenAtHome > TotalChildren
CREATE OR ALTER FUNCTION dbo.ufn_ClasificarHijosCliente
(
    @TotalChildren TINYINT,
    @NumberChildrenAtHome TINYINT
)
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @Resultado VARCHAR(30);

    IF @TotalChildren IS NULL
       OR @NumberChildrenAtHome IS NULL
    BEGIN
        SET @Resultado = 'DATOS INCOMPLETOS';
    END
    ELSE IF @NumberChildrenAtHome > @TotalChildren
    BEGIN
        SET @Resultado = 'DATO INCONSISTENTE';
    END
    ELSE
    BEGIN
        SET @Resultado = 'DATO CONSISTENTE';
    END;

    RETURN @Resultado;
END;
GO

--Prueba con DimCustomer sobre los 20 primeros
SELECT TOP 20
    CustomerKey,
    FirstName as Nombre,
    LastName as Apellido,
    TotalChildren as TotalNinos,
    NumberChildrenAtHome as NroNinosEnHogar,
    dbo.ufn_ClasificarHijosCliente(
        TotalChildren,
        NumberChildrenAtHome
    ) AS Clasificacion
FROM dbo.DimCustomer
ORDER BY CustomerKey;

--Prueba con DimCustomer sobre los 20 primeros 
--datos que coinciden con el problema de calidad
SELECT TOP 20
    CustomerKey,
    FirstName as Nombre,
    LastName as Apellido,
    TotalChildren as TotalNinos,
    NumberChildrenAtHome as NroNinosEnHogar,
    dbo.ufn_ClasificarHijosCliente(
        TotalChildren,
        NumberChildrenAtHome
    ) AS Clasificacion
FROM dbo.DimCustomer
WHERE NumberChildrenAtHome > TotalChildren
ORDER BY CustomerKey;