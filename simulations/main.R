args <- commandArgs(trailingOnly=TRUE)
pi_arg <- args[1]
mu1 <- as.numeric(args[2])
sigma1 <- as.numeric(args[3])
K <- as.numeric(args[4])
n_low <- as.numeric(args[5])
n_high <- as.numeric(args[6])
library(ebdm)
RNGkind(kind = "L'Ecuyer-CMRG", normal.kind = "Inversion", sample.kind = "Rejection")
set.seed(666)
print(runif(1, min = 0, max = 1))

if (!is.na(suppressWarnings(as.numeric(pi_arg)))) {
  pi_mode  <- "fixed"
  pi_spec <- as.numeric(pi_arg)
} else if (tolower(pi_arg) == "random") {
  pi_mode  <- "random"
  pi_spec <- c(0.1, 0.5)
} else {
  stop("pi must be 0.1, 0.5, or 'random'")
}

print(pi_spec)
print(mu1)
print(sigma1)
print(K)
print(n_low)
print(n_high)

library(stats)
################################################################################
#data simulation
################################################################################
simulate_datasets <- function(K, n_range, mu1, sigma1, mu0, sigma0, pi_range) {
  
  results <- data.frame(
    mu1_true = numeric(K),
    sigma1_true = numeric(K),
    mu0_true = numeric(K),
    sigma0_true = numeric(K),
    pi_true = numeric(K),
    pi_est_individual = numeric(K),
    pi_est_total = numeric(K),
    ni = integer(K),
    mi = integer(K),
    xbar = numeric(K),
    s2 = numeric(K)
  )
  
  for (i in 1:K) {
    n_i <- sample(n_range[1]:n_range[2], 1)
    if (length(pi_range) == 1) {
      pi_i <- pi_range
    } else {
      mid <- mean(pi_range)
      sd  <- (pi_range[2] - pi_range[1]) / (2 * 2.576)
      repeat {
        pi_i <- rnorm(1, mean = mid, sd = sd)
        if (pi_i >= pi_range[1] && pi_i <= pi_range[2]) break
      }
    }
    
    Y <- rbinom(n_i, size = 1, prob = pi_i)
    X <- ifelse(Y == 1, rnorm(n_i, mean = mu1, sd = sigma1),
                rnorm(n_i, mean = mu0, sd = sigma0))
    
    results$ni[i] <- n_i
    results$mi[i] <- mean(Y) * n_i
    results$xbar[i] <- mean(X)
    results$s2[i] <- var(X)
    results$mu1_true[i] <- mu1
    results$sigma1_true[i] <- sigma1
    results$mu0_true[i] <- mu0
    results$sigma0_true[i] <- sigma0
    results$pi_true[i] <- pi_i
    results$pi_est_individual[i] <- mean(Y)
    
  }
  results$pi_est_total = sum(results$ni * results$pi_est_individual)/sum(results$ni)
  return(results)
}

################################################################################
#Simulation
################################################################################
mu0 <- 0
sigma0 <- 1
repeats <- 10000
n_range <- c(n_low, n_high)
param_grid <- data.frame(rep = 1:repeats)

results <- list()
start_time <- proc.time()

