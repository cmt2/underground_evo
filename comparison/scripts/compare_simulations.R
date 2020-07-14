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
  
  # in tree 1, simulation #146 is constant for character 3 in state 4
  if (tree == 1) {
    for (branch in 1:length(sim[[146]]$maps)) {
      names(sim[[146]]$maps[[branch]]) <- paste0(names(sim[[146]]$maps[[branch]]), "4")
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
  write.csv(df, file = paste0("comparison/results/", analysis, "_collapsed.csv"))
  
  # plot densities 
  #df_melted <- reshape2::melt(df)
  #colors <- RevGadgets:::.colFun(length(columns))
  #names(colors) <- columns
  
  #pdf(paste0("comparison/figures/", analysis, ".pdf"))
  #ggplot(data = df_melted, 
  #       aes(value, fill = variable, colour = variable)) +
  #  geom_density(alpha = 0.1) + 
  #  scale_color_manual(values = colors) +
  #  scale_fill_manual(values = colors) +
  #  ggtitle(analysis) +
  #  theme_few()
  #dev.off()
  
  # plot traces of densities to assess convergence 
  pdf(paste0("comparison/raw_figures/trace_", analysis, "_collapsed.pdf"))
  for (i in 1:ncol(df)) {
    t <- as.mcmc(df[,i][!is.na(df[,i])])
    traceplot(t, main = paste0("Var = ", colnames(df)[i]))
  }
  dev.off()
}
