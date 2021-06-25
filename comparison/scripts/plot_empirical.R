### function to plot results - empirical data only 

plot_empirical <- function(clim_var, char, null = FALSE) {
  library(ggplot2)
  library(ggthemes)
  if (char == "combined"){
    data_paths <- paste0("comparison/combined_results/", 
                         clim_var, "_tree_", 1:5, "_collapsed.csv")
    sim_paths <- paste0("comparison/combined_results/sim_", 
                        clim_var, "_tree_", 1:5, "_collapsed.csv")
  } else {
    data_paths <- paste0("comparison/character_results/", 
                         clim_var, "_tree_", 1:5, 
                         "_character_", char, "_collapsed.csv")
    sim_paths <-  paste0("comparison/character_results/sim_", 
                         clim_var, "_tree_", 1:5, 
                         "_character_", char, "_collapsed.csv")
  }

  data_dfs <- list()
  for (p in 1:length(data_paths)) {
    data_dfs[[p]] <- read.csv(data_paths[p], row.names = 1)
  }
  # bind trees together 
  combined_data <- dplyr::bind_rows(data_dfs)

  # process colnames and remove variables with high missing data
  colnames(combined_data) <- gsub("X", "", colnames(combined_data))
  combined_data <- combined_data[ , colSums(is.na(combined_data)) < 2500]

  # melt data
  c_melted <- reshape2::melt(combined_data)
  
  # reorder factors 
  if (char != "combined") {
    c_melted$variable <- as.numeric(levels(c_melted$variable))[c_melted$variable]
    c_melted$variable <- as.factor(c_melted$variable)
  } else {
    c_melted$variable <- as.character(c_melted$variable)
    c_melted$variable <- as.factor(c_melted$variable)
  }
  
  # helper variables
  states <- levels(c_melted$variable)
  nstates <- length(states)
  
  # add simulated data
  if (null == TRUE) {
    sim_dfs <- list()
    for (p in 1:length(sim_paths)) {
      sim_dfs[[p]] <- read.csv(sim_paths[p], row.names = 1)
    }
    sims <- data.frame(value = unlist(unlist(sim_dfs)), variable = "simulated")
    sims$variable <- as.factor(sims$variable)
    c_melted <- rbind(sims, c_melted)
  }


  # make labels with padding for equal figure widths 
  if (char == "1") {
    labs <- c("0: none      ","1: bulb")
  } else if (char == "2") {
    labs <- c("0: none","1: rhizome ","2: corm","3: both")
  } else if (char == "3") {
    labs <- c("0: none","1: elongate","2: rotund")
  } else if (char == "combined") {
    labs <- paste0(states, "            ")
  }
  if (null == TRUE) {labs <- c("simulated   ", labs)}
  
  # set up plotting 
  leaf_pal <- c("#addd8e","#31a354")
  stem_pal <- c("#a1dab4","#41b6c4","#2c7fb8","#253494")
  root_pal <- c("#fed98e","#fe9929","#993404")

  if (char == "1") {
    col_vec <- leaf_pal
  } else if (char == "2") {
    col_vec <- stem_pal
  } else if (char == "3") {
    col_vec <- root_pal
  } else if (char == "combined") {
    col_vec <- c(RevGadgets:::.colFun(nstates))
  }
  
  names(col_vec) <- states

  if (null == TRUE) {
    col_vec <- c(simulated = "grey", col_vec)
  }

    if (clim_var == "bio4") {
    xlims <- c(5,9.5)
  } else if (clim_var == "bio15") {
      xlims <- c(2,5)
    }

    # plot 
  plot <- ggplot(data = c_melted, 
                 aes(value)) +
    geom_density(aes(color = variable, 
                     fill =  variable), 
                 alpha = 0.5, lwd = 1) + 
    scale_color_manual(values = col_vec,
                       name = "",
                       labels = labs) +
    scale_fill_manual(values = col_vec,
                      name = "",
                      labels = labs) +
    xlab("Optimal climate value") +
    xlim(xlims) +
    theme_few() +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank())
  
  return(plot)
}
