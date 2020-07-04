#function to run paramo for ith tree and N simulations 

run_paramo <- function(i, N) {
  print(paste0("working on tree ", i))
  library(SCATE.shortcourse)
  library(corHMM)
  ### read in morph data (in correct format)
  morph_paramo <- read.csv("data/morphology/morph_paramo.csv")
  morph_paramo$species <- gsub("Ripogonum", "Rhipogonum", morph_paramo$species)
  
  ### read in dependency matrix 
  dep_mat <- as.matrix(read.csv("data/morphology/depend_mat_revised.csv", row.names = 1))
  
  ### read in trees
  t <- ape::read.tree("data/phylogeny/combined_subsampled_dated.tre")[[i]]
  td <- make.treedata(t, morph_paramo)
  
  # amalgate based on dependencies
  amal.deps <- amalgamate_deps(dep_mat)
  # hack to add the top level character to each subset 
  amal.deps$depstates[[1]] <- c(leaf_under = 1, amal.deps$depstates[[1]])
  amal.deps$depstates[[2]] <- c(stem_under = 1, amal.deps$depstates[[2]])
  amal.deps$depstates[[3]] <- c(root_tuber = 1, amal.deps$depstates[[3]])
  
  # Recode the original dataset according to the character states of the new, 
  # amalgamated characters (with Hidden states)
  td.comb <- recode_traits(td, amal.deps) 
  
  corhmm.fits <- amalgamated_fits_corHMM(td.comb, 
                                         amal.deps)
  # save Q matrix for simulating later
  Qmats<- vector("list", length = length(corhmm.fits))
  names(Qmats) <- names(corhmm.fits)
  Qmats[[1]] <- corhmm.fits[[1]]$solution
  Qmats[[2]] <- corhmm.fits[[2]]$solution
  Qmats[[3]] <- corhmm.fits[[3]]$solution
  
  sim_trees <- amalgamated_simmaps_phytools(corhmm.fits, nsim = N) 
  IND.maps  <- prepareMapsRayDISC(td.comb, sim_trees, discretization_level = 1000)
  EP <- list(plant = c("leaf_under+bulb", 
                       "stem_under+corm+rhizome",
                       "root_tuber+disc_tub+cont_tub"))
  EP.maps <- vector("list", length(EP))
  names(EP.maps) <- names(EP)
  
  for (j in 1:length(EP.maps)) {
    map<-paramo.list(EP[[j]], IND.maps, ntrees = N)
    EP.maps<-map
  }
results <- list(Qmats = Qmats,
                IND.maps = IND.maps,
                EP.maps = EP.maps)
return(results)
}