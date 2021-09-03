library(gtools)
library(ggplot2)
library(gridExtra)
library(cowplot)
# function to generate significance values for all combinations 
# of a certain number of trees 
# produces a vector of all significance values 
# length of vector depends on the number of trees sampled (n_trees)
get_sig_values <- function(n_trees, clim_var, char) {
  
  trees <- combinations(n = 10, r = n_trees, v = 1:10, repeats.allowed = FALSE)
  sig_value <- numeric()
  
  for (n in 1:nrow(trees)) {
    results <- read.csv("comparison/metric_results_all.csv", row.names = 1)
    if (char != "combined") {
      cols <- paste0("ch", char, "_", clim_var, "_", trees[n,])
    } else if (char == "combined") {
      cols <- paste0("combined_", clim_var, "_", trees[n,])
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
    
    sig_value[n] <- round(sum(data$metric < 0)/ length(data$metric), digits = 3)
  }
  return(sig_value)
}

# plot histograms of the vectors 
chars <- c("1", "2","3","combined")
clim_vars <- c("bio4","bio15")


grid <- expand.grid(1:9, clim_vars, chars)

graphs <- apply(grid, 1, function(row) {
  s <- get_sig_values(n_trees = as.integer(row[1]), 
                      clim_var = row[2], 
                      char = row[3])
  g <- qplot(s, 
             geom = "histogram", 
             bins = 20, 
             fill=I("grey40"), 
             color=I("white")) + 
    ggthemes::theme_few() +
    xlab("")
    
  if (row[3] == "1" & row[2] == "bio4") {
    g <- g + ggtitle(paste0(row[1], " trees sampled"))
  } 
  
  return(g)
})

pdf("comparison/figures/sig_values.pdf", height = 40, width = 60 )
grid.arrange(grobs = lapply(graphs, as_grob), ncol = 9)
dev.off()
