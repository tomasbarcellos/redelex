context("caracteres ascci")

escapado <- "decreto n\\u00ba 9.013, de 29 de mar\\u00e7o de 2017"
path_in01 <- system.file("extdata", "in01.txt", package = "redelex")
sem_escape <- readLines(path_in01, encoding = 'UTF-8', warn = FALSE)

test_that("texto escapado fica igual", {
  expect_equal(escapar_unicode(escapado), escapado)
})

test_that("escapa texto sem escape", {
  expect_equal(escapar_unicode(sem_escape), stringi::stri_escape_unicode(sem_escape))
})
