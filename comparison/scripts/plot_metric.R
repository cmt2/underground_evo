plot_metric <- function(clim_var, char, trees) {
  results <- read.csv("comparison/metric_results_all.csv", row.names = 1)
  if (char != "combined") {
    cols <- paste0("ch", char, "_", clim_var, "_", trees)
  } else if (char == "combined") {
    cols <- paste0("combined_", clim_var, "_", trees)
  }
  metric <- unlist(results[,cols])
  names(metric) <- NULL
  metric <- metric[!is.na(metric)]
  data <- data.frame(metric = metric)
  rm(metric)

  # plotting aesthetics
  if (char == "1") {color <- "#32A354"}
  if (char == "2") {color <- "#293990"}
  if (char == "3") {color <- "#F8992C"}
  if (char == "combined") {color <- "#AA0A3C"}
  
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
             y = 0.95 * max(d$ymax), 
             label = paste0("P-Value: ", sig_value),
             hjust = 0) +
    theme_few() +
    theme(axis.ticks.y = element_blank(),
          axis.text.y =  element_blank())
  
  return(plot)
}
