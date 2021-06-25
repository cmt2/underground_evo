setwd("/Users/carrietribble/Documents/underground_evo/")
source("comparison/scripts/compare_samples.R")
source("comparison/scripts/subset_chainOU.R")
library(bayou)
library(ggplot2)
library(ggthemes)
library(RevGadgets)
library(coda)

trees <- 2:5

for (tree in trees) {
  # load paramo data once
  print(paste0("loading paramo tree ", tree))
  load(paste0("~/Documents/underground_evo/paramo/simulations/sim_tree_", tree, ".RData"))
  param_chars <- results[[2]]
  rm(results)

  # load bayou data once
  print(paste0("loading bayou bio 4 tree ", tree))
  load(paste0("~/Documents/underground_evo/bayou/output/processed_output/bio4_tree_", tree, "_r001.RData"))
  b4 <- subset_chainOU(chainOU = set.burnin(chainOU, 0.10), 1000)
  rm(chainOU)
  
  print(paste0("loading bayou bio 15 tree ", tree))
  load(paste0("~/Documents/underground_evo/bayou/output/processed_output/bio15_tree_", tree, "_r001.RData"))
  b15 <- subset_chainOU(chainOU = set.burnin(chainOU, 0.10), 1000)
  rm(chainOU)
  
  print("fixing trees with constant states")
  if (tree == 1) {
    for (branch in 1:length(param_chars[[3]][[146]]$maps)) {
      names(param_chars[[3]][[146]]$maps[[branch]]) <- rep("4", times = length(param_chars[[3]][[146]]$maps[[branch]]))
    }
  } else if (tree == 2) {
    for (branch in 1:length(param_chars[[3]][[200]]$maps)) {
      names(param_chars[[3]][[200]]$maps[[branch]]) <- rep("4", times = length(param_chars[[3]][[200]]$maps[[branch]]))
    }
    for (branch in 1:length(param_chars[[3]][[360]]$maps)) {
      names(param_chars[[3]][[360]]$maps[[branch]]) <- rep("4", times = length(param_chars[[3]][[360]]$maps[[branch]]))
    }
    for (branch in 1:length(param_chars[[3]][[536]]$maps)) {
      names(param_chars[[3]][[536]]$maps[[branch]]) <- rep("4", times = length(param_chars[[3]][[536]]$maps[[branch]]))
    }
    for (branch in 1:length(param_chars[[3]][[956]]$maps)) {
      names(param_chars[[3]][[956]]$maps[[branch]]) <- rep("4", times = length(param_chars[[3]][[956]]$maps[[branch]]))
    }
  } else if (tree == 4) {
    for (branch in 1:length(param_chars[[1]][[96]]$maps)) {
      names(param_chars[[1]][[96]]$maps[[branch]]) <- rep("3", times = length(param_chars[[1]][[96]]$maps[[branch]]))
    }
    for (branch in 1:length(param_chars[[3]][[648]]$maps)) {
      names(param_chars[[3]][[648]]$maps[[branch]]) <- rep("4", times = length(param_chars[[3]][[648]]$maps[[branch]]))
    }
  } else if (tree == 5) {
    for (branch in 1:length(param_chars[[1]][[847]]$maps)) {
      names(param_chars[[1]][[847]]$maps[[branch]]) <- rep("3", times = length(param_chars[[1]][[847]]$maps[[branch]]))
    }
    for (branch in 1:length(param_chars[[3]][[177]]$maps)) {
      names(param_chars[[3]][[177]]$maps[[branch]]) <- rep("4", times = length(param_chars[[3]][[177]]$maps[[branch]]))
    }
  }

  for (p in 1:3) {
    print(paste0("comparing simulated character ", p, " and bio4 for tree ", tree))
    c4 <- compare_samples(bayou = b4, paramo = param_chars[[p]],  combined = FALSE, char = p)
    
    # make data frame 
    columns <- vector()
    for (row in 1:length(c4)){
      columns <- append(columns, names(c4[[row]]))
      if (sum(is.na(columns)) > 0) {print(row)}
    }
    columns <- unique(columns)
    
    df <- data.frame(matrix(nrow = length(c4), ncol = length(columns)))
    colnames(df) <- columns
    
    #fill with data
    for (row in 1:length(c4)) {
      for (col in columns){
        if (col %in% names(c4[[row]])) {
          df[row,col] <- c4[[row]][col] 
        } else {df[row,col] <- NA }
      }
    }
    # save comparison dataframes 
    write.csv(df, file = paste0("comparison/character_results/sim_bio4_tree_", tree, "_character_", p, "_collapsed.csv"))
    
    # plot traces of densities to assess convergence 
    pdf(paste0("comparison/trace_figures/sim_trace_bio4_tree_", tree, "_character_", p, "_collapsed.pdf"))
    for (i in 1:ncol(df)) {
      t <- as.mcmc(df[,i][!is.na(df[,i])])
      traceplot(t, main = paste0("Var = ", colnames(df)[i]))
    }
    dev.off()
    
    
    print(paste0("comparing simulated character ", p, " and bio15 for tree ", tree))
    c15 <- compare_samples(bayou = b15, paramo = param_chars[[p]],  combined = FALSE, char = p)
    
    # make data frame 
    columns <- vector()
    for (row in 1:length(c15)){
      columns <- append(columns, names(c15[[row]]))
      if (sum(is.na(columns)) > 0) {print(row)}
    }
    columns <- unique(columns)
    
    df <- data.frame(matrix(nrow = length(c15), ncol = length(columns)))
    colnames(df) <- columns
    
    #fill with data
    for (row in 1:length(c15)) {
      for (col in columns){
        if (col %in% names(c15[[row]])) {
          df[row,col] <- c15[[row]][col] 
        } else {df[row,col] <- NA }
      }
    }
    # save comparison dataframes 
    write.csv(df, file = paste0("comparison/character_results/sim_bio15_tree_", tree, "_character_", p, "_collapsed.csv"))
    
    # plot traces of densities to assess convergence 
    pdf(paste0("comparison/trace_figures/sim_trace_bio15_tree_", tree, "_character_", p, "_collapsed.pdf"))
    for (i in 1:ncol(df)) {
      t <- as.mcmc(df[,i][!is.na(df[,i])])
      traceplot(t, main = paste0("Var = ", colnames(df)[i]))
    }
    dev.off()
  }
  
  rm(c4, c15, param_chars, b4, b15, df)
}
