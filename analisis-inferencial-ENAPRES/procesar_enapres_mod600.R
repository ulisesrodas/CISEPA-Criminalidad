# ==============================================================================
# Script: procesar_enapres_mod600.R
# Input:  Archivos .sav de ENAPRES (2010-2025) almacenados localmente y descargados previamente.
# Acción: Armoniza cuestionarios históricos, filtra población y aplica pesos.
# Output: Genera 6 archivos locales (CSV/SAV) con microdatos y tabulados.
# ==============================================================================

# Ejecutar este script primero y luego el QMD de análisis inferencial.
# De lo contrario, el QMD dará error porque no encontrará los archivos de indicadores que genera este script.

library(tidyverse)
library(haven)
library(readr)

ruta_sesion <- normalizePath(file.path(".."), mustWork = FALSE)
if (!dir.exists(file.path(ruta_sesion, "datos"))) {
  ruta_sesion <- normalizePath(getwd(), mustWork = FALSE)
}

ruta_datos <- if (dir.exists(file.path(ruta_sesion, "datos"))) {
  file.path(ruta_sesion, "datos")
} else {
  ruta_sesion
}

ruta_resultados <- if (dir.exists(file.path(ruta_sesion, "resultados"))) {
  file.path(ruta_sesion, "resultados")
} else {
  ruta_sesion
}
dir.create(ruta_resultados, showWarnings = FALSE, recursive = TRUE)

ruta_microdatos <- file.path(ruta_datos, "microdatos_enapres")
if (!dir.exists(ruta_microdatos)) {
  ruta_microdatos <- ruta_datos
}

archivos_enapres <- list.files(
  ruta_microdatos,
  pattern = "\\.sav$",
  full.names = TRUE,
  recursive = TRUE
) |>
  keep(
    ~ str_detect(
      basename(.x),
      regex("ENAPRES|CAP_(600|400)", ignore_case = TRUE)
    )
  )

if (length(archivos_enapres) == 0) {
  stop("No encuentro archivos .sav de ENAPRES en: ", ruta_microdatos)
}

variables_base <- c(
  "ANIO",
  "AÑO",
  "MES",
  "AREA",
  "RESFIN",
  "P201",
  "P204",
  "P205",
  "P206",
  "P207",
  "P208_A",
  "CCDD",
  "CCPP",
  "NOMBREDD",
  "CONGLOMERADO",
  "VIVIENDA",
  "HOGAR",
  "ESTRATO",
  "FACTOR",
  "FACTOR_CALIBRADO",
  "FACTOR600",
  "FACTORANUALCAP600",
  "FACTORANUAL",
  "anio",
  "año",
  "mes",
  "area",
  "resfin",
  "p207",
  "p208_a",
  "ccdd",
  "ccpp",
  "nombredd",
  "conglomerado",
  "vivienda",
  "hogar",
  "estrato",
  "factor",
  "factor600",
  "factoranualcap600",
  "factoranual",
  "P600_C",
  "P600B_C",
  "P600C_C",
  "P400_C",
  "P400A_C",
  "FACTOR_CAP600B",
  "FACTOR_CAP400",
  paste0("P601_", 1:16),
  "P601_12A",
  "P601_3A",
  "P601_3B",
  "P601_4A",
  "P601_4B",
  "P601_5A",
  "P601_5B",
  "P601_6A",
  "P601_6B",
  paste0("P611_", 1:14),
  "P611A",
  "P611B",
  "P611B_1",
  "P611C",
  "P616A_1",
  "P604",
  "P605",
  "P608_1",
  paste0("P615_", 1:28),
  "P401",
  paste0("P402_", c(1:13, 15)),
  "P405",
  "P406_1",
  "P409_1",
  paste0("P424_", c(1:12, 14:23, 26:28))
)

agregar_columnas_faltantes <- function(data, vars) {
  faltantes <- setdiff(vars, names(data))

  if (length(faltantes) > 0) {
    data[faltantes] <- NA_real_
  }

  data
}

