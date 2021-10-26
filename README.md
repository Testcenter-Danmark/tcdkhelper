
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tcdkhelper

<!-- badges: start -->

![](https://img.shields.io/badge/status-aktiv-brightgreen)
<!-- badges: end -->

Tcdkhelper er en samling af hjælpefunktioner til R, som gør det nemmere
at lave data science i Testcenter Danmark

## Installation

Pakken kan installeres fra [GitHub](https://github.com/) således:

``` r
# install.packages("devtools")
devtools::install_github("Testcenter-Danmark/tcdkhelper")
```

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
#> Collected 100 rows in 0.64 seconds
```
