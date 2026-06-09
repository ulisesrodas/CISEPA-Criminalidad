* Encoding: UTF-8.
* Sesión 4 - ENAPRES 2023.
* Calcula indicadores de victimización, percepción de inseguridad y confianza en la PNP.
* La sintaxis conserva la base original y agrega variables nuevas.

* 1. Universo de análisis: población urbana de 15 años a más y residente habitual.
COMPUTE filtro_urbano_15 =
  (AREA = 1 AND RESFIN < 3 AND P208_A >= 15 AND P208_A < 99).

COMPUTE filtro_residente =
  ((P204 = 1 AND P205 = 2) OR (P204 = 2 AND P206 = 1)).

COMPUTE filtro_modulo600 =
  (P600_C <> 99).

COMPUTE filtro_enapres =
  (filtro_urbano_15 = 1 AND filtro_residente = 1 AND filtro_modulo600 = 1).

VARIABLE LABELS
  filtro_urbano_15 "Filtro: área urbana, residente final y 15 años a más"
  filtro_residente "Filtro: residente habitual"
  filtro_modulo600 "Filtro: módulo 600 no omitido"
  filtro_enapres "Filtro general para indicadores ENAPRES".

VALUE LABELS filtro_urbano_15 filtro_residente filtro_modulo600 filtro_enapres
  0 "No"
  1 "Sí".
EXECUTE.

* 2. Región final: separa Lima Metropolitana de Región Lima.
NUMERIC region_final (F2.0).
IF (CCDD = '01') region_final = 1.
IF (CCDD = '02') region_final = 2.
IF (CCDD = '03') region_final = 3.
IF (CCDD = '04') region_final = 4.
IF (CCDD = '05') region_final = 5.
IF (CCDD = '06') region_final = 6.
IF (CCDD = '07') region_final = 7.
IF (CCDD = '08') region_final = 8.
IF (CCDD = '09') region_final = 9.
IF (CCDD = '10') region_final = 10.
IF (CCDD = '11') region_final = 11.
IF (CCDD = '12') region_final = 12.
IF (CCDD = '13') region_final = 13.
IF (CCDD = '14') region_final = 14.
IF (CCDD = '16') region_final = 17.
IF (CCDD = '17') region_final = 18.
IF (CCDD = '18') region_final = 19.
IF (CCDD = '19') region_final = 20.
IF (CCDD = '20') region_final = 21.
IF (CCDD = '21') region_final = 22.
IF (CCDD = '22') region_final = 23.
IF (CCDD = '23') region_final = 24.
IF (CCDD = '24') region_final = 25.
IF (CCDD = '25') region_final = 26.
IF (CCDD = '15' AND CCPP = '01') region_final = 27.
IF (CCDD = '15' AND CCPP <> '01') region_final = 28.

VALUE LABELS region_final
  1 "Amazonas"
  2 "Áncash"
  3 "Apurímac"
  4 "Arequipa"
  5 "Ayacucho"
  6 "Cajamarca"
  7 "Prov. Const. del Callao"
  8 "Cusco"
  9 "Huancavelica"
  10 "Huánuco"
  11 "Ica"
  12 "Junín"
  13 "La Libertad"
  14 "Lambayeque"
  17 "Loreto"
  18 "Madre de Dios"
  19 "Moquegua"
  20 "Pasco"
  21 "Piura"
  22 "Puno"
  23 "San Martín"
  24 "Tacna"
  25 "Tumbes"
  26 "Ucayali"
  27 "Lima Metropolitana"
  28 "Región Lima".
EXECUTE.

* 3. Indicadores individuales. Fuera del universo se dejan como valores perdidos.
NUMERIC
  victimizacion
  percepcion_12m
  percepcion_noche
  percepcion_dia
  confianza_pnp
  robo_intento_dinero_cartera_celular
  estafa
  (F1.0).

IF (filtro_enapres = 1) victimizacion =
  ANY(1,
    P601_1, P601_2, P601_3A, P601_3B, P601_4A, P601_4B,
    P601_5A, P601_5B, P601_6A, P601_6B, P601_7, P601_8,
    P601_9, P601_10, P601_11, P601_12, P601_12A,
    P601_13, P601_14, P601_15, P601_16).

IF (filtro_enapres = 1) percepcion_12m =
  ANY(1,
    P611_1, P611_2, P611_3, P611_4, P611_5, P611_6, P611_7,
    P611_8, P611_9, P611_10, P611_11, P611_12, P611_13, P611_14).

IF (filtro_enapres = 1) percepcion_noche =
  ANY(P611B_1, 1, 2).

IF (filtro_enapres = 1) percepcion_dia =
  ANY(P611C, 1, 2).

IF (filtro_enapres = 1) confianza_pnp =
  ANY(P608_1, 3, 4).

IF (filtro_enapres = 1) robo_intento_dinero_cartera_celular =
  ANY(1, P601_6A, P601_6B).

IF (filtro_enapres = 1) estafa =
  (P601_13 = 1).

VARIABLE LABELS
  victimizacion "Victimización"
  percepcion_12m "Percepción de inseguridad en los próximos 12 meses"
  percepcion_noche "Percepción de inseguridad al caminar de noche en su zona o barrio"
  percepcion_dia "Percepción de inseguridad al caminar de día en su zona o barrio"
  confianza_pnp "Confianza en la Policía Nacional del Perú"
  robo_intento_dinero_cartera_celular "Robo o intento de robo de dinero, cartera o celular"
  estafa "Estafa".

VALUE LABELS
  victimizacion percepcion_12m percepcion_noche percepcion_dia confianza_pnp
  robo_intento_dinero_cartera_celular estafa
  0 "No"
  1 "Sí".
EXECUTE.

* 4. Para estimaciones en SPSS, activar el factor de expansión.
WEIGHT BY FACTOR.

* 5. Revisión rápida de resultados nacionales ponderados.
FREQUENCIES VARIABLES =
  victimizacion
  percepcion_12m
  percepcion_noche
  percepcion_dia
  confianza_pnp
  robo_intento_dinero_cartera_celular
  estafa
  /FORMAT = NOTABLE
  /ORDER = ANALYSIS.

* 6. Guardar una copia con los indicadores añadidos (ruta del profesor).
* SAVE OUTFILE='/Users/noam/Library/CloudStorage/Dropbox/5 Courses/01 HEASP/6 Criminalidad/Sesiones/Sesión 4/resultados/enapres_2023_indicadores_desde_spss.sav'
  /COMPRESSED.

EXECUTE.

* 7. Asociación entre dos variables usando Chi-cuadrado.

DATASET ACTIVATE ConjuntoDatos1.
CROSSTABS
  /TABLES=cap600 BY grupo_edad
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ CC PHI 
  /CELLS=COUNT
  /COUNT ROUND CELL.
