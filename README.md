
# Computing Simultaneous Confidence Bands in R

Simultaneous confidence bands are versatile tools for visualizing estimation uncertainty for parameter vectors ([Montiel Olea and Plagborg-Møller 2019](https://onlinelibrary.wiley.com/doi/full/10.1002/jae.2656)). 

This repo houses a [R](https://www.r-project.org/) function that computes the critical values underlying the simultaneous sup-t confidence bands proposed in [Montiel Olea and Plagborg-Møller (2019)](https://onlinelibrary.wiley.com/doi/full/10.1002/jae.2656). 

## Example

[example.do](./example/code/example.R) shows how the simultaneous sup-t confidence bands can be estimated alongside their pointwise counterparts 

## Unit Tests

[monte_carlo.R](./test/code/monte_carlo.R) asserts expected coverage rates for select data generating processes 

## Author

Ryan Kessler
<br>Email: ryan.edmund.kessler@gmail.com

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details

## References

Montiel Olea, José Luis and Mikkel Plagborg-Møller. 2019. Simultaneous Confidence Bands: Theory, Implementation, and an Application to SVARs. Journal of Applied Econometrics. 
