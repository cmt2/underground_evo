setwd("/Users/carrietribble/Documents/underground_evo/")
source("comparison/scripts/compare_samples.R")
source("comparison/scripts/subset_chainOU.R")
library(bayou)
library(ggplot2)
library(ggthemes)
library(RevGadgets)
library(coda)

unique_analyses <- c("bio15_tree_1", "bio15_tree_2", 
                     "bio15_tree_3", "bio15_tree_4", 
                     "bio15_tree_5", 
                     "bio4_tree_1", "bio4_tree_2",
                     "bio4_tree_3", "bio4_tree_4",
                     "bio4_tree_5")

for (analysis in unique_analyses) {
  print(paste0("working on analysis ",analysis))
  # bayou data
  load(paste0("~/Documents/underground_evo/bayou/output/processed_output/", analysis, "_r001.RData"))
  b <- subset_chainOU(chainOU = set.burnin(chainOU, 0.10), 1000)
  rm(chainOU)
  tree <- unlist(strsplit(analysis, split = "_"))[3]
  load(paste0("~/Documents/underground_evo/paramo/simulations/sim_tree_", tree, ".RData"))
  sim <- results[[3]]
  rm(results)
  
  # change state labels for simulations where one character was inferred as constant
  
  # in tree 1, simulation 146 is constant for character 3 in state 4
  # in tree 2, simulations 200, 360, 536, and 956 have character 3 in state 4
  # in tree 4, simulation 96 has character 1 in state 3; simulation 648 has character 3 in state 4
  # in tree 5, simulation 847 has character 1 in state 3; simulation 177 has character 3 in state 4
  if (tree == 1) {
    for (branch in 1:length(sim[[146]]$maps)) {
      names(sim[[146]]$maps[[branch]]) <- paste0(names(sim[[146]]$maps[[branch]]), "4")
    }
  } else if (tree == 2) {
    for (branch in 1:length(sim[[200]]$maps)) {
      names(sim[[200]]$maps[[branch]]) <- paste0(names(sim[[200]]$maps[[branch]]), "4")
    }
    for (branch in 1:length(sim[[360]]$maps)) {
      names(sim[[360]]$maps[[branch]]) <- paste0(names(sim[[360]]$maps[[branch]]), "4")
    }
    for (branch in 1:length(sim[[536]]$maps)) {
      names(sim[[536]]$maps[[branch]]) <- paste0(names(sim[[536]]$maps[[branch]]), "4")
    }
    for (branch in 1:length(sim[[956]]$maps)) {
      names(sim[[956]]$maps[[branch]]) <- paste0(names(sim[[956]]$maps[[branch]]), "4")
    }
  } else if (tree == 4) {
    for (branch in 1:length(sim[[96]]$maps)) {
      names(sim[[96]]$maps[[branch]]) <- paste0("3", names(sim[[96]]$maps[[branch]]))
    }
    for (branch in 1:length(sim[[648]]$maps)) {
      names(sim[[648]]$maps[[branch]]) <- paste0(names(sim[[648]]$maps[[branch]]), "4")
    }
  } else if (tree == 5) {
    for (branch in 1:length(sim[[847]]$maps)) {
      names(sim[[847]]$maps[[branch]]) <- paste0("3", names(sim[[847]]$maps[[branch]]))
    }
    for (branch in 1:length(sim[[177]]$maps)) {
      names(sim[[177]]$maps[[branch]]) <- paste0(names(sim[[177]]$maps[[branch]]), "4")
    }
  }
  
  c <- compare_samples(bayou = b, paramo = sim)

  # make data frame 
  columns <- vector()
  for (row in 1:length(c)){
    columns <- append(columns, names(c[[row]]))
    if (sum(is.na(columns)) > 0) {print(row)}
  }
  columns <- unique(columns)
  
  df <- data.frame(matrix(nrow = length(c), ncol = length(columns)))
  colnames(df) <- columns
  
  #fill with data
  for (row in 1:length(c)) {
    for (col in columns){
      if (col %in% names(c[[row]])) {
        df[row,col] <- c[[row]][col] 
      } else {df[row,col] <- NA }
    }
  }
  # save comparison dataframes 
  write.csv(df, file = paste0("comparison/results/sim_", analysis, "_collapsed.csv"))
  
  # plot traces of densities to assess convergence 
  pdf(paste0("comparison/raw_figures/trace_sim_", analysis, "_collapsed.pdf"))
  for (i in 1:ncol(df)) {
    t <- as.mcmc(df[,i][!is.na(df[,i])])
    traceplot(t, main = paste0("Var = ", colnames(df)[i]))
  }
  dev.off()
  
  rm(c, sim, b, df)
}
