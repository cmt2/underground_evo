### R(h)ipogonum was dropped because of naming, redo candi for those taxa

#candi requirements
require("rJava") # Abby - any idea why we 'require' rJava rather than load it with library? 
library("rgdal")
library("spatial")
library("tidyverse")
library("dismo")
library("raster")
library("ENMeval")
library("stringr")
library("sp")
library("GGally")
library("ggplot2")
library("sf")
library("BIEN")
library("rgbif")
library("maptools")

# taxon names
taxa <- my_species[grep("Rhipogonum", my_species)]
taxa <- gsub("Rhipogonum", "Ripogonum", taxa)

# source CANDI scripts
source("~/Documents/Berkeley_IB/research_projects/candi_pipeline/fxn_defs.R")

#world map
big_map <- rgdal::readOGR("~/Documents/liliales_paper_big_files/maps/gadm28_adm0/gadm28_adm0.shp")

#species range data
read_csv("~/Documents/underground_evo/data/morphology/liliales_checklists/liliales_traits_edited.csv") %>%
  dplyr::select(species, range) -> all_native_ranges

#botanical map 
kew_map_level_2 <- rgdal::readOGR("~/Documents/liliales_paper_big_files/maps/level2/level2.shp")

# get occurence data
occ_data_orig <- get_occ_records(species = taxa, database = "both") 
occ_data <- occ_data_orig

#data cleaning
occ_data <- remove_dup_locs(occ_data)
occ_data <- remove_ocean_points(occ_data, world_map = big_map)
occ_data <- remove_perf_0_90_180(occ_data)
#occ_data <- remove_points_outside_nat_range(df = occ_data, 
#                                             botan_map = kew_map_level_2, 
#                                             nat_range = all_native_ranges)
#occ_data <- remove_lessthan(occ_data, n = 5)
occ_data <- remove_null_items(occ_data)
final_occ_data <- occ_data
# model niches 
climate_stack <- get_world_clim()
final_stack <- climate_stack
jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
results <- model_niches(occ_data = final_occ_data, clim_data = final_stack, output_dir = "data/climate_estimation/ripogonum_output/")
save(results, file = "data/climate_estimation/ripogonum_results.RData")

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

write.csv(max_wc, file = "data/climate_estimation/max_wc_ripogonum.csv")

# combine with rest of data
max_wc_ripogonum <- max_wc
max_wc_rest <- read.csv("data/climate_estimation/max_wc.csv", row.names = 1)
max_wc_all <- rbind(max_wc_rest, max_wc_ripogonum)

# save combined data
write.csv(max_wc_all, "data/climate_estimation/max_wc_all.csv")

