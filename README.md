
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Computing Simultaneous Confidence Bands in R

Simultaneous confidence bands are versatile tools for visualizing
estimation uncertainty for parameter vectors ([Montiel Olea and
Plagborg-Møller 2019](https://doi.org/10.1002/jae.2656)).

This repo houses a [R](https://www.r-project.org/) package that computes
the critical values underlying the simultaneous sup-t confidence bands
proposed in [Montiel Olea and Plagborg-Møller
(2019)](https://doi.org/10.1002/jae.2656).

## Installation

You can install the package from [GitHub](https://github.com/):

``` r
# install.packages("devtools")
devtools::install_github("ryanedmundkessler/suptCriticalValue")
```

The following example shows how to calculate sup-t critical values and,
in turn, construct sup-t confidence bands:

``` r
library(suptCriticalValue)
library(MASS)
data(Cars93, package = "MASS")
conf_level  <- 0.95
model       <- lm(Price ~ Weight + Wheelbase + Cylinders, data=Cars93)

beta        <- matrix(coef(model))
vcov_matrix <- vcov(model)
std_error   <- sqrt(diag(vcov_matrix))

pw_crit     <- qt(1 - ((1 - conf_level) / 2), model$df.residual) 
supt_crit   <- suptCriticalValue(vcov_matrix = vcov_matrix)

pw_ci_lb    <- beta - pw_crit * std_error 
pw_ci_ub    <- beta + pw_crit * std_error 
supt_ci_lb  <- beta - supt_crit * std_error 
supt_ci_ub  <- beta + supt_crit * std_error 

print("POINTWISE 95 PERCENT CONFIDENCE INTERVAL: ")
#> [1] "POINTWISE 95 PERCENT CONFIDENCE INTERVAL: "
print(paste0(
  "[", pw_ci_lb, ", ", pw_ci_ub, "]"
))
#> [1] "[-21.330171843335, 46.83621403265]"      
#> [2] "[0.00251094532423298, 0.016128208267558]"
#> [3] "[-0.690962683241204, 0.212504357845869]" 
#> [4] "[-8.40398530927412, 9.84209118926257]"   
#> [5] "[-11.7914298114545, 18.1682526011994]"   
#> [6] "[-7.00047790888086, 15.8049479269484]"   
#> [7] "[-1.15493094107966, 25.1081284937888]"   
#> [8] "[-1.38976348129131, 32.8553708816936]"

print("SIMULTANEOUS SUP-T 95 PERCENT CONFIDENCE INTERVAL: ")
#> [1] "SIMULTANEOUS SUP-T 95 PERCENT CONFIDENCE INTERVAL: "
print(paste0(
  "[", supt_ci_lb, ", ", supt_ci_ub, "]"
))
#> [1] "[-33.2487461671825, 58.7547883564975]"     
#> [2] "[0.000130030473141085, 0.0185091231186499]"
#> [3] "[-0.848929677383055, 0.37047135198772]"    
#> [4] "[-11.5942266000777, 13.0323324800662]"     
#> [5] "[-17.0297404093453, 23.4065631990902]"     
#> [6] "[-10.9879001451987, 19.7923701632663]"     
#> [7] "[-5.74690426962871, 29.7001018223379]"     
#> [8] "[-7.37736534532344, 38.8429727457257]"
```

## Unit Tests

[`monte_carlo.R`](./inst/test/code/monte_carlo.R) asserts that the
resulting sup-t confidence bands have expected coverage under select
data generating processes

## Author

Ryan Kessler <br>Email: <ryan.edmund.kessler@gmail.com>

## License

This project is licensed under the MIT License. See the
[LICENSE.md](LICENSE.md) file for details

## References

Montiel Olea, José Luis and Mikkel Plagborg-Møller. 2019. Simultaneous
Confidence Bands: Theory, Implementation, and an Application to SVARs.
Journal of Applied Econometrics. <https://doi.org/10.1002/jae.2656>
