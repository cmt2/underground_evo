library(ggplot2)
library(ggthemes)

plot_metric <- function(clim_var, char, trees, split) {
  results <- read.csv("comparison/metric_results_all.csv", row.names = 1)
  if (char != "combined") {
    cols <- paste0("ch", char, "_", clim_var, "_", trees)
  } else if (char == "combined") {
    cols <- paste0("combined_", clim_var, "_", trees)
  }
  
  if (split == "half") {
    cols_a <- cols[1 : (length(cols)/2)]
    cols_b <- cols[(length(cols)/2 + 1) : length(cols)]
    metric_a <- unlist(results[ ,cols_a])
    metric_b <- unlist(results[ ,cols_b])
    metric_a <- metric_a[!is.na(metric_a)]
    metric_b <- metric_b[!is.na(metric_b)]
    data <- data.frame(metric = c(metric_a, metric_b),
                       dataset = c(rep(paste0("1 - ", length(cols)/2), 
                                       times = length(metric_a)),
                                   rep(paste0((length(cols)/2 + 1), " - ", length(cols)), 
                                       times = length(metric_b) ) ) ) 
  } else if (split == "none") {
    metric <- unlist(results[,cols])
    names(metric) <- NULL
    metric <- metric[!is.na(metric)]
    data <- data.frame(metric = metric)
    rm(metric)
  } else if (split == "all") {
    metric <- unlist(results[,cols])
    names(metric) <- NULL
    data <- data.frame(metric = metric,
                       dataset = rep(as.character(1:10), 
                                     each = nrow(results)))
    data <- data[!is.na(data$metric),]
  }
  
  # plotting aesthetics
  if (char == "1") {color <- "#32A354"}
  if (char == "2") {color <- "#293990"}
  if (char == "3") {color <- "#F8992C"}
  if (char == "combined") {color <- "#AA0A3C"}
  
  if (split == "none") {
    
    sig_value <- round(sum(data$metric < 0)/ length(data$metric), digits = 3)
    if (sig_value <= 0.05) {sig_value <- paste0(sig_value, "*")}
    
    p <- ggplot(data) +
      geom_density(aes(metric),
                   col = color, 
                   fill = color,
                   alpha = 0.3)
    d <- ggplot_build(p)$data[[1]]
    
    plot <- p + 
      geom_area(data = subset(d, x < 0), 
                aes(x=x, y=y), 
                fill = color,
                col = color,
                alpha = 1) +
      geom_vline(xintercept = 0,
                 lty = "dashed") +
      annotate("text", 
               x = min(data$metric), 
               y = 0.5 * max(d$ymax), 
               label = paste0("P-Value: ", sig_value),
               hjust = 0) +
      theme_few() +
      theme(axis.ticks.y = element_blank(),
            axis.text.y =  element_blank())
  } else if (split == "half") {
    
    sig_value_a <- round(sum(metric_a < 0)/ length(metric_a), digits = 3)
    if (sig_value_a <= 0.05) {sig_value_a <- paste0(sig_value_a, "*")}
    
    sig_value_b <- round(sum(metric_b < 0)/ length(metric_b), digits = 3)
    if (sig_value_b <= 0.05) {sig_value_b <- paste0(sig_value_b, "*")}
    
    p <- ggplot(data) +
      geom_density(aes(x = metric,
                       linetype = dataset),
                   col = color,
                   fill = color,
                   alpha = .5)
    d <- ggplot_build(p)$data[[1]]
    line_dat <- data.frame(x = rep(min(data$metric), 2),
                           xend = rep((1.1 * min(data$metric)), 2),
                           y = c(0.95 * max(d$ymax), 0.85 * max(d$ymax)),
                           yend = c(0.95 * max(d$ymax), 0.85 * max(d$ymax)),
                           linetype = c(paste0("1 - ", length(cols)/2),
                                        paste0((length(cols)/2 + 1), " - ", length(cols))))
    plot <- p + 
      # solid square
      geom_segment(data = line_dat, aes(x = x, xend = xend, 
                                        y = y, yend = yend,
                                        linetype = linetype),
                col = color) +
      geom_vline(xintercept = 0,
                 lty = "longdash") +
      annotate("text", 
               x = (min(data$metric) * .9), 
               y = 0.95 * max(d$ymax), 
               label = paste0("P-Value: ", sig_value_a),
               hjust = 0) +
      annotate("text", 
               x = (min(data$metric) * .9), 
               y = 0.85 * max(d$ymax), 
               label = paste0("P-Value: ", sig_value_b),
               hjust = 0) +
    
      theme_few() +
      theme(axis.ticks.y = element_blank(),
            axis.text.y =  element_blank(),
            legend.position = "none")
  } else if (split == "all") {
    sig_value_fn <- function(x) {round(sum(x < 0)/ length(x), digits = 3)}
    
    data %>%
      group_by(dataset) %>%
      mutate(sig_value = sig_value_fn(metric)) %>%
      select(sig_value) %>%
      unique() %>%
      ungroup() %>%
      pull(sig_value) -> sig_values
    
    p <- ggplot(data) +
      geom_density(aes(x = metric,
                       group = dataset),
                   col = color,
                   fill = color,
                   alpha = .1)
    
    d <- ggplot_build(p)$data[[1]]
    
    plot <- p +
      geom_vline(xintercept = 0,
                 lty = "longdash") +
      annotate("text", 
               x = (min(data$metric)), 
               y = 0.95 * max(d$ymax), 
               label = paste0("P-Values: ",
                              min(sig_values), 
                              " - ", 
                              max(sig_values)),
               hjust = 0) +
      theme_few() +
      theme(axis.ticks.y = element_blank(),
            axis.text.y =  element_blank(),
            legend.position = "none")
    
  }
  return(plot)
}
