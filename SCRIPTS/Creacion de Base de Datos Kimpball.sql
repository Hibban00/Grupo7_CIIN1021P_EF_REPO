CREATE DATABASE AdventureWorksDW_PC5;
GO

USE AdventureWorksDW_PC5;
GO

-- DIMENSIÓN FECHA
CREATE TABLE dbo.DimFecha
(
    FechaKey INT NOT NULL,
    Fecha DATE NOT NULL,
    NumeroDiaSemana TINYINT NOT NULL,
    NombreDiaSemana NVARCHAR(10) NOT NULL,
    NumeroDiaMes TINYINT NOT NULL,
    NumeroDiaAnio SMALLINT NOT NULL,
    NumeroSemanaAnio TINYINT NOT NULL,
    NombreMes NVARCHAR(10) NOT NULL,
    NumeroMes TINYINT NOT NULL,
    Trimestre TINYINT NOT NULL,
    Anio SMALLINT NOT NULL,
    Semestre TINYINT NOT NULL,
    TrimestreFiscal TINYINT NOT NULL,
    AnioFiscal SMALLINT NOT NULL,
    SemestreFiscal TINYINT NOT NULL,

    CONSTRAINT PK_DimFecha PRIMARY KEY (FechaKey)
);
GO
-- DIMENSIÓN CLIENTE
CREATE TABLE dbo.DimCliente
(
    ClienteDWKey INT IDENTITY(1,1) NOT NULL,
    ClienteKey INT NOT NULL,
    CodigoCliente NVARCHAR(15) NOT NULL,
    Tratamiento NVARCHAR(8) NULL,
    Nombre NVARCHAR(50) NULL,
    SegundoNombre NVARCHAR(50) NULL,
    Apellido NVARCHAR(50) NULL,
    FechaNacimiento DATE NULL,
    EstadoCivil NCHAR(1) NULL,
    Sufijo NVARCHAR(10) NULL,
    Genero NVARCHAR(1) NULL,
    CorreoElectronico NVARCHAR(50) NULL,
    IngresoAnual DECIMAL(19,4) NULL,
    TotalHijos TINYINT NULL,
    HijosEnCasa TINYINT NULL,
    Educacion NVARCHAR(40) NULL,
    Ocupacion NVARCHAR(100) NULL,
    PropietarioVivienda NCHAR(1) NULL,
    CantidadVehiculos TINYINT NULL,
    FechaPrimeraCompra DATE NULL,
    DistanciaTraslado NVARCHAR(15) NULL,

    CONSTRAINT PK_DimCliente PRIMARY KEY (ClienteDWKey)
);
GO
-- DIMENSIÓN PRODUCTO
CREATE TABLE dbo.DimProducto
(
    ProductoDWKey INT IDENTITY(1,1) NOT NULL,
    ProductoKey INT NOT NULL,
    CodigoProducto NVARCHAR(25) NULL,
    NombreProducto NVARCHAR(50) NOT NULL,
    CostoEstandar DECIMAL(19,4) NULL,
    ProductoTerminado BIT NOT NULL,
    Color NVARCHAR(15) NOT NULL,
    NivelStockSeguridad SMALLINT NULL,
    PuntoReorden SMALLINT NULL,
    PrecioLista DECIMAL(19,4) NULL,
    Talla NVARCHAR(50) NULL,
    RangoTalla NVARCHAR(50) NULL,
    Peso DECIMAL(18,4) NULL,
    DiasFabricacion INT NULL,
    LineaProducto NCHAR(2) NULL,
    PrecioDistribuidor DECIMAL(19,4) NULL,
    Clase NCHAR(2) NULL,
    Estilo NCHAR(2) NULL,
    Modelo NVARCHAR(50) NULL,
    FechaInicio DATE NULL,
    FechaFin DATE NULL,
    Estado NVARCHAR(7) NULL,
    Subcategoria NVARCHAR(50) NULL,
    Categoria NVARCHAR(50) NULL,

    CONSTRAINT PK_DimProducto PRIMARY KEY (ProductoDWKey)
);
GO
-- DIMENSIÓN TERRITORIO
CREATE TABLE dbo.DimTerritorio
(
    TerritorioDWKey INT IDENTITY(1,1) NOT NULL,
    TerritorioKey INT NOT NULL,
    CodigoTerritorio INT NULL,
    Region NVARCHAR(50) NOT NULL,
    Pais NVARCHAR(50) NOT NULL,
    GrupoTerritorio NVARCHAR(50) NULL,

    CONSTRAINT PK_DimTerritorio PRIMARY KEY (TerritorioDWKey)
);
GO
-- DIMENSIÓN PROMOCIÓN
CREATE TABLE dbo.DimPromocion
(
    PromocionDWKey INT IDENTITY(1,1) NOT NULL,
    PromocionKey INT NOT NULL,
    CodigoPromocion INT NULL,
    NombrePromocion NVARCHAR(255) NULL,
    PorcentajeDescuento DECIMAL(10,4) NULL,
    TipoPromocion NVARCHAR(50) NULL,
    CategoriaPromocion NVARCHAR(50) NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    CantidadMinima INT NULL,
    CantidadMaxima INT NULL,

    CONSTRAINT PK_DimPromocion PRIMARY KEY (PromocionDWKey)
);
GO
-- DIMENSIÓN MONEDA
CREATE TABLE dbo.DimMoneda
(
    MonedaDWKey INT IDENTITY(1,1) NOT NULL,
    MonedaKey INT NOT NULL,
    CodigoMoneda NCHAR(3) NOT NULL,
    NombreMoneda NVARCHAR(50) NOT NULL,

    CONSTRAINT PK_DimMoneda PRIMARY KEY (MonedaDWKey)
);
GO


