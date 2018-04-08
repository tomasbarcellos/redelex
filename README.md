# redelex

[![Travis-CI Build Status](https://travis-ci.org/tomasbarcellos/redelex.svg?branch=master)](https://travis-ci.org/tomasbarcellos/redelex)

[![Coverage Status](https://img.shields.io/codecov/c/github/tomasbarcellos/redelex/master.svg)](https://codecov.io/github/tomasbarcellos/redelex?branch=master)

O objetivo do pacote redeleg é oferecer uma série de funções que permitam identificar
o relacionamento entre textos legais.

## Instalação

``` r
# install.packages("devtools")
devtools::install_github("tomasbarcellos/redelex")
```

## Exemplo

``` r
library(redelex)

# urn da lei de acesso a informação
urn_12527 <- as_urn("urn:lex:br:federal:lei:2011-11-18;12527")
texto_12527 <- texto_norma(urn_12527)
citadas <- normas_citadas(texto_12527)
citadas

# ou então com o nome da norma
lei12527 <- "Lei nº 12.527, de 18 de Novembro de 2011"
texto_12527 <- texto_norma(lei12527)
citadas <- normas_citadas(texto_12527)
citadas
```