row_any_equal <- function(data, vars, value = 1) {
  vars <- intersect(vars, names(data))

  if (length(vars) == 0) {
    return(rep(NA, nrow(data)))
  }

  data |>
    select(all_of(vars)) |>
    mutate(across(everything(), as.numeric)) |>
    transmute(
      indicador = if_any(everything(), ~ replace_na(.x == value, FALSE))
    ) |>
    pull(indicador)
}

weighted_pct <- function(x, w) {
  casos_validos <- !is.na(x) & !is.na(w)

  if (!any(casos_validos)) {
    return(NA_real_)
  }

  weighted.mean(as.numeric(x[casos_validos]), w = w[casos_validos]) * 100
}

indicador_en <- function(x, valores) {
  if_else(is.na(x), NA_integer_, as.integer(as.numeric(x) %in% valores))
}

detectar_version <- function(data) {
  case_when(
    "P424_1" %in% names(data) ~ "cuestionario_2025_cap400",
    "P600B_C" %in%
      names(data) &
      "P615_1" %in% names(data) ~ "cuestionario_2024_cap600",
    TRUE ~ "cuestionario_2019_2023_cap600"
  )
}

procesar_archivo_enapres <- function(archivo) {
  message("Procesando ", basename(archivo))
  anio_archivo <- str_extract(basename(archivo), "\\d{4}") |>
    as.integer()

  base <- read_sav(archivo, col_select = any_of(variables_base)) |>
    rename_with(str_to_upper) |>
    mutate(across(where(is.labelled), zap_labels))

  version <- detectar_version(base)

  base <- base |>
    agregar_columnas_faltantes(str_to_upper(variables_base)) |>
    mutate(
      ANIO = coalesce(as.character(ANIO), as.character(`AÑO`)),
      ANIO = coalesce(ANIO, as.character(anio_archivo)),
      FACTOR = coalesce(
        as.numeric(FACTOR),
        as.numeric(FACTOR600),
        as.numeric(FACTORANUALCAP600),
        as.numeric(FACTORANUAL)
      )
    )

  vars_victimizacion <- switch(
    version,
    cuestionario_2024_cap600 = paste0("P615_", 1:21),
    cuestionario_2025_cap400 = paste0("P424_", c(1:12, 14:21)),
    c(
      "P601_1",
      "P601_2",
      "P601_3A",
      "P601_3B",
      "P601_4A",
      "P601_4B",
      "P601_5A",
      "P601_5B",
      "P601_6A",
      "P601_6B",
      "P601_7",
      "P601_8",
      "P601_9",
      "P601_10",
      "P601_11",
      "P601_12",
      "P601_12A",
      "P601_13",
      "P601_14",
      "P601_15",
      "P601_16",
      "P601_3A",
      "P601_3B",
      "P601_4A",
      "P601_4B",
      "P601_5A",
      "P601_5B",
      "P601_6A",
      "P601_6B"
    )
  )

  vars_percepcion_12m <- switch(
    version,
    cuestionario_2024_cap600 = paste0("P601_", 1:16),
    cuestionario_2025_cap400 = c("P401", paste0("P402_", c(1:13, 15))),
    paste0("P611_", 1:14)
  )

  valido_victimizacion_expr <- if (version == "cuestionario_2024_cap600") {
    as.numeric(base$P600C_C) != 99
  } else if (version == "cuestionario_2025_cap400") {
    as.numeric(base$P400A_C) != 99
  } else {
    as.numeric(base$P600_C) != 99
  }

  valido_percepcion_expr <- if (version == "cuestionario_2024_cap600") {
    as.numeric(base$P600B_C) != 99
  } else if (version == "cuestionario_2025_cap400") {
    as.numeric(base$P400_C) != 99
  } else {
    as.numeric(base$P600_C) != 99
  }

  base_preparada <- base |>
    mutate(
      anio = as.integer(ANIO),
      ccdd = str_pad(as.character(CCDD), width = 2, pad = "0"),
      ccpp = str_pad(as.character(CCPP), width = 2, pad = "0"),
      departamento = str_to_title(NOMBREDD),
      sexo = case_when(
        as.numeric(P207) == 1 ~ "Hombre",
        as.numeric(P207) == 2 ~ "Mujer",
        TRUE ~ NA_character_
      ),
      edad = as.numeric(P208_A),
      grupo_edad = case_when(
        edad >= 15 & edad <= 24 ~ "15 a 24",
        edad >= 25 & edad <= 39 ~ "25 a 39",
        edad >= 40 & edad <= 59 ~ "40 a 59",
        edad >= 60 & edad < 99 ~ "60 a más",
        TRUE ~ NA_character_
      ),
      region_final = case_when(
        ccdd == "15" & ccpp == "01" ~ "Lima Metropolitana",
        ccdd == "15" & ccpp != "01" ~ "Región Lima",
        TRUE ~ departamento
      ),
      filtro_general = as.numeric(AREA) == 1 &
        as.numeric(RESFIN) < 3 &
        as.numeric(P208_A) >= 15 &
        as.numeric(P208_A) < 99 &
        ((as.numeric(P204) == 1 & as.numeric(P205) == 2) |
          (as.numeric(P204) == 2 & as.numeric(P206) == 1)),
      valido_victimizacion = valido_victimizacion_expr,
      valido_percepcion = valido_percepcion_expr,
      peso_victimizacion = case_when(
        anio %in% c(2020, 2021) & !is.na(FACTOR_CALIBRADO) ~ FACTOR_CALIBRADO,
        TRUE ~ FACTOR
      ),
      peso_percepcion = case_when(
        version == "cuestionario_2024_cap600" &
          !is.na(FACTOR_CAP600B) ~ FACTOR_CAP600B,
        version == "cuestionario_2025_cap400" &
          !is.na(FACTOR_CAP400) ~ FACTOR_CAP400,
        anio %in% c(2020, 2021) & !is.na(FACTOR_CALIBRADO) ~ FACTOR_CALIBRADO,
        TRUE ~ FACTOR
      ),
      victimizacion = if_else(
        filtro_general & valido_victimizacion,
        as.integer(row_any_equal(pick(everything()), vars_victimizacion, 1)),
        NA_integer_
      ),
      percepcion_12m = if_else(
        filtro_general & valido_percepcion,
        as.integer(row_any_equal(pick(everything()), vars_percepcion_12m, 1)),
        NA_integer_
      ),
      percepcion_noche = case_when(
        !filtro_general | !valido_percepcion ~ NA_integer_,
        version == "cuestionario_2024_cap600" ~ indicador_en(P604, c(1, 2)),
        version == "cuestionario_2025_cap400" ~ indicador_en(P405, c(1, 2)),
        !is.na(P611A) ~ indicador_en(P611A, c(1, 2)),
        !is.na(P611B_1) ~ indicador_en(P611B_1, c(1, 2)),
        !is.na(P611B) ~ indicador_en(P611B, c(1, 2)),
        TRUE ~ NA_integer_
      ),
      percepcion_dia = case_when(
        !filtro_general | !valido_percepcion ~ NA_integer_,
        !is.na(P605) ~ indicador_en(P605, c(1, 2)),
        !is.na(P611C) ~ indicador_en(P611C, c(1, 2)),
        TRUE ~ NA_integer_
      ),
      confianza_pnp = case_when(
        !filtro_general | !valido_percepcion ~ NA_integer_,
        !is.na(P608_1) ~ indicador_en(P608_1, c(3, 4)),
        !is.na(P409_1) ~ indicador_en(P409_1, c(3, 4)),
        !is.na(P616A_1) ~ indicador_en(P616A_1, c(3, 4)),
        TRUE ~ NA_integer_
      ),
      robo_intento_dinero_cartera_celular = case_when(
        version == "cuestionario_2024_cap600" &
          filtro_general &
          valido_victimizacion ~
          as.integer(as.numeric(P615_9) == 1 | as.numeric(P615_10) == 1),
        version == "cuestionario_2025_cap400" &
          filtro_general &
          valido_victimizacion ~
          as.integer(as.numeric(P424_9) == 1 | as.numeric(P424_10) == 1),
        filtro_general & valido_victimizacion ~
          as.integer(row_any_equal(
            pick(everything()),
            c("P601_6", "P601_6A", "P601_6B"),
            1
          )),
        TRUE ~ NA_integer_
      ),
      estafa = case_when(
        version == "cuestionario_2024_cap600" &
          filtro_general &
          valido_victimizacion ~ as.integer(as.numeric(P615_21) == 1),
        version == "cuestionario_2025_cap400" &
          filtro_general &
          valido_victimizacion ~ as.integer(as.numeric(P424_21) == 1),
        filtro_general & valido_victimizacion ~ indicador_en(P601_13, 1),
        TRUE ~ NA_integer_
      )
    )

  base_preparada |>
    transmute(
      archivo = basename(archivo),
      version_cuestionario = version,
      anio,
      mes = as.character(MES),
      ccdd,
      ccpp,
      departamento,
      region_final,
      conglomerado = as.character(CONGLOMERADO),
      vivienda = as.character(VIVIENDA),
      hogar = as.character(HOGAR),
      estrato = as.character(ESTRATO),
      sexo,
      edad,
      grupo_edad,
      peso_victimizacion,
      peso_percepcion,
      victimizacion,
      percepcion_12m,
      percepcion_noche,
      percepcion_dia,
      confianza_pnp,
      robo_intento_dinero_cartera_celular,
      estafa
    )
}

