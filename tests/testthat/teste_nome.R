context("nome_norma()")

path_in01 <- system.file('extdata', 'in01.txt', package = 'redelex')
# path_in01 <- '../../inst/extdata/in01.txt'
in01 <- readLines(path_in01, encoding = 'UTF-8', warn = FALSE)
nome_in01 <-  "instru\\u00e7\\u00e3o normativa conjunta mp/cgu n\\u00ba 01, de 10 de maio de 2016"

expect_nome <- function(nome) {
  expect_equal(texto_norma(nome) %>% nome_norma(),
               stringr::str_to_lower(nome))
}

test_that("Retorna nome esperado da norma", {
  expect_equal(nome_norma(in01), stringi::stri_unescape_unicode(nome_in01))
  expect_nome("Lei nº 12.527, de 18 de novembro de 2011")
  expect_nome("Lei nº 11.111, de 5 de maio de 2005")
})

