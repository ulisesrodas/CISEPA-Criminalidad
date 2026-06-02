# Análisis de Bases de Datos Policiales: Importación, Limpieza y Diagnóstico

Este repositorio contiene los scripts y reportes correspondientes al procesamiento de bases reales de información policial. El objetivo central del proyecto es establecer una ruta ordenada para gestionar datos criminales, desde la ingesta de archivos crudos hasta la consolidación de una base distrital integrada.

## 📄 Archivos Principales del Proyecto

El corazón de este repositorio se compone del código fuente documentado y sus respectivas salidas renderizadas:

*   **`bases de datos policiales.qmd`**: El script principal de Quarto. Contiene todo el código en R, paso a paso, con las funciones de limpieza, cruces espaciales y visualización.
*   **`bases_de_datos_policiales.html`**: Reporte dinámico y renderizado del análisis. Ideal para explorar interactivamente los gráficos (construidos con `plotly`) y el código ejecutado directamente en el navegador.
*   **`bases-de-datos-policiales.pdf`**: Versión estática del documento renderizado, optimizada para la lectura lineal, revisión metodológica e impresión.

## 🎯 Objetivos del Proyecto

*   **Importación multiformato:** Lectura de bases de datos desde archivos CSV, Excel (`.xlsx`) y SPSS (`.sav`).
*   **Diagnóstico de calidad:** Revisión de la estructura de las bases, detección de valores perdidos, e identificación de duplicados exactos y por variables clave.
*   **Estandarización de datos:** Limpieza de nombres de variables, corrección de codificación (UTF-8 y Latin1), y homologación a texto de variables espaciales (el `ubigeo` a 6 dígitos).
*   **Agrupación y transformaciones:** Creación de los primeros indicadores descriptivos (como totales de denuncias por año, modalidades principales y estado del parque automotor).
*   **Integración de datos (Joins):** Fusión territorial de bases (`left_join`) a nivel de distrito, empleando el ubigeo y llaves textuales compuestas.
*   **Visualización exploratoria:** Elaboración de gráficos estáticos e interactivos para analizar la distribución y relación entre denuncias reportadas (2024-2026) y recursos policiales disponibles.

## 📂 Fuentes de Datos Utilizadas

El análisis emplea insumos reales desagregados en múltiples dimensiones:
*   `denuncias.csv`: Registros de denuncias agrupadas por modalidad, periodo (año/mes) y ubigeo.
*   `personal.csv`: Información sobre la cantidad y distribución del personal policial por dependencia y categoría.
*   `parque.csv`: Inventario del parque automotor de la PNP clasificado por su estado operativo.
*   `infraestructura.xlsx`: Datos sobre la infraestructura, servicios básicos y estado de las comisarías.
*   `comisarias_geo.csv` / `comisarias_lima.sav`: Ubicación georreferenciada de las dependencias policiales.

## 🛠️ Tecnologías y Paquetes de R

Todo el ecosistema de análisis se construyó en **R** utilizando **Quarto** (`.qmd`) para garantizar la reproducibilidad funcional e investigativa.
*   **Gestión, manipulación y limpieza:** `tidyverse`, `janitor`, `here`.
*   **Lectura de datos externos:** `readxl`, `haven`.
*   **Diagnóstico exploratorio:** `skimr`, `naniar`, `DataExplorer`.
*   **Gráficos e interacción:** `scales`, `plotly`.

## 📦 Entregables y Resultados

Al ejecutar el flujo completo de validaciones e integración, el pipeline exporta de manera automatizada tres bases de datos limpias y documentadas para análisis posteriores:

1.  `base_sesion2.csv`: La tabla maestra integrada por distritos que concentra las denuncias y cruza de manera validada la información de los vehículos operativos y número de comisarías.
2.  `diccionario_sesion2.csv`: Un diccionario de datos mínimo que documenta de forma explícita el significado y tipo de variable de la base maestra.
3.  `indicadores_sesion2.csv`: Una versión reestructurada en formato largo (long format) para facilitar comparaciones y representaciones visuales.
