
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tcdkhelper

<!-- badges: start -->

![](https://img.shields.io/badge/status-aktiv-brightgreen)
<!-- badges: end -->

Tcdkhelper er en samling af hjælpefunktioner til R, som gør det nemmere
at lave data science i Testcenter Danmark

## Installation

Pakken kan installeres fra [GitHub](https://github.com/). Da
repository’et er privat, kræver dette en personlig adgangstoken (PAT),
som kan genereres således:
<https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token>

Det anbefales at have en udløbsdato på denne.

Derefter kan pakken installeres i R med disse kommandoer:

``` r
# install.packages("devtools")
devtools::install_github("Testcenter-Danmark/tcdkhelper", auth_token = "{-din-personlige-adgangstoken-}")
```

## Funktioner

# get_query()

Denne funktion er en wrapper til odbc, som åbner en forbindelse til
databasen, håndterer et query og lukker derefter forbindelsen igen.

## Eksempel

Dette er et simpelt eksempel på hvordan et dataudtræk foretages:

``` r
library(tcdkhelper)
  
data <- get_query("Select top (100) 
          MatrixPlateBC
          ,DWPlateBC
          ,RTimestampPM
          from Plateflow_Biomek
          Order by RTimestampPM desc")
#> Collected 100 rows in 0.66 seconds
```
