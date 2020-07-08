### Read in the early-terminated bayou runs and save Rdata objects for each 

library(bayou)
setwd("/Users/carrietribble/Documents/underground_evo/bayou/output")

# read in the tree data and the climate data 
clim_all <- read.csv("~/Documents/underground_evo/data/climate_estimation/max_wc_all.csv", row.names = 1)
t_all <- ape::read.tree("~/Documents/underground_evo/data/phylogeny/combined_subsampled_dated.tre")

# for all the output directories, move the output data 
# into a new directory so that you can fill the directory 
# with fake empty files 

bayou_output_dirs <- 
  c("bio15_tree_1_r001", "bio15_tree_1_r002", "bio15_tree_1_r003", "bio15_tree_1_r003_2",
    "bio15_tree_2_r001", "bio15_tree_2_r002", "bio15_tree_2_r003", "bio15_tree_2_r003_2",
    "bio15_tree_3_r001", "bio15_tree_3_r002", "bio15_tree_3_r003", "bio15_tree_3_r003_2",
    "bio15_tree_4_r001", "bio15_tree_4_r002", "bio15_tree_4_r003", "bio15_tree_4_r003_2",
    "bio15_tree_5_r001", "bio15_tree_5_r002", "bio15_tree_5_r003", "bio15_tree_5_r003_2",
    "bio4_tree_1_r001", "bio4_tree_1_r002", "bio4_tree_1_r003", "bio4_tree_1_r003_2",
    "bio4_tree_2_r001", "bio4_tree_2_r002", "bio4_tree_2_r003", "bio4_tree_2_r003_2",
    "bio4_tree_3_r001", "bio4_tree_3_r002", "bio4_tree_3_r003", "bio4_tree_3_r003_2",
    "bio4_tree_4_r001", "bio4_tree_4_r002", "bio4_tree_4_r003", "bio4_tree_4_r003_2",
    "bio4_tree_5_r001", "bio4_tree_5_r002", "bio4_tree_5_r003", "bio4_tree_5_r003_2")

