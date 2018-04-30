context('criar_urn()')

escapar <- stringi::stri_unescape_unicode

test_that('Cria URN adequadamente', {
  titulo1 <- escapar('LEI N\\u00ba 11.705, DE 19 DE JUNHO DE 2008')
  expect_identical(criar_urn(titulo1), as_urn('urn:lex:br:federal:lei:2008-06-19;11705'))
})

test_that('Lida com datas incompletas', {
  titulo2 <- escapar('LEI N\\u00ba 11.705/2008')
  expect_identical(criar_urn(titulo2), as_urn('urn:lex:br:federal:lei:2008;11705'))
})

test_that('Lida com datas ausentes', {
  titulo3 <- escapar('LEI N\\u00ba 11.705')
  expect_identical(criar_urn(titulo3), as_urn('urn:lex:br:federal:lei:*;11705'))
})

