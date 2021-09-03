#compare character-level data 

setwd("/Users/carrietribble/Documents/underground_evo/")
source("comparison/scripts/compare_samples.R")
source("comparison/scripts/subset_chainOU.R")
library(bayou)
library(ggplot2)
library(ggthemes)
library(RevGadgets)
library(coda)


# trees <- 1:5
trees <- 7:10

for (tree in trees) {
  # load paramo results once 
  load(paste0("~/Documents/underground_evo/paramo/output/paramo_results", tree, ".RData"))
  paramo <- results$IND.maps
  rm(results)
  
  # load bayou data once
  # load(paste0("~/Documents/underground_evo/bayou/output/processed_output/bio4_tree_", tree, "_r001.RData"))
  # b4 <- subset_chainOU(chainOU = set.burnin(chainOU, 0.10), 1000)
  # rm(chainOU)
  load(paste0("~/Documents/underground_evo/bayou/output/processed_output/bio4_tree_", tree, ".RData"))
  b4 <- subset_chainOU(chainOU = combined, 1000)
  rm(combined)
  
  # load(paste0("~/Documents/underground_evo/bayou/output/processed_output/bio15_tree_", tree, "_r001.RData"))
  # b15 <- subset_chainOU(chainOU = set.burnin(chainOU, 0.10), 1000)
  # rm(chainOU)
  load(paste0("~/Documents/underground_evo/bayou/output/processed_output/bio15_tree_", tree, ".RData"))
  b15 <- subset_chainOU(chainOU = combined, 1000)
  rm(combined)
  
  
  for (p in 1:3) {
    print(paste0("comparing character ", p, " and bio4 for tree ", tree))
    c4 <- compare_samples(bayou = b4, paramo = paramo[[p]], combined = FALSE, char = p)
    
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
    write.csv(df, file = paste0("comparison/character_results/bio4_tree_", tree, "_character_", p, "_collapsed.csv"))
    
    # plot traces of densities to assess convergence 
    pdf(paste0("comparison/figures/trace_figures/trace_bio4_tree_", tree, "_character_", p, "_collapsed.pdf"))
    for (i in 1:ncol(df)) {
      t <- as.mcmc(df[,i][!is.na(df[,i])])
      traceplot(t, main = paste0("Var = ", colnames(df)[i]))
    }
    dev.off()
    
    ### bio15
    print(paste0("comparing character ", p, " and bio15 for tree ", tree))
    c15 <- compare_samples(bayou = b15, paramo = paramo[[p]], combined = FALSE, char = p)
    
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
    write.csv(df, file = paste0("comparison/character_results/bio15_tree_", tree, "_character_", p, "_collapsed.csv"))
    
    # plot traces of densities to assess convergence 
    pdf(paste0("comparison/figures/trace_figures/trace_bio15_tree_", tree, "_character_", p, "_collapsed.pdf"))
    for (i in 1:ncol(df)) {
      t <- as.mcmc(df[,i][!is.na(df[,i])])
      traceplot(t, main = paste0("Var = ", colnames(df)[i]))
    }
    dev.off()
  }
  rm(b15,b4,paramo)
}
