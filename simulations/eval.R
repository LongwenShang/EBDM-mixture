load(file = paste0("./results.rda"))

mu0 <- 0
sigma0 <- 1
unique_settings <- unique(results[, c("pi", "mu1_true", "sigma1_true", "samples_n_i", "samples_k")])
partial_settings <- unique(results[, c("pi", "mu1_true", "sigma1_true")])
################################################################################
#BOXPLOT
################################################################################
library(ggplot2)
library(ggpattern)

make_title_short <- function(pp, mm, ss) {
  if (identical(pp, "random")) {
    bquote(pi[i] %~% "TN" ~ "\n" ~
             mu[1] == .(mm) ~ "," ~ sigma[1] == .(ss))
  } else {
    bquote(pi[i] == .(as.numeric(pp)) ~ "\n" ~
             mu[1] == .(mm) ~ "," ~ sigma[1] == .(ss))
  }
}

#mu1
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  DD1 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 200)
  DD2 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 1000)
  if (nrow(DD1) == 0 | nrow(DD2) == 0) next
  DD1$group <- "ni around 200"
  DD2$group <- "ni around 1000"
  combined_data <- rbind(DD1, DD2)
  combined_data$samples_k     <- as.factor(combined_data$samples_k)
  combined_data$group <- as.factor(combined_data$group)
  q1 <- quantile(combined_data$mu1_hat_scale, 0.25, na.rm = TRUE)
  q3 <- quantile(combined_data$mu1_hat_scale, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(combined_data$mu1_hat_scale), q1 - 1.5 * iqr)
  upper <- min(max(combined_data$mu1_hat_scale), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, mm))
  xmargin <- 2 * diff(xrange)
  gplot <- ggplot(combined_data, aes(x = mu1_hat_scale, y = samples_k, fill = group)) +
    geom_boxplot() +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = mm, color = "red", linetype = "dashed", size = 0.8) +
    scale_fill_manual(values = c("lightgrey", "white"),
                      guide = guide_legend(reverse = TRUE)) +
    labs(
      title = title_expr,
      x = expression(hat(mu)[1]),
      y = expression(k)
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 14, family = "serif"),
      axis.title.x = element_text(size = 14, family = "serif"),
      axis.text = element_text(size = 12, family = "serif"),
      legend.text = element_text(size = 12, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top")
    )
  plot(gplot)
  
}



#mu0
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  DD1 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 200)
  DD2 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 1000)
  if (nrow(DD1) == 0 | nrow(DD2) == 0) next
  DD1$group <- "ni around 200"
  DD2$group <- "ni around 1000"
  combined_data <- rbind(DD1, DD2)
  combined_data$samples_k     <- as.factor(combined_data$samples_k)
  combined_data$group <- as.factor(combined_data$group)
  q1 <- quantile(combined_data$mu0_hat_scale, 0.25, na.rm = TRUE)
  q3 <- quantile(combined_data$mu0_hat_scale, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(combined_data$mu0_hat_scale), q1 - 1.5 * iqr)
  upper <- min(max(combined_data$mu0_hat_scale), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, mu0))
  xmargin <- 2 * diff(xrange)
  gplot <- ggplot(combined_data, aes(x = mu0_hat_scale, y = samples_k, fill = group)) +
    geom_boxplot() +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = mu0, color = "red", linetype = "dashed", size = 0.8) +
    scale_fill_manual(values = c("lightgrey", "white"),
                      guide = guide_legend(reverse = TRUE)) +
    labs(
      title = title_expr,
      x = expression(hat(mu)[0]),
      y = expression(k)
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 14, family = "serif"),
      axis.title.x = element_text(size = 14, family = "serif"),
      axis.text = element_text(size = 12, family = "serif"),
      legend.text = element_text(size = 12, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top")
    )
  plot(gplot)
}



