library(MASS)
library(suptCriticalValue)
set.seed(19240)

main <- function() {
    num_reps      <- 2500
    num_obs       <- 100000
    conf_level    <- 0.95
    cov_tolerance <- 0.02
    
    results       <- replicate(num_reps, coverage_simulation(num_obs = num_obs, multiple_regressors = FALSE,
                                                             conf_level = conf_level))
    pw_coverage   <- mean(unlist(results[1,]))
    supt_coverage <- mean(unlist(results[2,]))
    
    print("POINTWISE COVERAGE WITH SINGLE REGRESSOR:")
    print(pw_coverage)
    
    print("SIMULTANEOUS SUP-T COVERAG WITH SINGLE REGRESSOR:")
    print(supt_coverage)
    
    stopifnot(abs(pw_coverage - conf_level) <= cov_tolerance)
    stopifnot(abs(supt_coverage - conf_level) <= cov_tolerance)
    
    results       <- replicate(num_reps, coverage_simulation(num_obs = num_obs, multiple_regressors = TRUE,
                                                             conf_level = conf_level))
    pw_coverage   <- mean(unlist(results[1,]))
    supt_coverage <- mean(unlist(results[2,]))
    
    print("POINTWISE COVERAGE WITH MULTIPLE REGRESSORS:")
    print(pw_coverage)
    
    print("SIMULTANEOUS SUP-T COVERAG WITH MULTIPLE REGRESSORS:")
    print(supt_coverage)
    
    stopifnot(abs(pw_coverage - conf_level) > 3 * cov_tolerance)
    stopifnot(abs(supt_coverage - conf_level) <= cov_tolerance)
}

coverage_simulation <- function(num_obs, num_reps, multiple_regressors, conf_level = 0.95) {
    data     <- simulate_data(num_obs = num_obs, multiple_regressors = multiple_regressors)
    coverage <- determine_coverage(data, conf_level = conf_level, multiple_regressors = multiple_regressors)
    return(coverage)
}

simulate_data <- function(num_obs, multiple_regressors = TRUE) {
  
    num_obs <- num_obs
    if (multiple_regressors == TRUE) {
        vcov_matrix <- matrix(c(1, 0.2, 0.2, 
                                0.2, 1, 0.2, 
                                0.2, 0.2, 1), nrow = 3, ncol = 3, byrow = TRUE)     
    } else {
        vcov_matrix <- matrix(1)
    }

    true_beta <- rep(1, nrow(vcov_matrix))
    X         <- mvrnorm(n = num_obs, mu = rep(0, nrow(vcov_matrix)), Sigma = vcov_matrix)
    y         <- X %*% true_beta + rnorm(num_obs, 0, 10)
    data      <- as.data.frame(cbind(y, X))
    
    if (multiple_regressors == TRUE) {
        colnames(data) <- c("y", "x1", "x2", "x3")
    } else {
        colnames(data) <- c("y", "x1")
    }
    
    return(data)
}

determine_coverage <- function(data, multiple_regressors, conf_level = 0.95) {
  
    if (multiple_regressors == TRUE) {
        model <- lm(y ~ x1 + x2 + x3 - 1, data = data)
    } else {
        model <- lm(y ~ x1 - 1, data = data)
    }
    beta        <- matrix(coef(model))
    vcov_matrix <- vcov(model)
    std_error   <- sqrt(diag(vcov_matrix))
    true_beta   <- rep(1, nrow(vcov_matrix))
    
    pw_crit     <- qt(1 - ((1 - conf_level) / 2), model$df.residual) 
    supt_crit   <- suptCriticalValue(vcov_matrix = vcov_matrix)
    
    pw_cover    <- is_beta_covered(beta = beta, vcov_matrix = vcov_matrix, 
                                   true_beta = true_beta, critical_value = pw_crit)
    
    supt_cover  <- is_beta_covered(beta = beta, vcov_matrix = vcov_matrix, 
                                   true_beta = true_beta, critical_value = supt_crit)
    
    return_list <- list(pw_cover   = pw_cover,
                        supt_cover = supt_cover)
    
    return(return_list)
}

is_beta_covered <- function(beta, vcov_matrix, true_beta, critical_value) {
  
    std_error   <- sqrt(diag(vcov_matrix))
  
    conf_lb     <- beta - critical_value * std_error 
    conf_ub     <- beta + critical_value * std_error
  
    covered     <- (true_beta >= conf_lb) & (true_beta <= conf_ub)
    all_covered <- min(covered)
  
    return(all_covered)
}

main()