for (dir in bayou_output_dirs) {
  print(paste0("Working on directory: ", dir))
  #create a directory to move the 'good' output files into
  dir.create(paste0(dir, "/good"))
  
  #move files into new directory
  if (length(unlist(strsplit(dir, "_"))) == 4) {
    file.rename(from = paste0(dir,"/", "modelOU_", dir, ".loc"), 
                to = paste0(dir, "/good/", "modelOU_", dir, ".loc"))
    file.rename(from = paste0(dir,"/", "modelOU_", dir, ".pars"), 
                to = paste0(dir, "/good/", "modelOU_", dir, ".pars"))
    file.rename(from = paste0(dir,"/", "modelOU_", dir, ".rjpars"), 
                to = paste0(dir, "/good/", "modelOU_", dir, ".rjpars"))
    file.rename(from = paste0(dir,"/", "modelOU_", dir, ".sb"), 
                to = paste0(dir, "/good/", "modelOU_", dir, ".sb"))
    file.rename(from = paste0(dir,"/", "modelOU_", dir, ".t2"), 
                to = paste0(dir, "/good/", "modelOU_", dir, ".t2"))
  } else if (length(unlist(strsplit(dir, "_"))) == 5) {
    filename_dir <- gsub("r003_2","r003", dir)
    file.rename(from = paste0(dir,"/", "modelOU_", filename_dir, ".loc"), 
                to = paste0(dir, "/good/", "modelOU_", filename_dir, ".loc"))
    file.rename(from = paste0(dir,"/", "modelOU_", filename_dir, ".pars"), 
                to = paste0(dir, "/good/", "modelOU_", filename_dir, ".pars"))
    file.rename(from = paste0(dir,"/", "modelOU_", filename_dir, ".rjpars"), 
                to = paste0(dir, "/good/", "modelOU_", filename_dir, ".rjpars"))
    file.rename(from = paste0(dir,"/", "modelOU_", filename_dir, ".sb"), 
                to = paste0(dir, "/good/", "modelOU_", filename_dir, ".sb"))
    file.rename(from = paste0(dir,"/", "modelOU_", filename_dir, ".t2"), 
                to = paste0(dir, "/good/", "modelOU_", filename_dir, ".t2"))
  }
  
  # get run info from dir 
  string <- unlist(strsplit(dir, split = "_"))
  if (length(string) == 4) {
    clim_var <- string[1]
    i <- as.integer(string[3])
    run_num <- as.integer(unlist(strsplit(string[4], ""))[4])
  } else if (length(string) == 5) {
    clim_var <- string[1]
    i <- as.integer(string[3])
    run_num <- 4
  }
  
  if (length(string) == 4) {
    outname <- paste0("modelOU_", dir)
  } else if (length(string) == 5) {
    outname <- paste0("modelOU_", gsub("r003_2", "r003", dir))
  }
  
  # read in appropriate data
  clim <- as.numeric(log(clim_all[,clim_var]))
  names(clim) <- row.names(clim_all)
  # change climate data names from Ripogonum 
  # to Rhipogonum to match tree & morph data
  names(clim) <- gsub("Ripogonum", "Rhipogonum", names(clim))
  t <- t_all[[i]]
  tips_to_drop <- names(clim)[which(clim == -Inf)]
  if (length(tips_to_drop) > 0) {
    t <- ape::drop.tip(phy = t, tip = tips_to_drop)
    clim <- clim[-which(clim == -Inf)] 
  }
  t <- ape::reorder.phylo(t, "postorder")
  
  # run corresponding bayou command to set up empty files 
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
  set.seed(1)
  
  # this will create the files in the directory 
  mcmcOU <- bayou.makeMCMC(t, 
                           clim, 
                           SE = 0.1, 
                           prior = priorOU, 
                           new.dir = dir, 
                           outname = outname, 
                           samp = 100,
                           plot.freq = NULL)
  
 
  # delete the files just created 
  if (length(unlist(strsplit(dir, "_"))) == 4) {
      file.remove(paste0(dir,"/", "modelOU_", dir, ".loc"))
      file.remove(paste0(dir,"/", "modelOU_", dir, ".pars"))  
      file.remove(paste0(dir,"/", "modelOU_", dir, ".rjpars"))
      file.remove(paste0(dir,"/", "modelOU_", dir, ".sb"))
      file.remove(paste0(dir,"/", "modelOU_", dir, ".t2"))
  } else if (length(unlist(strsplit(dir, "_"))) == 5) {
    filename_dir <- gsub("r003_2","r003", dir)
    file.remove(paste0(dir,"/", "modelOU_", filename_dir, ".loc"))
    file.remove(paste0(dir,"/", "modelOU_", filename_dir, ".pars"))  
    file.remove(paste0(dir,"/", "modelOU_", filename_dir, ".rjpars"))
    file.remove(paste0(dir,"/", "modelOU_", filename_dir, ".sb"))
    file.remove(paste0(dir,"/", "modelOU_", filename_dir, ".t2"))
  }
  
  # now move the original files back into the directory 
  if (length(unlist(strsplit(dir, "_"))) == 4) {
    file.rename(to = paste0(dir,"/", "modelOU_", dir, ".loc"), 
                from = paste0(dir, "/good/", "modelOU_", dir, ".loc"))
    file.rename(to = paste0(dir,"/", "modelOU_", dir, ".pars"), 
                from = paste0(dir, "/good/", "modelOU_", dir, ".pars"))
    file.rename(to = paste0(dir,"/", "modelOU_", dir, ".rjpars"), 
                from = paste0(dir, "/good/", "modelOU_", dir, ".rjpars"))
    file.rename(to = paste0(dir,"/", "modelOU_", dir, ".sb"), 
                from = paste0(dir, "/good/", "modelOU_", dir, ".sb"))
    file.rename(to = paste0(dir,"/", "modelOU_", dir, ".t2"), 
                from = paste0(dir, "/good/", "modelOU_", dir, ".t2"))
  } else if (length(unlist(strsplit(dir, "_"))) == 5) {
    filename_dir <- gsub("r003_2","r003", dir)
    file.rename(to = paste0(dir,"/", "modelOU_", filename_dir, ".loc"), 
                from = paste0(dir, "/good/", "modelOU_", filename_dir, ".loc"))
    file.rename(to = paste0(dir,"/", "modelOU_", filename_dir, ".pars"), 
                from = paste0(dir, "/good/", "modelOU_", filename_dir, ".pars"))
    file.rename(to = paste0(dir,"/", "modelOU_", filename_dir, ".rjpars"), 
                from = paste0(dir, "/good/", "modelOU_", filename_dir, ".rjpars"))
    file.rename(to = paste0(dir,"/", "modelOU_", filename_dir, ".sb"), 
                from = paste0(dir, "/good/", "modelOU_", filename_dir, ".sb"))
    file.rename(to = paste0(dir,"/", "modelOU_", filename_dir, ".t2"), 
                from = paste0(dir, "/good/", "modelOU_", filename_dir, ".t2"))
  }
  
  # delete the empty 'good' directory
  unlink(paste0(dir,"/good"), recursive = TRUE)
  
  # load the data back into R
  chainOU <- mcmcOU$load()
  # save as an R object
  filename <- paste0("processed_output/", 
                     clim_var,
                     "_tree_", 
                     i, 
                     "_r00", 
                     run_num, 
                     ".RData")
  print(paste0("Saving as: ", filename))
  save(chainOU, file = filename)
  
  #remove files and try again
  rm(mcmcOU)
  rm(startpars)
  rm(priorOU)
  rm(chainOU)
}
