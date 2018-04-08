# context('normas_citadas()')
#
# string_teste <- 'A PRESIDENTA DA REPÚBLICA, no uso da atribuição que lhe confere o art. 84, caput, inciso IV, da Constituição, e tendo em vista o disposto no art. 15 da Decreto-Lei nº 8.666, de 21 de junho de 1993, e no art. 11 da Lei nº 10.520, de 17 de julho de 2002, Lei nº 10, de 17 de julho de 2002,
# O SECRETÁRIO DE DEFESA AGROPECUÁRIA, no uso das atribuições que lhe conferem o artigo 10, do Anexo I, do Decreto Nº 7.127, de 04 de março de 2010, tendo em vista o disposto nos artigos 8º, 37, 69 e 71, do Anexo I, da Instrução Normativa nº 17, de 13 de julho de 2006, do Ministério da Agricultura, Pecuária e Abastecimento, e o que consta do processo nº 21020.002349/2014-21, resolve:
# A MINISTRA DE ESTADO DA AGRICULTURA, PECUÁ- RIA E ABASTECIMENTO, no uso das atribuições que lhe confere o art. 87, parágrafo único, inciso II, da Constituição, tendo em vista o disposto no Capítulo IV do Decreto nº 24.114, de 12 de abril de 1934, e o que consta do Processo nº 21000.014643/2006-12 resolve:
#
# Art. 1º Suspender, temporariamente, a importação de frutos frescos de maça (Malus domestica), pêra (Pyrus communis) e marmelo (Cydonia oblonga) produzidos na Argentina, até que se proceda a revisão do Sistema Integrado de Medidas Fitossanitárias de Mitigação de Riscos - SMR para a praga Cydia pomonella.
#
# Art. 2º A suspensão de que trata o art. 1º não se aplica às partidas com licença de importação (LI) registradas em data anterior à publicação da presente norma, as quais estarão sujeitas aos procedimentos usuais de inspeção no ponto de ingresso.
#
# Art. 3º Esta Instrução Normativa entra em vigor na data de sua publicação.'
#
# test_that('Regex funciona', {
#   # autoinclusao como TRUE pq nao segue padrao e
#   # primeira norma nao e nome
#   expect_equal(normas_citadas(string_teste, FALSE),
#                c('decreto-lei nº 8.666, de 21 de junho de 1993',
#                  'lei nº 10.520, de 17 de julho de 2002',
#                  'lei nº 10, de 17 de julho de 2002',
#                  'decreto nº 7.127, de 04 de março de 2010',
#                  'instrução normativa nº 17, de 13 de julho de 2006',
#                  'decreto nº 24.114, de 12 de abril de 1934'))
# })
#
# path_in01 <- system.file('extdata', 'in01.txt', package = 'redeleg')
# in01 <- readLines(path_in01, encoding = 'UTF-8', warn = FALSE)
# nome_in01 <- "instru\\u00e7\\u00e3o normativa conjunta mp/cgu n\\u00ba 01, de 10 de maio de 2016"
#
# test_that('Pega todas as normas citadas na IN 01 MP/CGU', {
#   expect_equal(normas_citadas(in01),
#                stringi::stri_unescape_unicode(
#                  c("decreto n\\u00ba 8.578, de 26 de novembro de 2015",
#                  "decreto n\\u00ba 8.109, de 17 de setembro de 2013"))
#                )
#   # Nome da norma não aparece como norma citada
#   expect_false(stringi::stri_unescape_unicode(nome_in01) %in% normas_citadas(in01))
# })
#
