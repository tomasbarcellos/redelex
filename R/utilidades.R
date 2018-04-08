#' Limpar texto
#'
#' @param texto Um texto
#'
#' @return O mesmo texto limpo
#' @export
limpar_texto <- function(texto) {
  replace_all <- function(string, pattern, replacement) {
    stringr::str_replace_all(
      string,
      stringi::stri_unescape_unicode(pattern),
      stringi::stri_unescape_unicode(replacement)
    )
  }

  resp <- texto %>% eliminar_quebras() %>%
    replace_all("[Nn](o|o-|\\u00b0-|\\u00b0|\\u00ba|\\u00ba-)? ?(?=\\\\d)",
                    "N\\u00ba ") %>%
    replace_all("(?<=\\\\d)(o-|o|\\u00b0-|\\u00b0) ?", "\\u00ba ") %>%
    replace_all("(?<=\\\\d)(a-|a) ?", "\\u00aa ") %>%
    stringr::str_trim("both")
  resp[resp != ""]
}

#' Eliminar quebras de texto mal localizadas
#'
#' @param texto Um texto
#'
#' @return O mesmo sem quebras ruins
#' @export
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

#' @importFrom magrittr %>%
`%>%` <- magrittr::`%>%`

#' Converter em URN
#'
#' @param string Texto a ser convertido em URN
#'
#' @return O mesmo texto como URN
#' @export
#'
#' @examples
#' as_urn("urn:lex:br:federal:lei:2011-11-18;12527")
as_urn <- function(string) {
  class(string) <- c('urn', class(string))
  string
}

#' @export
print.urn <- function(x, ...) {
  tamanho <- length(x)
  cat('<urn> ')
  msg <- ifelse(tamanho == 1, "1 urn",
                paste0(tamanho, " urns:",
                      ifelse(tamanho > 10," mostrando as 10 primeiras", "")
                      )
                )
  cat(msg, '\n')
  print(head(as.character(x), 10))
}

#' @export
summary.urn <- function(x, ...) {
  tamanho <- length(x)
  unicas <- length(unique(x))
  msg <- c(tamanho, unicas)
  nomes <- c("Tamanho", "URNs \\u00fanicas")
  names(msg) <- stringi::stri_unescape_unicode(nomes)
  print(msg)
}

