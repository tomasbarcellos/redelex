context("texto_norma()")

test_that("texto_norma lida bem com métodos", {
  # character
  nome <- "LEI N\\u00ba 12.527, DE 18 DE NOVEMBRO DE 2011"
  expect_silent(resp1 <- texto_norma(nome))
  # urn
  urn <- "urn:lex:br:federal:lei:2011-11-18;12527"
  expect_identical(texto_norma(as_urn(urn)), resp1)
  # url
  link <- "http://legis.senado.leg.br/legislacao/PublicacaoSigen.action?id=584383&tipoDocumento=LEI-n&tipoTexto=PUB"
  expect_identical(texto_norma(link), resp1)
})

test_that("Lida com casos em que o link vai para site intermediario", {
  urn <- as_urn("urn:lex:br:federal:lei:1990-12-11;8112")
  expect_true("Do Provimento" %in% texto_norma(urn))
})

test_that("Fonte diferentes do padrão", {
  expect_failure(texto_norma(urn, "planalto"), "fonte")
  expect_failure(texto_norma(urn, "camara"), "fonte")
  expect_failure(texto_norma(urn, "Congresso"), "one of")
})

test_that("metodos para urn funcionam", {
  expect_output(print(urn), "<urn>")
  expect_equal(print(urn), urn)
  expect_output(summary(urn), "Tamanho URNs \\wnicas")
  expect_equal(unname(summary(urn)), c(1, 1))
})