for (i in seq_len(repeats)) {
  
  print(i)
  
  sim_data <- simulate_datasets(
    K = K,
    n_range = n_range,
    mu1 = mu1,
    sigma1 = sigma1,
    mu0 = mu0,
    sigma0 = sigma0,
    pi_range = pi_spec
  )
  
  
  naive_results = est_mixture(sim_data$ni, sim_data$xbar, sim_data$mi, method='naive')
  gmm_results = est_mixture(sim_data$ni, sim_data$xbar, sim_data$mi, sim_data$s2, method='gmm')

  
  # Naive results
  mu1_hat <- naive_results$mu1_hat
  mu0_hat <- naive_results$mu0_hat
  sigma1_hat <- naive_results$sigma1_hat
  sigma0_hat <- naive_results$sigma0_hat
  # GMM results
  mu1_hat_scale <- gmm_results$mu1_hat
  mu0_hat_scale <- gmm_results$mu0_hat
  sigma1_hat_scale <- gmm_results$sigma1_hat
  sigma0_hat_scale <- gmm_results$sigma0_hat
  # SE results
  mu1_se_scale <- gmm_results$se[1]
  mu0_se_scale <- gmm_results$se[2]
  sigma1_se_scale <- gmm_results$se[3]
  sigma0_se_scale <- gmm_results$se[4]
  # CI results
  mu1_ci_low <- gmm_results$ci$mu1[1]
  mu1_ci_upp <- gmm_results$ci$mu1[2]
  mu0_ci_low <- gmm_results$ci$mu0[1]
  mu0_ci_upp <- gmm_results$ci$mu0[2]
  sigma1_ci_low <- gmm_results$ci$sigma1[1]
  sigma1_ci_upp <- gmm_results$ci$sigma1[2]
  sigma0_ci_low <- gmm_results$ci$sigma0[1]
  sigma0_ci_upp <- gmm_results$ci$sigma0[2]
  # CI Cover
  mu1_cover <- as.integer(!(mu1 >= mu1_ci_low & mu1 <= mu1_ci_upp))
  mu0_cover <- as.integer(!(mu0 >= mu0_ci_low & mu0 <= mu0_ci_upp))
  sigma1_cover <- as.integer(!(sigma1 >= sigma1_ci_low & sigma1 <= sigma1_ci_upp))
  sigma0_cover <- as.integer(!(sigma0 >= sigma0_ci_low & sigma0 <= sigma0_ci_upp))
  
  results[[i]] <- data.frame(
    pi_mode = pi_mode,
    pi = if (pi_mode =="fixed") as.character(pi_spec) else "random",
    samples_k = K,
    samples_n_i = n_high,
    mu1_true = mu1,
    mu0_true = mu0,
    sigma1_true = sigma1,
    sigma0_true = sigma0,
    rep = i,
    
    
    # Naive
    pi_hat = sim_data$pi_est_total[1],
    mu1_hat_bl = mu1_hat,
    mu0_hat_bl = mu0_hat,
    sigma1_hat_bl = sigma1_hat,
    sigma0_hat_bl = sigma0_hat,
    # GMM
    mu1_hat_scale = mu1_hat_scale,
    mu0_hat_scale = mu0_hat_scale,
    sigma1_hat_scale = sigma1_hat_scale,
    sigma0_hat_scale = sigma0_hat_scale,
    #SE and CI
    mu1_se_scale = mu1_se_scale,
    mu0_se_scale = mu0_se_scale,
    sigma1_se_scale = sigma1_se_scale,
    sigma0_se_scale = sigma0_se_scale,
    mu1_ci_low = mu1_ci_low,
    mu1_ci_upp = mu1_ci_upp,
    mu0_ci_low = mu0_ci_low,
    mu0_ci_upp = mu0_ci_upp,
    sigma1_ci_low = sigma1_ci_low,
    sigma1_ci_upp = sigma1_ci_upp,
    sigma0_ci_low = sigma0_ci_low,
    sigma0_ci_upp = sigma0_ci_upp,
    mu1_cover = mu1_cover,
    mu0_cover = mu0_cover,
    sigma1_cover = sigma1_cover,
    sigma0_cover = sigma0_cover
  )
}

end_time <- proc.time()
time_log <- (end_time - start_time)[["elapsed"]]
print(paste0("Iterations took ", round(time_log, 2), " seconds"))

all_results <- do.call(rbind, results)
colnames(all_results) <- gsub("\\.\\.\\..*", "", colnames(all_results))
out_name <- sprintf("./1c1b/result_pi%s_mu%d_sigma%d_K%d_n%d-%d.rda", pi_arg, mu1, sigma1, K, n_low, n_high)
print(out_name)
save(all_results, file = out_name)


