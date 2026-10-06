# Proyecto Integrador – Base de Datos Avanzadas y Big Data

**Curso:** CIIN1021P – Base de Datos Avanzadas y Big Data  
**Proyecto:** Sistema integrado de base de datos segura, automatizada e inteligente para el análisis de ventas  
**Fuente principal:** AdventureWorksDW2014  
**Data Warehouse:** AdventureWorksDW_PC5  
**Equipo:** Grupo 7

---

## 1. Descripción general

El proyecto integra tres bloques técnicos evaluados durante el curso:

1. **Automatización y control de datos:** procedimientos almacenados, funciones, triggers, validaciones, transacciones y auditoría.
2. **Seguridad y administración:** roles, privilegios, auditoría, respaldos y optimización mediante índices.
3. **Inteligencia de negocios y Big Data:** Data Warehouse dimensional, ETL, SSAS/OLAP, Power BI y Apache Spark.

La solución parte de **AdventureWorksDW2014** y utiliza como eje analítico las ventas de `FactInternetSales`, trasladadas al Data Warehouse `AdventureWorksDW_PC5` como `FactVentas`.

---

# 2. Alcance y dominio

El dominio corresponde al análisis de operaciones de venta de Adventure Works.

### Fuentes y tablas principales

La solución trabaja con las siguientes estructuras del modelo fuente:

- `FactInternetSales`
- `DimCustomer`
- `DimProduct`
- `DimProductSubcategory`
- `DimProductCategory`
- `DimDate`
- `DimSalesTerritory`
- `DimPromotion`
- `DimCurrency`

La tabla de hechos fuente contiene **60 398 registros de ventas**.

### Requerimientos funcionales

**RF01. Consulta de ventas**  
El sistema debe permitir consultar operaciones registradas en `FactInternetSales` junto con información relacionada de cliente, producto, fecha y territorio.

**RF02. Análisis multidimensional de ventas**  
El sistema debe permitir analizar las ventas mediante dimensiones de tiempo, cliente, producto, territorio, promoción y moneda.

**RF03. Identificación de problemas de calidad**  
El sistema debe permitir detectar y documentar inconsistencias relevantes en los datos antes de su explotación analítica.

---

# 3. [1.1] Relevamiento, supuestos y articulación curricular

## 3.1 Calidad de datos identificada

Durante el relevamiento se identificaron, entre otros, los siguientes problemas:

| Hallazgo | Registros afectados |
|---|---:|
| Productos con `EndDate < StartDate` | 200 |
| Clientes con `NumberChildrenAtHome > TotalChildren` | 1 431 |
| Productos vigentes sin `StandardCost`/`ListPrice` | 2 |
| Productos vigentes asociados a ventas anteriores a su `StartDate` | 22 804 ventas |

Los hallazgos se utilizan como insumo para las validaciones y decisiones de tratamiento.

## 3.2 Supuestos principales

- `FactInternetSales` se considera la fuente transaccional principal para el análisis de ventas.
- Las inconsistencias detectadas no se corrigen directamente sobre la fuente; se controlan durante el tratamiento y transformación.
- El Data Warehouse mantiene la trazabilidad de la información procesada.
- Los resultados analíticos deben conservar consistencia con los registros de origen.

## 3.3 Articulación curricular

El proyecto retoma conocimientos de:

- Modelado E-R y relaciones.
- Normalización hasta 3FN.
- SQL DDL/DML, restricciones y consultas.
- Tratamiento y análisis de datos.

Estos conocimientos se amplían mediante automatización, seguridad, Data Warehouse, ETL, OLAP, Power BI y Spark.

El proyecto prepara al equipo para competencias posteriores relacionadas con **Ciencia de Datos** e **Ingeniería de Software**, especialmente en tratamiento de datos, integración, arquitectura y desarrollo de soluciones.

---

# 4. [1.2] Automatización mediante objetos de BD

La automatización se implementa directamente en SQL Server.

### Componentes

- Procedimientos almacenados:
  - `usp_CargarValidarProducto`
  - `usp_CargarValidarCliente`
- Función escalar reutilizable para clasificación/validación.
- Trigger DML de auditoría.
- Trigger de integridad.
- Tabla de auditoría.
- Manejo de excepciones con `TRY/CATCH`.
- Control transaccional.

### Decisión técnica

Se priorizó la lógica en la base de datos frente a trasladarla completamente a la aplicación debido a:

