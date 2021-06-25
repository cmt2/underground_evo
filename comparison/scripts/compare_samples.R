# bayou should be a list of 1000 bayou simmaps (sampled from posterior)
# paramo should be a list of 1000 paramo EP simmaps 
source("comparison/scripts/compute_ave_theta_per_state.R")
library(progress)
compare_samples <- function(bayou, paramo, combined = TRUE, char = NA) {
  if (length(bayou) != length(paramo)) stop("lengths of lists not equal")
  l <- length(bayou)
  
  pb <- progress_bar$new(
    format = "  computing [:bar] :percent eta: :eta",
    total = 1000, clear = FALSE, width= 60)
  
  results <- list()
  
  pb$tick(0)
  
  for (i in 1:1000) {
    results[[i]] <- compute_ave_theta_per_state(bayou_map = bayou[[i]],
                                                paramo_map = paramo[[i]],
                                                combined = combined,
                                                char = char)
    pb$tick()
  }
 return(results) 
}