### combine Bayou runs! 

# basic shit 
setwd("~/Documents/underground_evo/bayou/output")
loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}
library(bayou)

# names to combine over
df <- expand.grid(c("bayou_bio15_tree","bayou_bio4_tree"), as.character(1:10), stringsAsFactors = FALSE)
unique_analyses  <- apply(df, 1, paste0, collapse = "_")


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