1. **Centralización:** las reglas se ejecutan de forma consistente independientemente del cliente.
2. **Integridad y trazabilidad:** los triggers y registros de auditoría permiten controlar modificaciones y eventos.

La implementación se encuentra en:

```text
SCRIPTS/
├── 0.BUSQUEDA DE PROBLEMAS DE CALIDAD/
├── 1.PROCEDIMIENTOS ALMACENADOS/
├── 2.FUNCION/
├── 3.TRIGGERS/
└── 4.VALIDACION Y REGISTRO/
```

---

# 5. [1.3] Seguridad y cumplimiento normativo

Se implementó un modelo basado en **mínimo privilegio y separación de responsabilidades**.

### Roles

| Rol | Función principal |
|---|---|
| `rol_Administrador` | Administración y modificación controlada |
| `rol_Analista` | Consulta y análisis |
| `rol_Auditor` | Consulta y revisión de auditoría |

Se crearon usuarios asociados a estos perfiles y se asignaron permisos sobre las tablas del alcance.

### Controles implementados

- Control de acceso mediante roles.
- Separación de privilegios.
- Auditoría de modificaciones.
- Backups FULL y DIFFERENTIAL.
- Prueba de restauración.
- Índice no clusterizado para optimización.

### Evidencia de rendimiento

Para una consulta evaluada, los **logical reads** disminuyeron de **1246 a 4**, aproximadamente **99,68 % menos**, y el plan pasó de `Clustered Index Scan` a `Index Seek`.

---

# 6. [1.4] Integración SQL–NoSQL y decisión arquitectónica

Se evaluaron las diferencias entre el modelo relacional SQL Server y el modelo documental de MongoDB.

### SQL Server

Se mantiene como tecnología principal porque:

- El proyecto requiere integridad referencial.
- Las relaciones entre hechos y dimensiones son estructuradas.
- Las consultas analíticas y agregaciones son centrales.
- El modelo dimensional requiere consistencia entre sus estructuras.

### MongoDB

Se utilizó como referencia práctica para comprender operaciones documentales CRUD y las diferencias frente al modelo relacional.

### Decisión

**SQL Server se mantiene como núcleo de almacenamiento y análisis**, mientras que NoSQL se considera una alternativa complementaria para escenarios donde la flexibilidad documental sea una necesidad específica.

---

# 7. [1.5] Data Warehouse y procesos ETL

Se implementó el Data Warehouse **AdventureWorksDW_PC5** mediante un modelo dimensional basado en **Kimball**.

### Modelo dimensional

**Tabla de hechos:**

- `FactVentas`

**Dimensiones:**

- `DimFecha`
- `DimCliente`
- `DimProducto`
- `DimTerritorio`
- `DimPromocion`
- `DimMoneda`

### ¿Por qué Kimball?

Se seleccionó Kimball frente a Inmon porque:

1. Está orientado directamente al análisis y a la toma de decisiones mediante modelos dimensionales.
2. Permite construir un modelo estrella enfocado en el proceso de ventas y facilitar su consumo por herramientas BI.

### ETL

El proceso implementado con SSIS contempla:

1. Extracción desde AdventureWorksDW2014.
2. Transformación y validación.
3. Carga de dimensiones.
4. Integración de atributos relacionados.
5. Carga de `FactVentas`.
6. Registro de ejecución mediante `LogETL`.
7. Verificación de cantidades cargadas.

### Resultado de la carga

| Tabla | Registros |
|---|---:|
| `DimFecha` | 3 652 |
| `DimCliente` | 18 484 |
| `DimProducto` | 606 |
| `DimTerritorio` | 11 |
| `DimPromocion` | 16 |
| `DimMoneda` | 105 |
| `FactVentas` | 60 398 |
| **Total** | **83 272** |

El proceso ETL fue validado como **EXITOSO** mediante `LogETL`.

---

# 8. [1.6] Dashboard BI, KPIs y OLAP

Se desarrolló un modelo tabular en **SQL Server Analysis Services (SSAS)** denominado:

`OLAP_AdventureWorksDW2014`

El modelo alimenta el dashboard desarrollado en **Power BI**.

## KPIs

| KPI | Fórmula / criterio |
|---|---|
| Ventas Totales | `SUM(FactVentas[ImporteVenta])` |
| Margen Bruto | Ventas Totales − Costo Total |
| Cantidad Vendida | `SUM(FactVentas[Cantidad])` |

### Validación

