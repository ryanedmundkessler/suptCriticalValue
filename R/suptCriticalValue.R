#' Create sup t critical value
#'
#' @param vcov_matrix Variance-covariance matrix
#' @param num_sim Number of bootstrap simulations. Default is 1000.
#' @param conf_level Confidence level. Default is 0.95.
#' @param seed Random seed if provided. Default is NULL.
#'
#' @return Numeric. Sup t critical value. Multiple by the standard error to get the confidence interval length.
#' 
#' @examples 
#' library(MASS)
#' data(Cars93, package = "MASS")
#' conf_level  <- 0.95
#' model       <- lm(Price ~ Weight + Wheelbase + Cylinders, data=Cars93)
#' 
#' beta        <- matrix(coef(model))
#' vcov_matrix <- vcov(model)
#' std_error   <- sqrt(diag(vcov_matrix))
#' 
#' pw_crit     <- qt(1 - ((1 - conf_level) / 2), model$df.residual) 
#' supt_crit   <- suptCriticalValue(vcov_matrix = vcov_matrix)
#' 
#' pw_ci_lb    <- beta - pw_crit * std_error 
#' pw_ci_ub    <- beta + pw_crit * std_error 
#' supt_ci_lb  <- beta - supt_crit * std_error 
#' supt_ci_ub  <- beta + supt_crit * std_error 
#' 
#' print("POINTWISE 95 PERCENT CONFIDENCE INTERVAL: ")
#' print(paste0(
#'   "[", pw_ci_lb, ", ", pw_ci_ub, "]"
#' ))
#' 
#' print("SIMULTANEOUS SUP-T 95 PERCENT CONFIDENCE INTERVAL: ")
#' print(paste0(
#'   "[", supt_ci_lb, ", ", supt_ci_ub, "]"
#' ))
#' 
#' @export
suptCriticalValue <- function(vcov_matrix, num_sim = 1000, conf_level = 0.95, seed = NULL) {
  if (!is.null(seed)) { 
    if (exists(".Random.seed")) {
      seed_before_call <- .Random.seed
      on.exit({
        .Random.seed <<- seed_before_call
      })
    }
    set.seed(seed)
  }
  
  if (conf_level <= 0 | conf_level >= 1) {
    stop("Confidence level must live in (0, 1)")
  }

  std_errors <- t(sqrt(diag(vcov_matrix)))
  draws <- MASS::mvrnorm(n = num_sim, mu = rep(0, nrow(vcov_matrix)), Sigma = vcov_matrix)

  t <- apply(draws, 1, FUN = function(x) max(abs(x / std_errors)))
  critical_value <- as.numeric(stats::quantile(t, probs = conf_level))

  return(critical_value)
}
