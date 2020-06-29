# bayou analysis of selected climate data on one tree, specified by argument i 
library(bayou)

# read in tree 
#trees <- ape::read.tree("data/phylogeny/combined_subsampled_dated.tre")
t <- ape::read.tree("data/phylogeny/combined_subsampled_dated.tre")[[i]]
# read in climate data
# do this for bio4 (temperature seasonality) and bio15 (precipitation seasonality)

clim <- read.csv("data/climate_estimation/max_wc_all.csv", row.names = 1)
precip <- as.numeric(log(clim[,"bio15"]))
names(precip) <- row.names(clim)
precip[precip == -Inf] <- 0
temp <- as.numeric(log(clim[,"bio4"]))
names(temp) <- row.names(clim)

# do for 5 trees for diss
#for (i in 1:5) {
  
# pick and edit tree
#t <- trees[[i]]
t <- reorder(t, "postorder")
#change Rhipogonum to Ripogonum in tree 
t$tip.label <- gsub("Rhipogonum", "Ripogonum", t$tip.label)

#### precip
# set priors for precip
priorOU_precip <- make.prior(t, 
                             dists=list(dalpha="dhalfcauchy", dsig2="dhalfcauchy", 
                                        dk="cdpois", dtheta="dnorm"),
                             param=list(dalpha=list(scale=0.1), dsig2=list(scale=0.1),
                                        dk=list(lambda=10, kmax=50), dsb=list(bmax=1, prob=1), 
                                        dtheta=list(mean=mean(precip), sd=1.5*sd(precip))),
                             plot.prior = FALSE)
startpars_precip <- priorSim(priorOU_precip, t, plot=FALSE)$pars[[1]]
priorOU_precip(startpars_precip)
set.seed(1)

# Set up the MCMC
outname_precip <- paste0("modelOU_precip_r00", i)
mcmcOU_precip <- bayou.makeMCMC(t, 
                                precip, 
                                SE = 0.1, 
                                prior = priorOU_precip, 
                                new.dir = TRUE, 
                                outname = outname_precip, 
                                plot.freq = NULL)

#mcmcOU_precip$run(5000000)
mcmcOU_precip$run(5000)

chainOU_precip <- mcmcOU_precip$load()
chainOU_precip <- set.burnin(chainOU_precip, 0.3)
#summary(chainOU_precip)

# save output 
filename <- paste0("bayou/output/bayou_precip_", i, ".RData")
save(chainOU_precip, file = filename)

#### temp
# set priors for temp
priorOU_temp <- make.prior(t, 
                             dists=list(dalpha="dhalfcauchy", dsig2="dhalfcauchy", 
                                        dk="cdpois", dtheta="dnorm"),
                             param=list(dalpha=list(scale=0.1), dsig2=list(scale=0.1),
                                        dk=list(lambda=10, kmax=50), dsb=list(bmax=1, prob=1), 
                                        dtheta=list(mean=mean(temp), sd=1.5*sd(temp))),
                           plot.prior = FALSE)
startpars_temp <- priorSim(priorOU_temp, t, plot=FALSE)$pars[[1]]
priorOU_temp(startpars_temp)
set.seed(1)

# Set up the MCMC
outname_temp <- paste0("modelOU_temp_r00", i)
mcmcOU_temp <- bayou.makeMCMC(t, 
                                temp, 
                                SE = 0.1, 
                                prior = priorOU_temp, 
                                new.dir = TRUE, 
                                outname = outname_temp, 
                                plot.freq = NULL)

#mcmcOU_temp$run(5000000)
mcmcOU_temp$run(5000)

chainOU_temp <- mcmcOU_temp$load()
chainOU_temp <- set.burnin(chainOU_temp, 0.3)
#summary(chainOU_temp)

# save output 
filename <- paste0("bayou/output/bayou_temp_", i, ".RData")
save(chainOU_temp, file = filename)

#plot(chainOU, auto.layout=FALSE)
#
#par(mfrow=c(2,2))
#pdf("~/Desktop/bayoutest.pdf", height = 20, width = 15)
#plotSimmap.mcmc(chainOU, burnin = 0.3, pp.cutoff = 0.3, cex = .5)
#dev.off()
#plotBranchHeatMap(tree, chainOU, "theta", burnin = 0.3, pal = cm.colors)
#phenogram.density(tree, dat, burnin = 0.3, chainOU, pp.cutoff = 0.3)

