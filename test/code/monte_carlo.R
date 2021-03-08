source('../../r/gaussian_empirical_bayes.R')
set.seed(19280)

main <- function() {

    num_sim  <- 10000
    num_obs  <- 5000
    mu       <- 2
    sigma_sq <- 8
    pct_tol  <- 0.001

    results <- monte_carlo(num_sim = num_sim, num_obs = num_obs, 
                           mu = mu, sigma_sq = sigma_sq)

    mu_hat_pct_diff       <- abs(mean(results$mu_hat) - mu) / mu
    sigma_sq_hat_pct_diff <- abs(mean(results$sigma_sq) - sigma_sq) / sigma_sq

    print(mean(results$mu_hat))
    print(mean(results$sigma_sq))

    stopifnot(mu_hat_pct_diff < pct_tol)
    stopifnot(sigma_sq_hat_pct_diff < pct_tol)
}

simulate_data <- function(num_obs, mu, sigma_sq) {
  
    beta     <- rnorm(num_obs, mu, sqrt(sigma_sq))
    tau_sq   <- runif(num_obs, min= (sigma_sq / 4), max= (4 * sigma_sq))
    beta_hat <- rnorm(num_obs, beta, sqrt(tau_sq))
  
    return_list <- list(beta_hat = beta_hat,
                        tau_sq   = tau_sq)
  
    return(return_list)
}

get_hyperparameters <- function(num_obs, mu, sigma_sq) {
  
    data  <- simulate_data(num_obs = num_obs, mu = mu, sigma_sq = sigma_sq)
    theta <- estimate_hyperparameters(beta = data$beta_hat, tau_sq = data$tau_sq)
  
    return_list <- list(mu_hat = theta$mu,
                        sigma_sq_hat = theta$sigma_sq)

    return(return_list)
}

monte_carlo <- function(num_sim, num_obs, mu, sigma_sq) {

    results     <-replicate(num_sim, get_hyperparameters(num_obs = num_obs,
                            mu = mu, sigma_sq = sigma_sq))

    return_list <- list(mu_hat = unlist(results[1, ]),
                        sigma_sq_hat = unlist(results[2, ]))

    return(return_list)
}

main()
