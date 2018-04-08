# context('criar_urn()')
#
# titulo1 <- tolower('LEI Nº 11.705, DE 19 DE JUNHO DE 2008')
# titulo2 <- tolower('LEI Nº 11.705/2008')
# titulo3 <- tolower('LEI Nº 11.705')
#
# test_that('Cria URN adequadamente', {
#   expect_identical(criar_urn(titulo1), as_urn('urn:lex:br:federal:lei:2008-06-19;11705'))
# })
#
# test_that('Lida com datas incompletas', {
#   expect_identical(criar_urn(titulo2), as_urn('urn:lex:br:federal:lei:2008;11705'))
# })
#
# test_that('Lida com datas ausentes', {
#   expect_identical(criar_urn(titulo3), as_urn('urn:lex:br:federal:lei:*;11705'))
# })
#
