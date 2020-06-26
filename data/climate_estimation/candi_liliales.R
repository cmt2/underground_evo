###CANDI PIPELINE###
#Abigail Jackson-Gain and Carrie Tribble
#University of California, Berkeley

#~~pipeline for cleaning occurrence and environmental data 
#to then be used for species distribution modelling for large datasets
#with multiple species, generating a SDM for each species

#libraries used:
# note - if having trouble with rJava check out this page: http://www.snaq.net/software/rjava-macos.php
require("rJava") # Abby - any idea why we 'require' rJava rather than load it with library? 
library("rgdal")
library("spatial")
library("tidyverse")
library("dismo")
library("raster")
library("ENMeval")
library("stringr")
library("raster")
library("sp")
library("GGally")
library("ggplot2")
library("sf")
library("BIEN")
library("rgbif")
library("maptools")

#source CANDI functions
source("fxn_defs.R")

#load data 

#world map
big_map <- rgdal::readOGR("~/Documents/liliales_paper_big_files/maps/gadm28_adm0/gadm28_adm0.shp")

#species range data
read_csv("~/Documents/liliales_paper/liliales_checklists/liliales_traits_edited.csv") %>%
  dplyr::select(species, range) -> all_native_ranges

#botanical map 
kew_map_level_2 <- rgdal::readOGR("~/Documents/liliales_paper_big_files/maps/level2/level2.shp")

#species list 
my_species <- ape::read.tree("~/Documents/liliales_paper_big_files/phylogeny/mrbayes_subsample/combined_subsampled_dated.tre")[[1]]$tip.label
my_species <-  gsub("_", " ", my_species)

occ_data <- get_occ_records(species = my_species, database = "both") 

occ_data_orig <- occ_data

#data cleaning
occ_data <- remove_dup_locs(occ_data)
occ_data <- remove_ocean_points(occ_data, world_map = big_map)
occ_data <- remove_perf_0_90_180(occ_data)
occ_data2 <- remove_points_outside_nat_range(df = occ_data, 
                                           botan_map = kew_map_level_2, 
                                           nat_range = all_native_ranges)
occ_data2 <- remove_lessthan(occ_data2, n = 5)
occ_data2 <- remove_null_items(occ_data2)

save(occ_data2, file = "~/Desktop/occ_data_liliales.RData")

load("~/Documents/liliales_paper/climate_estimation/occ_data_liliales.RData")

final_occ_data <- occ_data2

## CLIMATE DATA PREP PATHWAY ##
###############################

#download 19 bioclim variables from WorldClim and process into a RasterStack
climate_stack <- get_world_clim() ##yes, this works

# based on the below cited paper, it is unnecessary to remove correlated variables for maxent modeling

# Feng, Xiao, et al. "Collinearity in ecological niche modeling: Confusions and challenges." 
# Ecology and Evolution 9.18 (2019): 10365-10376.

#makes pdf of correlation matrix saved to working directory to pick out correlated variables
#matrix <- make_corr_matrix(occurrences = occ_data2, environment_data = climate_stack) #yes, this works
#
## wow it's hard to remove these!!! 
#bad_vars <- c("bio1", "bio10", "bio11", "bio12", "bio16", "bio17", "bio18",
#                             "bio19", "bio2", "bio3", "bio6", "bio7", "bio8", "bi09")
#
#remove variables selected by user
# uncorr_stack <- remove_corr_variables(raster_stack = climate_stack, variables_to_be_removed = bad_vars) 
# final_stack <- uncorr_stack

final_stack <- climate_stack

## MAXENT MODELLING ##
######################

#the jar file evaluates 
#the performance of models built with different subsets of
#the environmental variables so each variable can be given a contribution score
#jar file doesn't come with maxent so it has to be dowloaded separately
jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')

results <- model_niches(occ_data = final_occ_data, clim_data = final_stack, output_dir = "~/Desktop/maxent_output/")
save(results, file = "~/Desktop/maxent_results.RData")


