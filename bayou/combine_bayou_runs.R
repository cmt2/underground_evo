### combine Bayou runs! 

# basic shit 
setwd("~/Documents/underground_evo/bayou/output/processed_output/")
loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}
library(bayou)

# names to combine over
unique_analyses <- c("bio15_tree_1", "bio15_tree_2", 
                     "bio15_tree_3", "bio15_tree_4", 
                     "bio15_tree_5", 
                     "bio4_tree_1", "bio4_tree_2",
                     "bio4_tree_3", "bio4_tree_4",
                     "bio4_tree_5")

for (analysis in unique_analyses) {
  to_combine <- list()
  # read in all runs for the analysis
  i <- 1
  for (file in paste0(analysis, "_r00", 1:4, ".RData")){
    to_combine[[i]] <- loadRData(file)
    i <- i + 1
  }
  combined <- combine.chains(to_combine, burnin.prop = 0.1)
  save(combined, file = paste0(analysis, ".RData"))
}