source('../../r/gaussian_empirical_bayes.R')
set.seed(19281)

main <- function() {

    num_obs  <- 5000
    mu       <- 1
    sigma_sq <- 4

    data  <- simulate_data(num_obs = num_obs, mu = mu, sigma_sq = sigma_sq)
    theta <- estimate_hyperparameters(beta = data$beta_hat, tau_sq = data$tau_sq)

    posterior_params <- estimate_posterior_parameters(beta     = data$beta_hat, 
                                                      tau_sq   = data$tau_sq, 
                                                      mu       = theta$mu, 
                                                      sigma_sq = theta$sigma_sq)

    png("../output/gaussian_eb_shrinkage.png") 
    plot(data$tau_sq, posterior_params$mu, ylim = c(-6, 6), 
         xlab = expression(hat(tau[i])^2), ylab = expression(tilde(mu)[i]))
    dev.off()
}

simulate_data <- function(num_obs, mu, sigma_sq) {
  
    beta     <- rnorm(num_obs, mu, sqrt(sigma_sq))
    tau_sq   <- runif(num_obs, min= (sigma_sq / 100), max= (100 * sigma_sq))
    beta_hat <- rnorm(num_obs, beta, sqrt(tau_sq))
  
    return_list <- list(beta_hat = beta_hat,
                        tau_sq   = tau_sq)
  
    return(return_list)
}

main()
