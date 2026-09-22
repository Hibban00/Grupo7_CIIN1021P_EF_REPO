# Grupo 7 – Proyecto Integrador CIIN1021P

## Base de Datos Avanzadas y Big Data

Repositorio oficial del Grupo 7 correspondiente al Proyecto Integrador del curso **Base de Datos Avanzadas y Big Data (CIIN1021P)**.

El proyecto desarrolla una solución basada en **AdventureWorksDW2014**, orientada al tratamiento, automatización, seguridad, integración y análisis de información de ventas.

---

## 📌 Descripción del proyecto

El proyecto aborda el procesamiento y análisis de información de ventas mediante una solución que integra los siguientes componentes:

- Diagnóstico y validación de calidad de datos.
- Automatización mediante procedimientos almacenados, funciones y triggers.
- Auditoría de operaciones.
- Gestión de usuarios, roles y privilegios.
- Copias de seguridad y restauración.
- Evaluación de rendimiento e índices.
- Integración SQL Server – NoSQL.
- Diseño de un Data Warehouse.
- Procesos ETL mediante SQL Server Integration Services (SSIS).
- Registro y verificación de ejecuciones ETL.
- Análisis y visualización mediante Power BI.

La fuente principal de datos utilizada es **AdventureWorksDW2014**.

---

## 🗃️ Fuente de datos

El proyecto utiliza la base de datos:

**AdventureWorksDW2014**

Archivo incluido en este repositorio:

```text
AdventureWorksDW2014.bak
```

Fuente original de descarga:

https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2014.bak

---

## 📂 Estructura del repositorio

```text
Grupo7_CIIN1021P_EF_REPO-main/
│
├── 2026-1_ISC-Informe_Proyecto Final_Base de Datos Avanzadas y Big Data.docx
├── AdventureWorksDW2014.bak
├── CasoPractico02.pbix
├── Grupo7_CIIN1021P_EP.pdf
├── MER.png
├── Título y Contexto.docx
│
├── AdventureWorksDW2014ETL/
│   ├── AdventureWorksDW2014ETL.slnx
│   └── AdventureWorksDW2014ETL/
│       ├── AdventureWorksDW2014ETL.database
│       ├── AdventureWorksDW2014ETL.dtproj
│       ├── ETL_AdventureWorks.dtsx
│       ├── Package.dtsx
│       ├── Project.params
│       ├── bin/
│       └── obj/
│
├── PRACTICAS DE CAMPO/
│   ├── PRACTICA DE CAMPO 1.pdf
│   ├── PRACTICA DE CAMPO 2.pdf
│   ├── PRACTICA DE CAMPO 3.pdf
│   ├── PRÁCTICA DE CAMPO 4.pdf
│   └── PRACTICA DE CAMPO 5.pdf
│
└── SCRIPTS/
    ├── Consulta de Nueva Base de Datos y Log.sql
    ├── Creacion de Base de Datos Kimpball.sql
    ├── Creación de registro de ejecución para ETL.sql
    ├── Creación y verificación de DIFFERENTIAL backup.sql
    ├── Creación y verificación de FULL backup.sql
    ├── Crear de roles y sus privilegios.sql
    ├── Crear una base, colección y CRUD.txt
    ├── Criterios comparativos SQL-NoSQL.txt
    ├── Criterio_Verificable_RFs.sql
    ├── Funcion Escalar.sql
    ├── Medición de Metricas Indice.sql
    ├── PC1.sql
    ├── Procedimiento 1 usp_CargarValidarProducto.sql
    ├── Procedimiento 2 usp_CargarValidarCliente.sql
    ├── Prueba de Restauración de backup.sql
    ├── Script de creacion de colección para MongoDB.sql
    ├── SCRIPT Prueba registros de auditoria.sql
    ├── SCRIPT registros de auditoría.sql
    ├── Trigger 1 DML DE AUDITORÍA.sql
    └── Trigger 2 DE INTEGRIDAD.sql
```

---

## 📚 Prácticas de Campo

La carpeta `PRACTICAS DE CAMPO` contiene las cinco prácticas desarrolladas durante el proyecto:

- Práctica de Campo 1
- Práctica de Campo 2
- Práctica de Campo 3
- Práctica de Campo 4
- Práctica de Campo 5

Estos documentos registran el desarrollo progresivo de las actividades y componentes técnicos del proyecto.

---

## ⚙️ Scripts SQL

La carpeta `SCRIPTS` contiene los scripts utilizados durante el desarrollo y validación de los diferentes componentes.

### Automatización

Incluye scripts relacionados con:

- Procedimientos almacenados.
- Funciones escalares.
- Triggers de auditoría.
- Triggers de integridad.
- Validación de datos.
- Registro de operaciones.

### Seguridad y administración