base_enapres <- archivos_enapres |>
  set_names(basename) |>
  map_dfr(procesar_archivo_enapres)

indicadores_nacionales <- base_enapres |>
  group_by(anio) |>
  summarise(
    personas_victimizacion = sum(!is.na(victimizacion)),
    personas_percepcion = sum(!is.na(percepcion_12m)),
    victimizacion = weighted_pct(victimizacion, peso_victimizacion),
    percepcion_12m = weighted_pct(percepcion_12m, peso_percepcion),
    percepcion_noche = weighted_pct(percepcion_noche, peso_percepcion),
    percepcion_dia = weighted_pct(percepcion_dia, peso_percepcion),
    confianza_pnp = weighted_pct(confianza_pnp, peso_percepcion),
    robo_intento_dinero_cartera_celular = weighted_pct(
      robo_intento_dinero_cartera_celular,
      peso_victimizacion
    ),
    estafa = weighted_pct(estafa, peso_victimizacion),
    .groups = "drop"
  )

indicadores_region <- base_enapres |>
  group_by(anio, region_final) |>
  summarise(
    personas_victimizacion = sum(!is.na(victimizacion)),
    personas_percepcion = sum(!is.na(percepcion_12m)),
    victimizacion = weighted_pct(victimizacion, peso_victimizacion),
    percepcion_12m = weighted_pct(percepcion_12m, peso_percepcion),
    percepcion_noche = weighted_pct(percepcion_noche, peso_percepcion),
    percepcion_dia = weighted_pct(percepcion_dia, peso_percepcion),
    confianza_pnp = weighted_pct(confianza_pnp, peso_percepcion),
    robo_intento_dinero_cartera_celular = weighted_pct(
      robo_intento_dinero_cartera_celular,
      peso_victimizacion
    ),
    estafa = weighted_pct(estafa, peso_victimizacion),
    .groups = "drop"
  )

write_csv(
  base_enapres,
  file.path(ruta_resultados, "enapres_microdatos_indicadores.csv")
)
write_csv(
  indicadores_nacionales,
  file.path(ruta_resultados, "enapres_indicadores_nacionales.csv")
)
write_csv(
  indicadores_region,
  file.path(ruta_resultados, "enapres_indicadores_region.csv")
)

write_sav(
  base_enapres,
  file.path(ruta_resultados, "enapres_microdatos_indicadores.sav")
)
write_sav(
  indicadores_nacionales,
  file.path(ruta_resultados, "enapres_indicadores_nacionales.sav")
)
write_sav(
  indicadores_region,
  file.path(ruta_resultados, "enapres_indicadores_region.sav")
)

message("Listo. Archivos exportados en: ", ruta_resultados)
