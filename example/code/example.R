source('../../r/estimate_supt_confidence_bands.R')
set.seed(19281)

main <- function() {
    conf_level  <- 0.95

    model       <- lm(Price ~ Weight + Wheelbase + Cylinders, data=Cars93)

    beta        <- matrix(coef(model))
    vcov_matrix <- vcov(model)
    std_error   <- sqrt(diag(vcov_matrix))

    pw_crit     <- qt(1 - ((1 - conf_level) / 2), model$df.residual) 
    supt_crit   <- estimate_supt_critical_value(vcov_matrix = vcov_matrix)

    pw_ci_lb    <- beta - pw_crit * std_error 
    pw_ci_ub    <- beta + pw_crit * std_error 
    supt_ci_lb  <- beta - supt_crit * std_error 
    supt_ci_ub  <- beta + supt_crit * std_error 

    print("POINTWISE 95 PERCENT CONFIDENCE INTERVAL:")
    print(pw_ci_lb)
    print(pw_ci_ub)

    print("SIMULTANEOUS SUP-T 95 PERCENT CONFIDENCE INTERVAL:")
    print(supt_ci_lb)
    print(supt_ci_ub)
}

main()
