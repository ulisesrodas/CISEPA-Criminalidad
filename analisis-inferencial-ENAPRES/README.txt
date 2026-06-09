Sesion 4 - Inferencia con ENAPRES

Contenido de la carpeta:
- sesion4_enapres_inferencia.qmd: documento principal de clase.
- procesar_enapres_mod600.R: script que calcula indicadores desde los microdatos.
- ENAPRES 2010.sav a ENAPRES 2025.sav: microdatos usados en la sesion.
- enapres_microdatos_indicadores.csv / .sav: base individual con indicadores calculados.
- enapres_indicadores_nacionales.csv / .sav: indicadores nacionales calculados.
- enapres_indicadores_region.csv / .sav: indicadores por region calculados.

Como usar:
1. Abrir RStudio.
2. Establecer esta carpeta como directorio de trabajo.
3. Abrir sesion4_enapres_inferencia.qmd.
4. Ejecutar el QMD.

Si los archivos de resultados no existen o se quieren recalcular, ejecutar primero:
source("procesar_enapres_mod600.R")

El QMD esta preparado para trabajar con todos los archivos en esta misma carpeta.
