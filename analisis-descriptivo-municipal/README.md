# Análisis descriptivo municipal

Esta carpeta contiene todos los archivos necesarios para trabajar en RStudio (o Positron) y en SPSS.

Esta version incluye una seccion ampliada de visualizaciones con `ggplot2`, `plotly`, `patchwork`, `hrbrthemes`, `paletteer`, `ggridges` y `ggbeeswarm`.

## Como usar

1. Descargar todos los archivos de esta carpeta.
2. Abrir `analisis_descriptivo_municipal.qmd` en RStudio.
3. Ejecutar primero los bloques:
   - Instalar paquetes
   - Activar paquetes
   - Ubicar archivos
4. Luego ejecutar el resto del documento por secciones o usar `Render`.
5. Si se prefiere, en vez de ejecutar por secciones, se puede usar `Render` para ejecutar todo de una vez y visualizar el HTML final

## Archivos principales

- `analisis_descriptivo_municipal.qmd`: Documento principal en formato Quarto.
- `analisis_descriptivo_municipal`: Disponible en HTML y pdf.
- `renamu2025.csv`: Base RENAMU 2025.
- `Base-Datos_2025_f_.sav`: Base RENAMU 2025 en formato para SPSS, extraída de Microdatos del INEI.
- `dict_renamu2025.pdf`: diccionario de variables de RENAMU 2025.

## Archivos complementarios

- `Sintaxis1.sps`: Contiene los códigos para desplegar el análisis de tablas y gráficos en SPSS.
- `Resultado1.spv`: Resultado de la sintaxis anterior.
- `anexo8.xlsx`
- `base_celular.xlsx`
- `data_prepara.xlsx`
- `robo_celular_sidpol.xlsx`
