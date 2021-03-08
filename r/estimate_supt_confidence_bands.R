library(MASS)

estimate_supt_critical_value <- function(vcov_matrix, num_sim = 1000, conf_level = 0.95, seed = 192837) {

    if (exists(".Random.seed")) {  
        seed_before_call <- .Random.seed
        on.exit({.Random.seed <<- seed_before_call})
    }
    set.seed(seed)
    
    if (conf_level <= 0 | conf_level >= 1) {
       stop("Confidence level must live in (0, 1)")
    }
  
    std_errors <- t(sqrt(diag(vcov_matrix)))
    draws      <- mvrnorm(n = num_sim, mu = rep(0, nrow(vcov_matrix)), Sigma = vcov_matrix)
    t          <- draws / (std_errors %x% matrix(rep(1, num_sim)))
    t          <- apply(abs(t), 1, FUN = max)
    t          <- sort(t)
    
    conf_level_num_sim = conf_level * num_sim 
    
    if (round(conf_level_num_sim) == conf_level_num_sim) {
        critical_value = (t[conf_level_num_sim] + t[conf_level_num_sim + 1]) / 2
    } else {
        critical_value = t[floor(conf_level_num_sim) + 1]
    }
    
    return(critical_value)
}