#sigma1
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  DD1 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 200)
  DD2 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 1000)
  if (nrow(DD1) == 0 | nrow(DD2) == 0) next
  DD1$group <- "ni around 200"
  DD2$group <- "ni around 1000"
  combined_data <- rbind(DD1, DD2)
  combined_data$samples_k     <- as.factor(combined_data$samples_k)
  combined_data$group <- as.factor(combined_data$group)
  q1 <- quantile(combined_data$sigma1_hat_scale, 0.25, na.rm = TRUE)
  q3 <- quantile(combined_data$sigma1_hat_scale, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(combined_data$sigma1_hat_scale), q1 - 1.5 * iqr)
  upper <- min(max(combined_data$sigma1_hat_scale), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, ss))
  xmargin <- 2 * diff(xrange)
  gplot <- ggplot(combined_data, aes(x = sigma1_hat_scale, y = samples_k, fill = group)) +
    geom_boxplot() +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = ss, color = "red", linetype = "dashed", size = 0.8) +
    scale_fill_manual(values = c("lightgrey", "white"),
                      guide = guide_legend(reverse = TRUE)) +
    labs(
      title = title_expr,
      x = expression(hat(sigma)[1]),
      y = expression(k)
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 14, family = "serif"),
      axis.title.x = element_text(size = 14, family = "serif"),
      axis.text = element_text(size = 12, family = "serif"),
      legend.text = element_text(size = 12, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top")
    )
  plot(gplot)
}

#sigma0
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  DD1 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 200)
  DD2 <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == 1000)
  if (nrow(DD1) == 0 | nrow(DD2) == 0) next
  DD1$group <- "ni around 200"
  DD2$group <- "ni around 1000"
  combined_data <- rbind(DD1, DD2)
  combined_data$samples_k     <- as.factor(combined_data$samples_k)
  combined_data$group <- as.factor(combined_data$group)
  q1 <- quantile(combined_data$sigma0_hat_scale, 0.25, na.rm = TRUE)
  q3 <- quantile(combined_data$sigma0_hat_scale, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(combined_data$sigma0_hat_scale), q1 - 1.5 * iqr)
  upper <- min(max(combined_data$sigma0_hat_scale), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, sigma0))
  xmargin <- 2 * diff(xrange)
  gplot <- ggplot(combined_data, aes(x = sigma0_hat_scale, y = samples_k, fill = group)) +
    geom_boxplot() +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = sigma0, color = "red", linetype = "dashed", size = 0.8) +
    scale_fill_manual(values = c("lightgrey", "white"),
                      guide = guide_legend(reverse = TRUE)) +
    labs(
      title = title_expr,
      x = expression(hat(sigma)[0]),
      y = expression(k)
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5, family = "serif"),
      legend.title = element_blank(),
      axis.title.y = element_text(angle = 0, size = 14, family = "serif"),
      axis.title.x = element_text(size = 14, family = "serif"),
      axis.text = element_text(size = 12, family = "serif"),
      legend.text = element_text(size = 12, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top")
    )
  plot(gplot)
  
}

################################################################################
#CI
################################################################################
colnames(results)
library(dplyr)
coverage_summary <- results %>%
  group_by(pi, mu1_true, sigma1_true, sigma0_true, samples_k, samples_n_i) %>%
  summarise(
    mu0_coverage    = 1 - mean(mu0_cover, na.rm = TRUE),
    mu1_coverage    = 1 - mean(mu1_cover, na.rm = TRUE),
    sigma0_coverage = 1 - mean(sigma0_cover, na.rm = TRUE),
    sigma1_coverage = 1 - mean(sigma1_cover, na.rm = TRUE),
    reps = n(),
    .groups = "drop"
  )
################################################################################
# compare GMM and Naive
################################################################################
library(ggplot2)
fixed_ni <- 200
method_labels <- c(bl = "Naive", scale = "Proposed")
fill_colors   <- c(bl = "gray70",   scale = "white")

