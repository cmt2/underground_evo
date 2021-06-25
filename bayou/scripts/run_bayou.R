# bayou function 
run_bayou <- function(i, clim_var, run_num, ngen) {
  ### ready data
  # read in climate data
  # do this for bio4 (temperature seasonality) and bio15 (precipitation seasonality)
  clim_all <- read.csv("data/climate_estimation/max_wc_all.csv", row.names = 1)
  clim <- as.numeric(log(clim_all[,clim_var]))
  names(clim) <- row.names(clim_all)
  # change climate data names from Ripogonum 
  # to Rhipogonum to match tree & morph data
  names(clim) <- gsub("Ripogonum", "Rhipogonum", names(clim))
  #drop species with -Inf values
  t <- ape::read.tree("data/phylogeny/combined_subsampled_dated.tre")[[i]]
  tips_to_drop <- names(clim)[which(clim == -Inf)]
  if (length(tips_to_drop) > 0) {
    t <- ape::drop.tip(phy = t, tip = tips_to_drop)
    clim <- clim[-which(clim == -Inf)] 
  }
  t <- ape::reorder.phylo(t, "postorder")

  ### set up prior
  priorOU <- make.prior(t, 
                        dists=list(dalpha="dhalfcauchy", 
                                   dsig2="dhalfcauchy", 
                                   dk="dgeom", 
                                   dtheta="dnorm"),
                        param=list(dalpha=list(scale=0.1), 
                                   dsig2=list(scale=0.1),
                                   dk=list(prob = 1/30), 
                                   dsb=list(bmax=1, prob=1), 
                                   dtheta=list(mean=mean(clim), 
                                               sd=1.5*sd(clim))),
                        plot.prior = FALSE)
  
  startpars <- priorSim(priorOU, t, plot=FALSE)$pars[[1]]
  priorOU(startpars)
  #set.seed(1)
  
  # Set up the MCMC
  outname <- paste0("modelOU_", clim_var,"_tree_", i, "_r00", run_num)
  mcmcOU <- bayou.makeMCMC(t, 
                           clim, 
                           SE = 0.1, 
                           prior = priorOU, 
                           new.dir = TRUE, 
                           outname = outname, 
                           samp = 100,
                           plot.freq = NULL)

  mcmcOU$run(ngen)
  chainOU <- mcmcOU$load()
  chainOU <- set.burnin(chainOU, 0.1)
  filename <- paste0("bayou/output/bayou_", 
                     clim_var,
                     "_tree_", 
                     i, 
                     "_r00", 
                     run_num, 
                     ".RData")
  save(chainOU, file = filename)
}