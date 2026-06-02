# Análisis Descriptivo Municipal (RENAMU): Recursos y Seguridad Ciudadana

Este repositorio contiene los scripts y reportes del análisis exploratorio basado en el Registro Nacional de Municipalidades (RENAMU) del INEI. El objetivo principal de este proyecto es procesar, limpiar y explorar estadísticamente la información sobre los recursos logísticos y humanos que los gobiernos locales destinan a la seguridad ciudadana y gestión municipal.

## 📄 Archivos Principales del Proyecto

La carpeta se compone del código fuente documentado y sus respectivas salidas renderizadas para facilitar su lectura e interactividad:

* **`analisis descriptivo municipal.qmd`**: El script principal de Quarto. Contiene todo el flujo de trabajo en R: desde la importación de las bases de datos del INEI hasta la limpieza, manejo de valores perdidos y generación de visualizaciones.
* **`analisis_descriptivo_municipal.html`**: Reporte dinámico y renderizado del análisis. Ideal para revisar las tablas, leer el código y explorar los gráficos de manera interactiva directamente en el navegador web.
* **`analisis-descriptivo-municipal.pdf`**: Versión estática y formal del documento, optimizada para la lectura lineal, revisión metodológica y fácil distribución.

## 🎯 Objetivos del Proyecto

* **Importación y Limpieza:** Carga estructurada de las bases de datos del RENAMU, estandarización de los nombres de las variables (usando `clean_names`) y manejo de caracteres especiales.
* **Estandarización Territorial:** Tratamiento exhaustivo de la variable `ubigeo` (asegurando el formato de texto de 6 dígitos con ceros a la izquierda) para garantizar compatibilidad en futuras fusiones territoriales.
* **Diagnóstico de Calidad:** Identificación de valores perdidos (NAs) y registros atípicos dentro de las variables de gestión municipal.
* **Análisis de Recursos:** Exploración descriptiva de variables clave, como la cantidad de efectivos de Serenazgo, vehículos operativos, cámaras de videovigilancia y presupuesto destinado a seguridad por distrito.
* **Visualización Descriptiva:** Elaboración de gráficos que permiten entender rápidamente la distribución, concentración y carencia de recursos municipales a nivel nacional.

## 📂 Fuentes de Datos Utilizadas

El análisis emplea microdatos oficiales provenientes del **Instituto Nacional de Estadística e Informática (INEI)**:
* **Bases de Datos RENAMU:** Archivos que recogen información declarada por las municipalidades provinciales y distritales, con un enfoque específico en los módulos de seguridad ciudadana y gestión local.
* **Link**: [Microdatos INEI](https://proyectos.inei.gob.pe/microdatos/) y buscamos a RENAMU en las encuestas.

## 🛠️ Tecnologías y Paquetes de R

Todo el ecosistema de análisis se construyó en **R** utilizando **Quarto** (`.qmd`) para asegurar una investigación completamente reproducible.
* **Manipulación, limpieza y estandarización:** `tidyverse` (dplyr, tidyr, stringr), `janitor`, `here`.
* **Diagnóstico exploratorio:** Paquetes para la rápida detección de estructura y valores faltantes (`skimr`, `naniar`, `DataExplorer`).
* **Gráficos e interacción:** `ggplot2` para las visualizaciones base, `scales` para el formato de ejes y `plotly` para volver los gráficos interactivos en la versión web.

## 📦 Entregables y Resultados Generados

El pipeline de trabajo exporta información limpia y lista para la toma de decisiones o cruces posteriores:
1.  **Tablas Resumen:** Agrupaciones consolidadas por departamento, provincia y distrito sobre la capacidad logística municipal.
2.  **Reportes Finales:** Documentos renderizados (`.html` y `.pdf`) que sirven como bitácora analítica y presentación formal de los hallazgos.