#mu1
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  dd <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == fixed_ni)
  if (!nrow(dd)) next
  k_levels <- c(10, 20, 30, 50, 100)
  dd$samples_k <- factor(dd$samples_k, levels = k_levels)
  pieces <- list(
    data.frame(samples_k = dd$samples_k, method = factor("scale", levels = c("bl","scale")),
               est = dd$mu1_hat_scale, true_val = dd$mu1_true),
    data.frame(samples_k = dd$samples_k, method = factor("bl",    levels = c("bl","scale")),
               est = dd$mu1_hat_bl,    true_val = dd$mu1_true)
  )
  longdf <- do.call(rbind, pieces)
  if (!nrow(longdf)) next
  true_v <- unique(longdf$true_val); if (length(true_v) != 1L) true_v <- true_v[1L]
  q1 <- quantile(longdf$est, 0.25, na.rm = TRUE)
  q3 <- quantile(longdf$est, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(longdf$est), q1 - 1.5 * iqr)
  upper <- min(max(longdf$est), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, true_v))
  xmargin <- 2 * diff(xrange)
  p <- ggplot(longdf, aes(x = est, y = samples_k, fill = method)) +
    geom_boxplot(alpha = 0.7, outlier.size = 0.4) +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = true_v, linetype = "dashed", color = "red", linewidth = 0.6) +
    scale_fill_manual(values = fill_colors, labels = method_labels) +
    labs(
      title = title_expr,
      x = expression(hat(mu)[1]),
      y = expression(k),
      fill = NULL
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title      = element_text(size = 16, face = "bold", hjust = 0.5, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top"),
      legend.text     = element_text(size = 11, family = "serif"),
      axis.title.x    = element_text(size = 12, family = "serif"),
      axis.title.y    = element_text(size = 12, family = "serif"),
      axis.text       = element_text(size = 10, family = "serif")
    )
  print(p)
}


#mu0
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  dd <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == fixed_ni)
  if (!nrow(dd)) next
  k_levels <- c(10, 20, 30, 50, 100)
  dd$samples_k <- factor(dd$samples_k, levels = k_levels)
  pieces <- list(
    data.frame(samples_k = dd$samples_k, method = factor("scale", levels = c("bl","scale")),
               est = dd$mu0_hat_scale, true_val = dd$mu0_true),
    data.frame(samples_k = dd$samples_k, method = factor("bl",    levels = c("bl","scale")),
               est = dd$mu0_hat_bl,    true_val = dd$mu0_true)
  )
  longdf <- do.call(rbind, pieces)
  if (!nrow(longdf)) next
  true_v <- unique(longdf$true_val); if (length(true_v) != 1L) true_v <- true_v[1L]
  q1 <- quantile(longdf$est, 0.25, na.rm = TRUE)
  q3 <- quantile(longdf$est, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(longdf$est), q1 - 1.5 * iqr)
  upper <- min(max(longdf$est), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, true_v))
  xmargin <- 2 * diff(xrange) 
  p <- ggplot(longdf, aes(x = est, y = samples_k, fill = method)) +
    geom_boxplot(alpha = 0.7, outlier.size = 0.4) +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = true_v, linetype = "dashed", color = "red", linewidth = 0.6) +
    scale_fill_manual(values = fill_colors, labels = method_labels) +
    labs(
      title = title_expr,
      x = expression(hat(mu)[0]),
      y = expression(k),
      fill = NULL
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title      = element_text(size = 16, face = "bold", hjust = 0.5, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top"),
      legend.text     = element_text(size = 11, family = "serif"),
      axis.title.x    = element_text(size = 12, family = "serif"),
      axis.title.y    = element_text(size = 12, family = "serif"),
      axis.text       = element_text(size = 10, family = "serif")
    )
  print(p)
}


