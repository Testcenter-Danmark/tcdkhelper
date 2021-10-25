
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tcdkhelper

<!-- badges: start -->
<!-- badges: end -->

The goal of tcdkhelper is to facilitate data science tasks at Testcenter
Danmark

## Installation

You can install the development version of tcdkhelper from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Testcenter-Danmark/tcdkhelper")
```

## Example

This is a basic example which shows how to fetch data from the database:

``` r
library(tcdkhelper)

data <- get_query("Select top (100) 
          MatrixPlateBC
          ,DWPlateBC
          ,RTimestampPM
          from Plateflow_Biomek
          Order by RTimestampPM desc")
#> Collected 100 rows in 0.59 seconds
```
