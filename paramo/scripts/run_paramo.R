# paramo analysis of one tree specified by i 

### read in morph data (in correct format)
morph_paramo <- read.csv("data/morphology/morph_paramo.csv")

### read in dependency matrix 
dep_mat <- as.matrix(read.csv("data/morphology/depend_mat_revised.csv", row.names = 1))

### read in trees
t <- ape::read.tree("data/phylogeny/combined_subsampled_dated.tre")[[i]]

#### start PARAMO
library(SCATE.shortcourse)
library(corHMM)

# set number of simulations
N = 100
#N = 1000

#combine tree and traits 
td <- make.treedata(t, morph_paramo)

# visualize dependency structure
G1 <- igraph::graph_from_adjacency_matrix(remove_indirect(t(as.matrix(dep_mat))))
con.comp <- igraph::components(G1, "weak") # Organizes the subgraphs within our graph and allows us to pick out connected pieces
plot(G1, vertex.size=1, edge.arrow.size=0.5, vertex.label.cex=0.75)

# amalgate based on dependencies
amal.deps <- amalgamate_deps(dep_mat)
# hack to add the top level character to each subset 
amal.deps$depstates[[1]] <- c(leaf_under = 1, amal.deps$depstates[[1]])
amal.deps$depstates[[2]] <- c(stem_under = 1, amal.deps$depstates[[2]])
amal.deps$depstates[[3]] <- c(root_tuber = 1, amal.deps$depstates[[3]])


# Recode the original dataset according to the character states of the new, 
# amalgamated characters (with Hidden states)
td.comb <- recode_traits(td, amal.deps) 

# fit 
# must use corHMM version 1.22
corhmm.fits <- amalgamated_fits_corHMM(td.comb, 
                                       amal.deps)
# save Q matrix for simulating later
Qmats<- vector("list", length = length(corhmm.fits))
names(Qmats) <- names(corhmm.fits)
Qmats[[1]] <- corhmm.fits[[1]]$solution
Qmats[[2]] <- corhmm.fits[[2]]$solution
Qmats[[3]] <- corhmm.fits[[3]]$solution

# Create stochastic character maps per character
sim_trees <- amalgamated_simmaps_phytools(corhmm.fits, nsim = N) # do 1000 for real version
# look into pi(e) behavior 

#### individual maps
IND.maps  <- prepareMapsRayDISC(td.comb, sim_trees, discretization_level = 1000)

#### entire phenotype maps
EP <- list(plant = c("leaf_under+bulb", 
                     "stem_under+corm+rhizome",
                     "root_tuber+disc_tub+cont_tub"))
EP.maps <- vector("list", length(EP))
names(EP.maps) <- names(EP)

for (i in 1:length(EP.maps)) {
  map<-paramo.list(EP[[i]], IND.maps, ntrees = N)
  EP.maps<-map
}


save(Qmats, file = paste0("paramo/output/Qmats_", i,".RData"))
save(IND.maps, file = paste0("paramo/output/IND_", i,".RData"))
save(EP.maps, file = paste0("paramo/output/EP_", i,".RData"))





# ### Amalgamate characters by 'body region' 
# BR <- list(shoot = c("leaf_under+bulb", "stem_under+corm+rhizome"),
#                   root = "root_tuber+disc_tub+cont_tub")
# 
# BR.maps <- vector("list", length(BR))
# names(BR.maps)<-names(BR)
# 
# for (i in 1:length(BR.maps)) {
#   map<-paramo.list(BR[[i]], IND.maps, ntrees = N)
#   BR.maps[[i]]<-map
# }


### plot summary of EP maps

states <- unique(unlist(lapply(EP.maps, 
                               function(i) unique(names(unlist(i$maps))))))

source("~/Documents/underground_evo/paramo/scripts/plot_simmap.R")
pdf("~/Desktop/paramo_map.pdf", height = 20, width = 15)
col_vec <- RevGadgets:::.colFun(10)
names(col_vec) <- states
plot_simmap(time_tree = EP.maps[[1]], 
            tree = EP.maps[[1]], 
            simmaps = EP.maps, 
            states = states,
            show.tip.label = FALSE,
            plot_pie = F
            #colors = col_vec
            )
dev.off()
#