#### Calculate the 'optimal' climate values for each bioclim variable ####

max_wc <- as.data.frame(matrix(nrow = length(results[[2]]),
                               ncol = length(names(final_stack))))
colnames(max_wc) <- names(final_stack)
rownames(max_wc) <- names(results[[2]])

for (i in 1:nrow(max_wc)) {
  print(paste0("working on ", rownames(max_wc)[i], ", species number ", i))
  coords_of_max <- data.frame(long = rasterToPoints(results[[2]][[i]])[which.max( rasterToPoints(results[[2]][[i]])[,3]),c(1,2)][1],
                              lat = rasterToPoints(results[[2]][[i]])[which.max( rasterToPoints(results[[2]][[i]])[,3]),c(1,2)][2])
  max_wc[i,] <- raster::extract(x = final_stack, y = SpatialPoints(coords_of_max))
  
}

#write.csv(max_wc, file = "~/Desktop/max_wc.csv")
max_wc <- read.csv("~/Desktop/max_wc.csv", row.names = 1)

#### Compare average world clim values pre modeling to the optimum values from maxent ####

mean_premodeling <- as.data.frame(matrix(nrow = length(final_occ_data),
                                         ncol = length(names(final_stack))))
rownames(mean_premodeling) <- names(final_occ_data)
colnames(mean_premodeling) <- names(final_stack)

median_premodeling <- as.data.frame(matrix(nrow = length(final_occ_data),
                                         ncol = length(names(final_stack))))
rownames(median_premodeling) <- names(final_occ_data)
colnames(median_premodeling) <- names(final_stack)

for (i in 1:nrow(mean_premodeling)){
  print(paste0("working on ", rownames(mean_premodeling)[i], ", species number ", i))
  coords <- data.frame(long = final_occ_data[[i]]$longitude, 
                       lat = final_occ_data[[i]]$latitude)
  clim_values <- raster::extract(x = final_stack, y = SpatialPoints(coords))
  mean_premodeling[i, ] <- colMeans(clim_values)
  median_premodeling[i,] <- matrixStats::colMedians(clim_values)
}

#### Boxplots of differences ####

# mean occ vs maxent
combined <- cbind(max_wc, mean_premodeling)
colnames(combined) <- c(paste0(colnames(max_wc), "_max_wc"),
                        paste0(colnames(mean_premodeling), "_mean_premodeling"))
combined_matrix <- log(as.matrix(combined) + 422)
combined_mod <- as.data.frame(combined_matrix)


pdf("~/Desktop/maxent_vs_mean_hist.pdf", height = 10, width = 15)
boxplot(combined_mod[,order(colnames(combined_mod))],
        yaxt = "n", xaxt = "n", axes = T)
axis(1, las = 3, cex.axis=0.75, 
     at = seq(from = 1.5, to = 37.5, by = 2), 
     labels = colnames(max_wc))
rect(xleft = seq(from = 0.5, to = 37.5, by = 2),
     xright = seq(from = 2.5, to = 38.5, by = 2),
     ybottom = rep(4, times = 19),
     ytop = rep(10, times = 19), 
     col = c(rep(c(NA, "grey88"), times = 9), NA),
     lty = 0)
boxplot(combined_mod[,order(colnames(combined_mod))],
        col = rep(c("#EF8A62", "#67A9CF"), times = 19),
        pch = 19, yaxt = "n", xaxt = "n", add = TRUE)
dev.off()

# median occ vs maxent
combined <- cbind(max_wc, median_premodeling)
colnames(combined) <- c(paste0(colnames(max_wc), "_max_wc"),
                        paste0(colnames(median_premodeling), "_median_premodeling"))
combined_matrix <- log(as.matrix(combined) + 422)
combined_mod <- as.data.frame(combined_matrix)