La fuente mantiene **60 398 registros de ventas**, y los indicadores se contrastan con los resultados obtenidos durante el procesamiento.

### OLAP

Se implementó análisis multidimensional con navegación temporal:

**Año → Mes → Fecha**

Esto permite realizar **drill-down** para pasar de una visión agregada a un mayor nivel de detalle.

---

# 9. [1.7] Apache Spark y evaluación de escalabilidad

Se desarrolló un notebook **PySpark** para procesar `FactVentas`.

### Tecnologías

- Python
- Apache Spark
- PySpark
- Jupyter Notebook
- SQL Server
- JDBC

### Componentes Spark utilizados

1. **DataFrame:** carga de `FactVentas`.
2. **SparkSQL:** consulta y agregación mediante una vista temporal.

La carga contiene **60 398 registros**.

### Agregación

Se calcularon:

- Ventas Totales.
- Margen Bruto.
- Cantidad Vendida.

Resultados:

- Ventas Totales: **29 358 677,2207**
- Margen Bruto: **12 080 883,6450**
- Cantidad Vendida: **60 398**

### Comparación de rendimiento

Prueba reproducida sobre el entorno local:

| Tecnología | Tiempo |
|---|---:|
| SQL Server | **64 ms** |
| Apache Spark | **191,99 ms** |

### Interpretación

SQL Server fue más rápido en este escenario debido al volumen moderado y a que Spark se ejecutó localmente, generando costos de inicialización y coordinación.

Spark resulta más conveniente cuando aumenta significativamente el volumen de datos o cuando se requiere procesamiento distribuido y escalable.

El notebook se encuentra en el repositorio como:

```text
PC7_Spark.ipynb
```

---

# 10. [1.8] Reflexión ética y responsabilidad profesional

## Dilema 1: acceso a información de clientes

El proyecto utiliza información relacionada con clientes. Facilitar el análisis sin controles adecuados podría generar accesos superiores a los necesarios.

**Decisión:** aplicar roles diferenciados de Administrador, Analista y Auditor bajo el principio de mínimo privilegio.

**Consecuencia:** se reduce el riesgo de modificaciones o accesos innecesarios, manteniendo la información disponible para las funciones autorizadas.

## Dilema 2: corrección de datos frente a conservación del origen

Modificar directamente datos inconsistentes puede solucionar un problema, pero también puede afectar la trazabilidad.

**Decisión:** validar y transformar durante el tratamiento, evitando modificar directamente la fuente.

**Consecuencia:** se conserva la trazabilidad y se reduce el riesgo de generar indicadores incorrectos por modificaciones no controladas.

### Responsabilidad profesional

Las decisiones se orientan a proteger la integridad, confidencialidad, disponibilidad y trazabilidad de la información. Si la solución se escalara a un entorno de mayor impacto, deberían reforzarse los controles de acceso, auditoría, calidad y gobernanza de datos.

---

# 11. [1.9] Repositorio y trazabilidad

## Estructura

```text
Grupo7_CIIN1021P_EF_REPO/
├── README.md
├── Informe_Proyecto_Final.pdf
├── Presentacion_EF.pptx
├── MER.png
├── AdventureWorksDW2014.bak
├── CasoPractico02.pbix
├── AdventureWorksDW2014ETL/
├── OLAP_AdventureWorksDW2014/
├── NOTEBOOKS/
│   └── PC7_Spark.ipynb
├── PRACTICAS DE CAMPO/
└── SCRIPTS/
    ├── 0.BUSQUEDA DE PROBLEMAS DE CALIDAD/
    ├── 1.PROCEDIMIENTOS ALMACENADOS/
    ├── 2.FUNCION/
    ├── 3.TRIGGERS/
    ├── 4.VALIDACION Y REGISTRO/
    ├── 5.CREACION USUARIOS, ROLES Y PRIVILEGIOS/
    ├── 6.COPIAS FULL, DIFFERENTIAL Y RESTAURACION/
    ├── 7.MEDICION METRICAS/
    ├── 8.CREACION BASE DATOS POR KIMBALL Y CONSULTA/
    ├── 9.CREACION DE REGISTRO ETL/
    ├── 10.SCRIPT DE CRITERIOS/
    └── SQL – NoSQL/
```

## Matriz de trazabilidad

