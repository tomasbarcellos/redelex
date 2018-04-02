#' Title
#'
#' @param texto
#'
#' @return
#' @export
#'
#' @examples
limpar_texto <- function(texto) {
  texto %>% eliminar_quebras() %>%
    stringr::str_replace_all("[Nn](o|o-|°-|°|º|º-)? ?(?=\\d)", "Nº ") %>%
    stringr::str_replace_all("(?<=\\d)(o-|o|°-|°) ?", "º ") %>%
    stringr::str_replace_all("(?<=\\d)(a-|a) ?", "ª ") %>%
    stringr::str_trim("both") %>%
    # extract(!stringr::str_detect(., "Este documento pode ser verificado no endereço")) %>%
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
    res <- stringr::str_split(texto, "\\n") %>% unlist() # devolver como vetor
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
normas_citadas <- function(texto) {
  lista_de_tipos <- c('lei', 'decreto', 'resolução',
                      'instrução normativa', 'portaria', 'ato',
                      'medida provisória', 'emenda constitucional')


  # Aplicar alguns regex no texto
  padroes <- paste0('(?<!-)',
    lista_de_tipos,
    '.{0,20} nº ?\\d{1,3}(\\.?\\d{3})?(\\/\\d{2,4})?(, ?de \\d{1,2}º? de .+? de \\d{4})?'
  )

  texto_limpo <- texto %>% limpar_texto() %>%
    stringr::str_c(collapse = '\n') %>%
    stringr::str_to_lower() %>%
    stringr::str_replace_all('\\(.+?\\)', '')

  resp <- purrr::map(
    padroes, ~stringr::str_extract_all(texto_limpo, .x)[[1]]
  ) %>% unlist()

  nome <- pegar_nome(texto_limpo)

  # E esperamos um vetor com as normas citadas
  resp[resp != nome]
}

#' Title
#'
#' @param texto
#'
#' @return
#' @export
#'
#' @examples
pegar_nome <- function(texto){
  texto %>% stringr::str_split('\\n') %>% unlist() %>%
    `[`(1) %>% #extrair_normas() %>% `[[`(1) %>%
    stringr::str_to_lower() %>%
    stringr::str_replace_all('<.+?>', '') %>%
    stringr::str_replace_all('\\t', '') %>%
    stringr::str_replace_all('dou \\d{1,2}/\\d{2}/\\d{4}', '') %>%
    stringr::str_trim('both')

}

#' Title
#'
#' @param nome_de_norma
#'
#' @return
#' @export
#'
#' @examples
criar_urn <- function(nome_de_norma) {
  local <- ifelse(Sys.info()['sysname'] == 'Windows',
                  'Portuguese_Brazil.1252', 'pt_BR.utf8')

  tipo <- stringr::str_extract(nome_de_norma, '.{1,40}(?= ?nº)') %>%
    stringr::str_trim()
  numero <- stringr::str_extract(nome_de_norma, '\\d{1,3}(\\.\\d{3})*') %>%
    stringr::str_remove_all('\\.')
  dia <- nome_de_norma %>%
    stringr::str_extract('\\d{1,2}º? de .{4,9} de \\d{4}') %>%
    stringr::str_replace('º', '') %>%
    lubridate::dmy(locale = local)

  if (is.na(dia)) {
    dia <- stringr::str_extract(nome_de_norma, '\\d{4}')
    if (is.na(dia)) {
      dia <- '*'
    }
  }

  sprintf('urn:br:%s;%s;%s', tipo, dia, numero)
}