#sigma1
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  dd <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == fixed_ni)
  if (!nrow(dd)) next
  k_levels <- c(10, 20, 30, 50, 100)
  dd$samples_k <- factor(dd$samples_k, levels = k_levels)
  pieces <- list(
    data.frame(samples_k = dd$samples_k, method = factor("scale", levels = c("bl","scale")),
               est = dd$sigma1_hat_scale, true_val = dd$sigma1_true),
    data.frame(samples_k = dd$samples_k, method = factor("bl",    levels = c("bl","scale")),
               est = dd$sigma1_hat_bl,    true_val = dd$sigma1_true)
  )
  longdf <- do.call(rbind, pieces)
  if (!nrow(longdf)) next
  true_v <- unique(longdf$true_val); if (length(true_v) != 1L) true_v <- true_v[1L]
  q1 <- quantile(longdf$est, 0.25, na.rm = TRUE)
  q3 <- quantile(longdf$est, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(longdf$est), q1 - 1.5 * iqr)
  upper <- min(max(longdf$est), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, true_v))
  xmargin <- 2 * diff(xrange)
  p <- ggplot(longdf, aes(x = est, y = samples_k, fill = method)) +
    geom_boxplot(alpha = 0.7, outlier.size = 0.4) +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = true_v, linetype = "dashed", color = "red", linewidth = 0.6) +
    scale_fill_manual(values = fill_colors, labels = method_labels) +
    labs(
      title = title_expr,
      x = expression(hat(sigma)[1]),
      y = expression(k),
      fill = NULL
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title      = element_text(size = 16, face = "bold", hjust = 0.5, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top"),
      legend.text     = element_text(size = 11, family = "serif"),
      axis.title.x    = element_text(size = 12, family = "serif"),
      axis.title.y    = element_text(size = 12, family = "serif"),
      axis.text       = element_text(size = 10, family = "serif")
    )
  print(p)
}


#sigma0
for (j in 1:nrow(partial_settings)) {
  setting <- partial_settings[j, ]
  pp = setting$pi
  mm = setting$mu1_true
  ss = setting$sigma1_true
  title_expr <- make_title_short(pp, mm, ss)
  dd <- subset(results, pi == pp & mu1_true == mm & sigma1_true == ss & samples_n_i == fixed_ni)
  if (!nrow(dd)) next
  k_levels <- c(10, 20, 30, 50, 100)
  dd$samples_k <- factor(dd$samples_k, levels = k_levels)
  pieces <- list(
    data.frame(samples_k = dd$samples_k, method = factor("scale", levels = c("bl","scale")),
               est = dd$sigma0_hat_scale, true_val = dd$sigma0_true),
    data.frame(samples_k = dd$samples_k, method = factor("bl",    levels = c("bl","scale")),
               est = dd$sigma0_hat_bl,    true_val = dd$sigma0_true)
  )
  longdf <- do.call(rbind, pieces)
  if (!nrow(longdf)) next
  true_v <- unique(longdf$true_val); if (length(true_v) != 1L) true_v <- true_v[1L]
  q1 <- quantile(longdf$est, 0.25, na.rm = TRUE)
  q3 <- quantile(longdf$est, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- max(min(longdf$est), q1 - 1.5 * iqr)
  upper <- min(max(longdf$est), q3 + 1.5 * iqr)
  xrange <- range(c(lower, upper, true_v))
  xmargin <- 2 * diff(xrange)
  p <- ggplot(longdf, aes(x = est, y = samples_k, fill = method)) +
    geom_boxplot(alpha = 0.7, outlier.size = 0.4) +
    stat_summary(fun = mean, geom = "point", shape = 24, size = 2, color = "blue", position = position_dodge(width = 0.75))+
    geom_vline(xintercept = true_v, linetype = "dashed", color = "red", linewidth = 0.6) +
    scale_fill_manual(values = fill_colors, labels = method_labels) +
    labs(
      title = title_expr,
      x = expression(hat(sigma)[0]),
      y = expression(k),
      fill = NULL
    ) +
    xlim(xrange[1] - xmargin, xrange[2] + xmargin) +
    theme(
      plot.title      = element_text(size = 16, face = "bold", hjust = 0.5, family = "serif"),
      legend.position = c(0.01, 0.99),
      legend.justification = c("left", "top"),
      legend.text     = element_text(size = 11, family = "serif"),
      axis.title.x    = element_text(size = 12, family = "serif"),
      axis.title.y    = element_text(size = 12, family = "serif"),
      axis.text       = element_text(size = 10, family = "serif")
    )
  print(p)
}





