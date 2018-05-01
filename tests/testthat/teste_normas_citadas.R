context('normas_citadas()')

string_teste <- c("A PRESIDENTA DA REP\\u00daBLICA, no uso da atribui\\u00e7\\u00e3o que lhe confere o art. 84, caput, inciso IV, da Constitui\\u00e7\\u00e3o, e tendo em vista o disposto no art. 15 da Decreto-Lei n\\u00ba 8.666, de 21 de junho de 1993, e no art. 11 da Lei n\\u00ba 10.520, de 17 de julho de 2002, Lei n\\u00ba 10, de 17 de julho de 2002,",
                  "O SECRET\\u00c1RIO DE DEFESA AGROPECU\\u00c1RIA, no uso das atribui\\u00e7\\u00f5es que lhe conferem o artigo 10, do Anexo I, do Decreto N\\u00ba 7.127, de 04 de mar\\u00e7o de 2010, tendo em vista o disposto nos artigos 8\\u00ba, 37, 69 e 71, do Anexo I, da Instru\\u00e7\\u00e3o Normativa n\\u00ba 17, de 13 de julho de 2006, do Minist\\u00e9rio da Agricultura, Pecu\\u00e1ria e Abastecimento, e o que consta do processo n\\u00ba 21020.002349/2014-21, resolve:",
                  "A MINISTRA DE ESTADO DA AGRICULTURA, PECU\\u00c1RIA E ABASTECIMENTO, no uso das atribui\\u00e7\\u00f5es que lhe confere o art. 87, par\\u00e1grafo \\u00fanico, inciso II, da Constitui\\u00e7\\u00e3o, tendo em vista o disposto no Cap\\u00edtulo IV do Decreto n\\u00ba 24.114, de 12 de abril de 1934, e o que consta do Processo n\\u00ba 21000.014643/2006-12 resolve:",
                  "Art. 1\\u00ba Suspender, temporariamente, a importa\\u00e7\\u00e3o de frutos frescos de ma\\u00e7a (Malus domestica), p\\u00eara (Pyrus communis) e marmelo (Cydonia oblonga) produzidos na Argentina, at\\u00e9 que se proceda a revis\\u00e3o do Sistema Integrado de Medidas Fitossanit\\u00e1rias de Mitiga\\u00e7\\u00e3o de Riscos - SMR para a praga Cydia pomonella.",
                  "Art. 2\\u00ba A suspens\\u00e3o de que trata o art. 1\\u00ba n\\u00e3o se aplica \\u00e0s partidas com licen\\u00e7a de importa\\u00e7\\u00e3o (LI) registradas em data anterior \\u00e0 publica\\u00e7\\u00e3o da presente norma, as quais estar\\u00e3o sujeitas aos procedimentos usuais de inspe\\u00e7\\u00e3o no ponto de ingresso.",
                  "Art. 3\\u00ba Esta Instru\\u00e7\\u00e3o Normativa entra em vigor na data de sua publica\\u00e7\\u00e3o.")

desescapar <- stringi::stri_unescape_unicode

test_that('Regex funciona', {
  # autoinclusao como FALSE pq nao segue padrao e
  # primeira norma nao e nome
  esperado <- c("decreto-lei n\\u00ba 8.666, de 21 de junho de 1993",
                "lei n\\u00ba 10.520, de 17 de julho de 2002",
                "lei n\\u00ba 10, de 17 de julho de 2002",
                "decreto n\\u00ba 7.127, de 04 de mar\\u00e7o de 2010",
                "instru\\u00e7\\u00e3o normativa n\\u00ba 17, de 13 de julho de 2006",
                "decreto n\\u00ba 24.114, de 12 de abril de 1934")
  expect_equal(normas_citadas(desescapar(string_teste), FALSE),
               desescapar(esperado))
})

path_in01 <- system.file('extdata', 'in01.txt', package = 'redelex')
in01 <- readLines(path_in01, encoding = 'UTF-8', warn = FALSE)
nome_in01 <- "instru\\u00e7\\u00e3o normativa conjunta mp/cgu n\\u00ba 01, de 10 de maio de 2016"

test_that('Pega todas as normas citadas na IN 01 MP/CGU', {
  expect_equal(normas_citadas(in01),
               stringi::stri_unescape_unicode(
                 c("decreto n\\u00ba 8.578, de 26 de novembro de 2015",
                 "decreto n\\u00ba 8.109, de 17 de setembro de 2013"))
               )
  # Nome da norma não aparece como norma citada
  expect_false(stringi::stri_unescape_unicode(nome_in01) %in% normas_citadas(in01))
})

test_that("O tamanho de nenhuma norma citada excede 80", {
  expect_true( all(nchar(normas_citadas(in01)) <= 80) )
  expect_warning(
    (citadas_11326 <- "lei n\\u00ba 11.326, de 24 de julho de 2006" %>%
      texto_norma() %>% normas_citadas() ),
    "Nenhuma"
    )
  expect_true( all(nchar(citadas_11326) <= 80) )
})