Incluye scripts relacionados con:

- Creación de usuarios y roles.
- Asignación de privilegios.
- Copias de seguridad FULL.
- Copias de seguridad DIFFERENTIAL.
- Restauración y verificación de backups.
- Medición de métricas de índices.

### Integración y ETL

Incluye scripts relacionados con:

- Creación de la base de datos dimensional.
- Registro de ejecución de procesos ETL.
- Consulta y verificación de logs.
- Procedimientos utilizados durante la carga.
- Scripts de apoyo para la integración.

### SQL – NoSQL

Incluye archivos relacionados con:

- Comparación de alternativas SQL y NoSQL.
- Creación de base de datos y colección.
- Operaciones CRUD.
- Scripts relacionados con MongoDB.

### Requerimientos funcionales

El archivo `Criterio_Verificable_RFs.sql` contiene las consultas utilizadas para verificar los criterios de éxito de los requerimientos funcionales definidos para el proyecto.

---

## 🔄 Proyecto ETL

La carpeta `AdventureWorksDW2014ETL/` contiene el proyecto desarrollado mediante **SQL Server Integration Services (SSIS)**.

Entre sus componentes principales se encuentran:

- `AdventureWorksDW2014ETL.slnx`
- `AdventureWorksDW2014ETL.dtproj`
- `ETL_AdventureWorks.dtsx`
- `Package.dtsx`
- `Project.params`

Estos archivos corresponden al proyecto utilizado para realizar el proceso de extracción, transformación y carga de información hacia el Data Warehouse.

---

## 📊 Business Intelligence

El archivo `CasoPractico02.pbix` corresponde al dashboard desarrollado en **Power BI** para el análisis y visualización de los datos procesados durante el proyecto.

---

## 🧩 Modelo Entidad-Relación

El archivo `MER.png` contiene el Modelo Entidad-Relación utilizado como parte del diseño de la solución.

---

## 🛠️ Herramientas utilizadas

Las principales herramientas utilizadas en el proyecto son:

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL Server Integration Services (SSIS)
- Power BI
- MongoDB
- mongosh
- Visual Studio
- Git
- GitHub

---

## 🚀 Requisitos

Para reproducir los componentes principales del proyecto se requiere disponer de:

- Microsoft SQL Server.
- SQL Server Management Studio (SSMS).
- SQL Server Integration Services (SSIS), para ejecutar el proyecto ETL.
- Visual Studio con las herramientas necesarias para proyectos SSIS.
- Power BI Desktop, para abrir el archivo `.pbix`.
- MongoDB y/o mongosh para los componentes correspondientes a NoSQL.
- Git, para clonar el repositorio.

---

## ▶️ Ejecución

### 1. Restaurar AdventureWorksDW2014

Utilizar el archivo `AdventureWorksDW2014.bak` para restaurar la base de datos en SQL Server.

### 2. Ejecutar los scripts SQL

Los scripts ubicados en `SCRIPTS/` deben ejecutarse desde SQL Server Management Studio según el componente que se desee implementar o verificar.

Se recomienda revisar previamente las dependencias de cada script y la base de datos sobre la cual debe ejecutarse.

### 3. Ejecutar el proyecto ETL

Abrir:

```text
AdventureWorksDW2014ETL/AdventureWorksDW2014ETL.slnx
```

desde el entorno compatible con el proyecto SSIS.

Posteriormente, configurar las conexiones necesarias y ejecutar los paquetes ETL correspondientes.

### 4. Verificar la carga

Después de ejecutar el proceso ETL, se deben verificar los registros generados en el log de ejecución y los conteos de las tablas correspondientes.

### 5. Visualizar el dashboard

Abrir `CasoPractico02.pbix` utilizando Power BI Desktop.

---

## 🔎 Validación

El proyecto incluye mecanismos para verificar:

- Calidad de los datos.
- Integridad de la información.
- Registro de operaciones.
- Control de acceso.
- Copias de seguridad y restauración.
- Rendimiento de consultas.
- Ejecución de procesos ETL.
- Registros procesados y cargados.
- Resultados del análisis mediante Power BI.

---

## 📄 Documentación

El repositorio incluye el informe final:

`2026-1_ISC-Informe_Proyecto Final_Base de Datos Avanzadas y Big Data.docx`

También incluye la Evaluación Parcial:

`Grupo7_CIIN1021P_EP.pdf`

y el documento:

`Título y Contexto.docx`

Estos archivos contienen la documentación correspondiente al desarrollo del proyecto.

---

## 👥 Equipo

**Grupo 7**

**Curso:** Base de Datos Avanzadas y Big Data – CIIN1021P

---

## 🔗 Repositorio

Repositorio oficial:

https://github.com/Hibban00/Grupo7_CIIN1021P_EF_REPO