pdf("~/Desktop/maxent_vs_median_hist.pdf", height = 10, width = 15)
boxplot(combined_mod[,order(colnames(combined_mod))],
        yaxt = "n", xaxt = "n", axes = T)
axis(1, las = 3, cex.axis=0.75, 
     at = seq(from = 1.5, to = 37.5, by = 2), 
     labels = colnames(max_wc))
rect(xleft = seq(from = 0.5, to = 37.5, by = 2),
     xright = seq(from = 2.5, to = 38.5, by = 2),
     ybottom = rep(4, times = 19),
     ytop = rep(10, times = 19), 
     col = c(rep(c(NA, "grey88"), times = 9), NA),
     lty = 0)
boxplot(combined_mod[,order(colnames(combined_mod))],
        col = rep(c("#EF8A62", "#67A9CF"), times = 19),
        pch = 19, yaxt = "n", xaxt = "n", add = TRUE)
dev.off()

#### scatterplots of differences ####

# mean occ vs maxent

vars <- colnames(max_wc)
vars <- vars[c(1,12:19,2:11)]
sample_size <- unlist(lapply(final_occ_data, nrow))
rbPal <- colorRampPalette(c('red','blue'))
color <- rbPal(10)[as.numeric(cut(log(sample_size), breaks = 10))]

pdf("~/Desktop/maxent_vs_mean_scatterplots_col.pdf")
par(mfrow = c(2,2))
for (i in 1:length(vars)) {
  min <- min(c(max_wc[,vars[i]],
               mean_premodeling[,vars[i]]), na.rm = T)
  max <- max(c(max_wc[,vars[i]],
               mean_premodeling[,vars[i]]), na.rm = T)
  diff <- max - min
  if (diff < 200) ticby <- 10
  if (diff > 200 & diff < 1000) ticby <- 50
  if (diff > 1000 & diff < 5000) ticby <- 200
  if (diff > 5000) ticby <- 500
  plot(max_wc[,vars[i]], mean_premodeling[,vars[i]], 
       ylim=c(min,max), xlim = c(min, max), pch = 19,
       xlab = "MaxEnt estimated optimum", ylab = "Mean from occurrence points",
       col = alpha(color, 0.6), axes = F, main = vars[i])
  axis(side = 1, at = seq(from = round(min, digits = -1) , 
                          to = round(max, digits = -1), by = ticby))
  axis(side = 2, at = seq(from = round(min, digits = -1) , 
                          to = round(max, digits = -1), by = ticby))
  abline(a = 0, b = 1, col = "black", lty = 2, lwd = 2)
}
dev.off()

# median occ vs maxent

vars <- colnames(max_wc)
vars <- vars[c(1,12:19,2:11)]

pdf("~/Desktop/maxent_vs_median_scatterplots.pdf")
par(mfrow = c(2,2))
for (i in 1:length(vars)) {
  min <- min(c(max_wc[,vars[i]],
               median_premodeling[,vars[i]]), na.rm = T)
  max <- max(c(max_wc[,vars[i]],
               median_premodeling[,vars[i]]), na.rm = T)
  diff <- max - min
  if (diff < 200) ticby <- 10
  if (diff > 200 & diff < 1000) ticby <- 50
  if (diff > 1000 & diff < 5000) ticby <- 200
  if (diff > 5000) ticby <- 500
  plot(max_wc[,vars[i]], median_premodeling[,vars[i]], 
       ylim=c(min,max), xlim = c(min, max), pch = 19,
       xlab = "MaxEnt estimated optimum", ylab = "median from occurrence points",
       col = alpha("black", 0.6), axes = F, main = vars[i])
  axis(side = 1, at = seq(from = round(min, digits = -1) , 
                          to = round(max, digits = -1), by = ticby))
  axis(side = 2, at = seq(from = round(min, digits = -1) , 
                          to = round(max, digits = -1), by = ticby))
  abline(a = 0, b = 1, col = "red", lty = 2, lwd = 2)
}
dev.off()

