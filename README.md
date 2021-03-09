
# Computing Simultaneous Confidence Bands in R

Simultaneous confidence bands are versatile tools for visualizing estimation uncertainty for parameter vectors ([Montiel Olea and Plagborg-Møller 2019](https://onlinelibrary.wiley.com/doi/full/10.1002/jae.2656)). 

This repo houses a [R](https://www.r-project.org/) package that computes the critical values underlying the simultaneous sup-t confidence bands proposed in [Montiel Olea and Plagborg-Møller (2019)](https://onlinelibrary.wiley.com/doi/full/10.1002/jae.2656). 

## Installation

You can install the package from [GitHub](https://github.com/):

``` r
# install.packages("devtools")
devtools::install_github("ryanedmundkessler/suptCriticalValue")
```

## Example

The function can be called as follows:

``` r
library(suptCriticalValue)
library(MASS)

critical_value <- suptCriticalValue(vcov_matrix = matrix(1))
```

[example.R](./example/code/example.R) shows how the resulting sup-t critical values can be used to construct sup-t confidence bands 

## Unit Tests

[monte_carlo.R](./test/code/monte_carlo.R) asserts the resulting sup-t confidence bands have expected coverage under select data generating processes 

## Author

Ryan Kessler
<br>Email: ryan.edmund.kessler@gmail.com

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details

## References

Montiel Olea, José Luis and Mikkel Plagborg-Møller. 2019. Simultaneous Confidence Bands: Theory, Implementation, and an Application to SVARs. Journal of Applied Econometrics. 