| Logro / componente | Práctica | Entregable |
|---|---|---|
| Relevamiento y calidad | PC1 | `[1.1]` |
| Automatización SQL | PC2 | `[1.2]` |
| Seguridad y rendimiento | PC3 | `[1.3]` |
| SQL–NoSQL | PC4 | `[1.4]` |
| Data Warehouse y ETL | PC5 | `[1.5]` |
| BI, KPIs y OLAP | PC6 | `[1.6]` |
| Apache Spark | PC7 | `[1.7]` |
| Ética y articulación curricular | PC8 | `[1.8]` |
| Repositorio y trazabilidad | PC8 | `[1.9]` |

---

# 12. Decisiones técnicas verificables

Para la sustentación se deben destacar al menos estas decisiones:

### Decisión 1 – Automatización en SQL Server
Se centralizaron reglas y controles en objetos de BD para mantener consistencia, integridad y trazabilidad.

### Decisión 2 – Seguridad por roles
Se aplicó mínimo privilegio para separar administración, análisis y auditoría.

### Decisión 3 – Kimball
Se eligió un modelo dimensional orientado directamente al análisis de ventas y consumo por herramientas BI.

### Decisión 4 – SQL Server frente a NoSQL
Se mantuvo SQL Server como núcleo por la naturaleza estructurada y relacional del modelo analítico.

### Decisión 5 – SQL Server frente a Spark en el escenario actual
La prueba sobre 60 398 registros mostró **64 ms frente a 191,99 ms**, por lo que SQL Server fue más eficiente para la agregación evaluada. Spark conserva ventaja potencial para escenarios de mayor volumen y procesamiento distribuido.

---

# 13. Componentes a demostrar durante la sustentación

La evaluación exige cubrir los tres bloques del proyecto:

### Bloque 1 – Automatización
Demostrar al menos un procedimiento, trigger o mecanismo de auditoría funcionando.

### Bloque 2 – Seguridad
Demostrar la aplicación de roles/permisos o una evidencia de auditoría.

### Bloque 3 – BI / Big Data
Demostrar el dashboard Power BI y/o el notebook Spark.

Las decisiones presentadas deben estar respaldadas por métricas verificables.

---

# 14. Ejecución rápida

## SQL Server

1. Restaurar `AdventureWorksDW2014.bak`.
2. Ejecutar los scripts en el orden de las carpetas.
3. Crear/usar `AdventureWorksDW_PC5`.
4. Ejecutar el proceso ETL mediante SSIS.
5. Verificar `LogETL`.
6. Procesar el modelo SSAS.
7. Abrir el dashboard Power BI.

## Apache Spark

Requisitos:

- Python
- PySpark
- Jupyter Notebook
- JDBC Driver de SQL Server
- DLL de autenticación de Microsoft JDBC

Abrir el notebook:

```bash
jupyter notebook
```

Ejecutar las celdas en orden y verificar la carga de **60 398 registros** y la comparación SQL Server vs Spark.

---

# 15. Requisitos de herramientas

| Herramienta | Uso |
|---|---|
| SQL Server / SSMS | BD, consultas, seguridad y administración |
| SSIS | ETL |
| SSAS | Modelo tabular / OLAP |
| Power BI | Dashboard y visualización |
| Python / PySpark | Big Data |
| Jupyter Notebook | Evidencia de Spark |
| MongoDB / mongosh | Práctica SQL–NoSQL |
| Git / GitHub | Control y trazabilidad |

Las herramientas utilizadas en el proyecto corresponden a las tecnologías contempladas en las prácticas y entregables del curso.

---

# 16. Checklist final de entrega

- [ ] Informe final en PDF.
- [ ] Repositorio Git con README.
- [ ] Scripts `.sql`.
- [ ] Notebook `.ipynb`.
- [ ] Archivo `.pbix`.
- [ ] Proyecto/configuración ETL.
- [ ] Modelo SSAS.
- [ ] Diagrama MER/modelo dimensional.
- [ ] Evidencias de automatización.
- [ ] Evidencias de seguridad.
- [ ] Evidencias de calidad de datos.
- [ ] Evidencias de ETL y `LogETL`.
- [ ] Evidencias del dashboard y KPIs.
- [ ] Evidencia de Spark y comparación de tiempos.
- [ ] Matriz de trazabilidad.
- [ ] Declaración de uso de IA como anexo del informe, según las condiciones de entrega.
- [ ] Presentación de la EF, si corresponde.

---

## Nota

Este README funciona como **guía técnica y de trazabilidad del repositorio**. Los scripts, notebooks, modelos, dashboard y evidencias constituyen la documentación verificable de cada componente del proyecto.