--Creacion de Tabla de Hechos
CREATE TABLE dbo.FactVentas
(
    VentaKey BIGINT IDENTITY(1,1) NOT NULL,

    -- Claves hacia las dimensiones
    FechaKey INT NOT NULL,
    ClienteDWKey INT NOT NULL,
    ProductoDWKey INT NOT NULL,
    TerritorioDWKey INT NOT NULL,
    PromocionDWKey INT NOT NULL,
    MonedaDWKey INT NOT NULL,

    -- Identificación de la venta
    NumeroPedido NVARCHAR(20) NOT NULL,
    NumeroLinea TINYINT NOT NULL,
    NumeroRevision TINYINT NOT NULL,

    -- Medidas
    Cantidad SMALLINT NOT NULL,
    PrecioUnitario DECIMAL(19,4) NOT NULL,
    ImporteExtendido DECIMAL(19,4) NOT NULL,
    PorcentajeDescuento DECIMAL(10,4) NOT NULL,
    ImporteDescuento DECIMAL(19,4) NOT NULL,
    CostoEstandarProducto DECIMAL(19,4) NOT NULL,
    CostoTotalProducto DECIMAL(19,4) NOT NULL,
    ImporteVenta DECIMAL(19,4) NOT NULL,
    Impuesto DECIMAL(19,4) NOT NULL,
    Flete DECIMAL(19,4) NOT NULL,

    CONSTRAINT PK_FactVentas
        PRIMARY KEY (VentaKey),

    CONSTRAINT FK_FactVentas_DimFecha
        FOREIGN KEY (FechaKey)
        REFERENCES dbo.DimFecha(FechaKey),

    CONSTRAINT FK_FactVentas_DimCliente
        FOREIGN KEY (ClienteDWKey)
        REFERENCES dbo.DimCliente(ClienteDWKey),

    CONSTRAINT FK_FactVentas_DimProducto
        FOREIGN KEY (ProductoDWKey)
        REFERENCES dbo.DimProducto(ProductoDWKey),

    CONSTRAINT FK_FactVentas_DimTerritorio
        FOREIGN KEY (TerritorioDWKey)
        REFERENCES dbo.DimTerritorio(TerritorioDWKey),

    CONSTRAINT FK_FactVentas_DimPromocion
        FOREIGN KEY (PromocionDWKey)
        REFERENCES dbo.DimPromocion(PromocionDWKey),

    CONSTRAINT FK_FactVentas_DimMoneda
        FOREIGN KEY (MonedaDWKey)
        REFERENCES dbo.DimMoneda(MonedaDWKey)
);
GO