# Análisis Inferencial de Criminalidad y Victimización (ENAPRES) 🇵🇪

Este proyecto contiene un flujo de trabajo analítico (ETL y modelamiento) diseñado para procesar, visualizar y analizar estadísticamente los microdatos de la Encuesta Nacional de Programas Estratégicos (ENAPRES) del INEI, enfocándose en el módulo de seguridad ciudadana (2010-2025).

El objetivo principal es reconstruir series de tiempo comparables y aplicar estadística inferencial para entender las dinámicas de la victimización, la percepción de inseguridad y la confianza institucional en el Perú.

## 🛠️ Tecnologías y Paquetes Utilizados
* **Lenguaje:** R
* **Documentación y Reportes:** Quarto (`.qmd`) y archivo .R para reportes reproducibles en PDF y HTML.
* **Manipulación de Datos:** `tidyverse`, `janitor`, `haven`.
* **Visualización:** `ggplot2`, `plotly`, `patchwork`, `paletteer`.
* **Inferencia y Diseños Complejos:** `survey` (para estimaciones ponderadas con factores de expansión).

## 📂 Arquitectura del Proyecto (Pipeline)

El repositorio está estructurado para separar el procesamiento pesado de la generación de reportes, optimizando la memoria y garantizando la reproducibilidad:

1. **Insumos (Microdatos INEI):** Archivos originales en `.sav` (SPSS). *Nota: Por buenas prácticas y tamaño, estos archivos están ignorados en el control de versiones mediante `.gitignore`.*
2. **Procesamiento de Datos (`procesar_enapres_mod600.R`):** El "motor" del proyecto. Este script lee las encuestas originales, filtra universos válidos, aplica factores de expansión y transforma las variables del cuestionario en indicadores binarios limpios. Exporta los resultados consolidados en formato `.csv` y `.sav`.
3. **Análisis y Reporte (`ENAPRES inferencia.qmd`):** El documento final. Importa los indicadores ya calculados y ejecuta el análisis exploratorio de datos (EDA) territorial y longitudinal.

## 📊 Principales Análisis Incluidos

* **Reconstrucción de Series (2010-2025):** Evolución temporal de victimización, estafas, robo y confianza en la Policía Nacional del Perú (PNP), considerando los cambios de estructura del cuestionario (Capítulos 600 y 400).
* **Brechas Territoriales:** Mapas de calor y análisis de dispersión cruzando victimización real vs. percepción al caminar de noche a nivel departamental.
* **Estadística Inferencial Poblacional:** 
  * Cálculo de intervalos de confianza al 95% utilizando el diseño de muestras complejas.
  * Pruebas de asociación bivariada (Rao-Scott chi-square).
  * Modelamiento predictivo mediante **Regresión Logística** (`quasibinomial`) para estimar los *Odds Ratios* de la probabilidad de victimización controlando por variables sociodemográficas como sexo y edad.

## 🚀 Cómo ejecutar este proyecto localmente

1. Clona este repositorio.
2. Descarga los microdatos originales de la ENAPRES desde el portal del INEI y colócalos en la misma carpeta
3. Ejecuta primero el script `procesar_enapres_mod600.R` para generar las bases limpias en la carpeta de resultados.
4. Renderiza el documento Quarto (`ENAPRES inferencia.qmd`) en RStudio, Positron o desde la terminal (`quarto render`) para obtener el informe final completo. 