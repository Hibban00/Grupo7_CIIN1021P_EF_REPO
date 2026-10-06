USE AdventureWorksDW2014;
GO

--
BEGIN TRY
    BEGIN TRANSACTION;
    -- 1. INSERT: crear producto de prueba
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
        'TEST-PC2-AUD',
        'Producto Prueba Auditoria',
        'Producto Prueba Auditoria',
        'Produit Test Audit',
        1,
        'Test',
        GETDATE(),
        NULL,
        'Current'
    );
    DECLARE @ProductKeyPrueba INT;
    SELECT @ProductKeyPrueba = ProductKey
    FROM dbo.DimProduct
    WHERE ProductAlternateKey = 'TEST-PC2-AUD';
    -- 2. UPDATE: modificar el producto de prueba
    UPDATE dbo.DimProduct
    SET EnglishProductName = 'Producto Prueba Auditoria UPDATE'
    WHERE ProductKey = @ProductKeyPrueba;
    -- 3. DELETE: eliminar el producto de prueba
    DELETE FROM dbo.DimProduct
    WHERE ProductKey = @ProductKeyPrueba;
    -- Confirmar las tres operaciones
    COMMIT TRANSACTION;
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
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    SELECT
        ERROR_NUMBER() AS NumeroError,
        ERROR_MESSAGE() AS MensajeError,
        'PROCESO REVERTIDO' AS Estado;

END CATCH;
GO