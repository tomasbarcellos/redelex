#' Title
#'
#' @param texto
#'
#' @return
#' @export
#'
#' @examples
limpar_texto <- function(texto) {
  texto %>% stringr::str_replace_all("[Nn](o|o-|°-|°|º|º-)? ?(?=\\d)", "Nº ") %>%
    stringr::str_replace_all("(?<=\\d)(o-|o|°-|°) ?", "º ") %>%
    stringr::str_replace_all("(?<=\\d)(a-|a) ?", "ª ") %>%
    stringr::str_trim("both") %>%
    # extract(!stringr::str_detect(., "Este documento pode ser verificado no endereço")) %>%
    eliminar_quebras() %>%
    stringr::str_trim("both") %>%
    magrittr::extract(. != "")
}

#' Title
#'
#' @param texto
#'
#' @return
#' @export
#'
#' @examples
eliminar_quebras <- function(texto) {
  entrou_colapsado <- length(texto) == 1
  texto <- paste0(texto, collapse = "\n") %>%
    stringr::str_replace_all('-\\n', '') %>%
    stringr::str_replace_all('(?<=,)\\n', ' ') %>%
    stringr::str_replace_all('(?<=\\s(DO|NO))\\n', ' ') %>%
    stringr::str_replace_all('\\n ?(?=[a-z][^\\)-])', ' ') %>%
    stringr::str_replace_all('(?<![;:\\.]) ?\\n ?(?=\\d{2,})', ' ') %>%
    stringr::str_replace_all('(?<=\\d[\\.,\\/]) ?\\n ?(?=\\d)', '') %>%
    stringr::str_replace_all(' {2,}', ' ')

  if (entrou_colapsado) {
    res <- texto # devolver com tamanho 1
  } else {
    res <- strsplit(texto, "\\n")[[1]] # devolver como vetor
  }
  res
}


#' Title
#'
#' @param texto
#'
#' @return
#' @export
#'
#' @examples
extrair_normas <- function(texto) {
  lista_de_tipos <- c('lei', 'decreto', 'resolução',
                      'instrução normativa', 'portaria', 'ato',
                      'medida provisória', 'emenda constitucional')


  # Aplicar alguns regex no texto
  padroes <- paste0('(?<!-)',
    lista_de_tipos,
    '.{0,20} nº ?\\d{1,3}(\\.?\\d{3})?(\\/\\d{2,4})?(, ?de \\d{1,2}º? de .+? de \\d{4})?'
  )

  # Garantir que não pegue 2 vezes decreto-lei
  # como decreto-lei e como lei

  texto_limpo <- texto %>% limpar_texto() %>%
    stringr::str_to_lower()

  resp <- purrr::map(
    padroes, ~stringr::str_extract_all(texto_limpo, .x)[[1]]
    ) %>% unlist()

  resp

  # E esperamos um vetor com as normas citadas
}
