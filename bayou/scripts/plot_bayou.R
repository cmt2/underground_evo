## plot bayou analyses 

unique_analyses <- c("bio15_tree_1", "bio15_tree_2", 
                     "bio15_tree_3", "bio15_tree_4", 
                     "bio15_tree_5", 
                     "bio4_tree_1", "bio4_tree_2",
                     "bio4_tree_3", "bio4_tree_4",
                     "bio4_tree_5")

for (analysis in unique_analyses) {
  load(paste0("bayou/output/processed_output/", analysis, "_r001.RData"))
  
  # check that all elements of bayou results have same length 
  lengths <- unlist(lapply(chainOU, length))
  gen <- lengths[1]
  not_equal <- lengths[which(lengths != gen)]
  if (length(not_equal) > 0) {
    m <- min(lengths)
    chainOU_new <- chainOU
    for (element in 1:length(chainOU_new)) {
      chainOU_new[[element]] <- chainOU_new[[element]][1:m]
    }
    chainOU <- chainOU_new
  }
  pdf(paste0("bayou/figures/", analysis, ".pdf"), height = 20, width = 15)
  plotSimmap.mcmc(chainOU, burnin = 0.1, 
                  edge.type = "theta", 
                  pp.cutoff = 0.3, 
                  cex = .5)     
  dev.off()
  
}
