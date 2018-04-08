#' Extrair normas citadas
#'
#' @param texto Texto de um norma
#' @param contemnome O nome da norma est\\u00e1 contido no texto?
#'
#' @return Um vetor com o nome das normas citadas
#' @export
#'
#' @examples
#' texto <- texto_norma("Lei n\\u00ba 12.527, de 18 de novembro de 2011")
#' normas_citadas(texto)
normas_citadas <- function(texto, contemnome = TRUE) {
  lista_de_tipos <- c("lei", "decreto", "resolu\\u00e7\\u00e3o",
                      "instru\\u00e7\\u00e3o normativa", 'portaria', 'ato',
                      "medida provis\\u00f3ria", "emenda constitucional")

  # Aplicar alguns regex no texto
  padroes <- paste0('(?<!-)', lista_de_tipos,
                    '.{0,20} n\\u00ba ?\\\\d{1,3}(\\\\.?\\\\d{3})?',
                    '(\\\\/\\\\d{2,4})?',
                    '(, ?de \\\\d{1,2}\\u00ba? de .+? de \\\\d{4})?') %>%
    stringi::stri_unescape_unicode()

  texto_limpo <- texto %>% limpar_texto() %>%
    stringr::str_c(collapse = '\n') %>%
    stringr::str_to_lower() %>%
    stringr::str_replace_all('\\(.+?\\)', '')

  mat_ordem <- stringr::str_locate_all(texto_limpo, padroes) %>%
    do.call(what = 'rbind')
  mat_ordem <- mat_ordem[order(mat_ordem[, 1]), ]

  resp <- stringr::str_sub(texto_limpo, mat_ordem)

  if (contemnome) {
    resp <- resp[-1]
  }

  resp
}

#' Nome da norma
#'
#' @param texto Texto de um norma
#'
#' @return O nome da norma
#' @export
#'
#' @examples
#' texto <- texto_norma(as_urn("urn:lex:br:federal:lei:2011-11-18;12527"))
#' nome_norma(texto)
nome_norma <- function(texto){
  citadas <- normas_citadas(texto, contemnome = FALSE)
  citadas[[1]]
}

#' Criar URN
#'
#' @param nome_de_norma Nome de uma norma
#' @param nivel nivel da legisla\\u00e7\\u00e3o
#'
#' @return URN da norma, no padr\\u00e3o adotado pelo LEXML
#' (\url{http://lexml.gov.br/})
#' @export
#'
#' @examples
#' criar_urn("Lei n\\u00ba 12.527, de 18 de novembro de 2011")
criar_urn <- function(nome_de_norma, nivel = 'federal') {
  local <- ifelse(Sys.info()['sysname'] == 'Windows',
                  'Portuguese_Brazil.1252', 'pt_BR.utf8')

  nome_de_norma <- stringi::stri_unescape_unicode(nome_de_norma) %>%
    stringr::str_to_lower()

  tipo <- stringr::str_extract(nome_de_norma, '.{1,40}(?= ?n\\u00ba)') %>%
    stringr::str_trim()
  numero <- stringr::str_extract(nome_de_norma, '\\d{1,3}(\\.\\d{3})*') %>%
    stringr::str_remove_all('\\.')
  dia <- nome_de_norma %>%
    stringr::str_extract('\\d{1,2}\\u00ba? de .{4,9} de \\d{4}') %>%
    stringr::str_replace('\\u00ba', '') %>%
    lubridate::dmy(locale = local)

  if (is.na(dia)) {
    dia <- stringr::str_extract(nome_de_norma, '\\d{4}')
    if (is.na(dia)) {
      dia <- '*'
    }
  }

  res <- sprintf('urn:lex:br:%s:%s:%s;%s', nivel, tipo, dia, numero)
  structure(
    res,
    class = c("urn", "character")
  )
}

#' Buscar texto de norma
#'
#' @param nome Nome da norma a ser buscada. Pode ser texto, link ou urn.
#' @param fonte Nome da fonte. Pode ser um entre "senado", "planalto", "camara"
#'
#' @return O texto da norma
#' @export
texto_norma <- function(nome, fonte) {
  UseMethod('texto_norma', nome)
}

#' @rdname texto_norma
#' @export
texto_norma.character <- function(nome, fonte = c("senado", "planalto", "camara")) {
  if (stringr::str_detect(nome, "^(ht|f)tps?://")) {
    texto_norma.url(nome, fonte)
  } else {
    urn <- criar_urn(nome)
    texto_norma.urn(urn, fonte)
  }
}

#' @rdname texto_norma
#' @export
texto_norma.urn <- function(nome, fonte = c("senado", "planalto", "camara")) {
  url_lexml <- paste0("http://lexml.gov.br/urn/", nome)

  urls <- xml2::read_html(url_lexml) %>%
    rvest::html_node(".results:nth-child(4)") %>%
    rvest::html_nodes(".noprint") %>%
    rvest::html_attr("href")

  urls <- urls[!is.na(urls)]
  urls <- urls[!stringr::str_detect(urls, "linker")]

  fonte <- match.arg(fonte, c("senado", "planalto", "camara"))
  url_texto <- urls[stringr::str_detect(urls, fonte)]

  texto_norma.url(url_texto, fonte)
}

#' @rdname texto_norma
#' @export
texto_norma.url <- function(nome, fonte = c("senado", "planalto", "camara")) {
  fonte <- match.arg(fonte, c("senado", "planalto", "camara"))
  if (fonte == "senado") {
    texto <- xml2::read_html(nome) %>%
      rvest::html_nodes("#conteudoPrincipal > div") %>%
      rvest::html_nodes("div") %>%
      rvest::html_nodes("p") %>%
      rvest::html_text()
  } else {
    stop("M\\u00e9todo n\\u00e3o criado para esta fonte", call. = FALSE)
  }
  texto[texto != ""]
}

