# simulate under paramo models 
setwd("~/Documents/underground_evo")
library(SCATE.shortcourse)

for (tree in 7:10) {
  print(paste0("working on tree ", tree))
  load(paste0("paramo/output/paramo_results", tree, ".RData"))
  qs <- results[[1]]
  N <- length(results[[3]])
  num_q <- length(qs)
  
  rm(results)
  
  # reformat Q matrix
  for (q in 1:num_q) {
    qs[[q]][is.na(qs[[q]])] <- 0
    diag(qs[[q]]) <- -rowSums(qs[[q]])
  }
  
  t <- ape::read.tree("data/phylogeny/combined_subsampled_dated.tre")[[tree]]
  print("simulating")
  sim_trees <- list()
  for (q in 1:num_q) {
    sim_trees[[q]] <- phytools::sim.history(tree = t, Q =  qs[[q]], nsim = N)
  }
  
  # make td object to feed into discretization function with empty data
  
  empty_data <- data.frame(matrix(ncol = (length(qs) + 1),
                                  nrow = length(t$tip.label)))
  colnames(empty_data) <- c("species", names(qs))
  empty_data$species <- t$tip.label
  td.comb.empty <- make.treedata(tree = t,
                                 data = empty_data)
  
  print("discretizing")
  IND.maps  <- prepareMapsRayDISC(td.comb.empty, sim_trees, discretization_level = 1000)
  
  EP <- list(plant = c("leaf_under+bulb", 
                       "stem_under+corm+rhizome",
                       "root_tuber+disc_tub+cont_tub"))
  EP.maps <- vector("list", length(EP))
  names(EP.maps) <- names(EP)
  
  print("combining maps")
  for (j in 1:length(EP.maps)) {
    map<-paramo.list(EP[[j]], IND.maps, ntrees = N)
    EP.maps<-map
  }
  
  results <- list(Qmats = qs,
                  IND.maps = IND.maps,
                  EP.maps = EP.maps)
  
  
  save(results, file = paste0("paramo/simulations/sim_tree_", tree, ".RData"))
  rm(list = ls())
}
