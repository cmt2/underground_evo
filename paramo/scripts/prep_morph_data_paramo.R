### prepare morphology data in correct format 

# read in data in old format, but with edited root data
morph <- read.csv(file = "data/morphology/morphology_matrix_new.csv")

# remove NAs
morph <- morph[!is.na(morph$scheme_3_root),]

# set up new data structure 
cols <- c("genus","species","habit", 
          "leaf_under", "bulb", 
          "stem_under", "corm", "rhizome",
          "root_tuber", "disc_tub", "cont_tub")
morph_new <- as.data.frame(matrix(nrow = nrow(morph), 
                                  ncol = length(cols)))
colnames(morph_new) <- cols

# fill with species and habit info
morph_new[,1:3] <- morph[,1:3]

# fill columns with data
for (i in 1:nrow(morph_new)) {
  
  # stem under is true if any of the stem organs present 
  # conversely, stem not under is true if none present 
  if (morph$scheme_3_stem[i] == "none" | morph$scheme_3_stem[i] == "bulb") {
    morph_new$stem_under[i] <- 0
  } else {morph_new$stem_under[i] <- 1}
  
  # corm is true if corm 
  if (morph$scheme_3_stem[i] == "corm") {
    morph_new$corm[i] <- 1
  } else {morph_new$corm[i] <- 0}
  
  # rhizome is true if rhizome 
  if (morph$scheme_3_stem[i] == "rhizome") {
    morph_new$rhizome[i] <- 1
  } else {morph_new$rhizome[i] <- 0}
  
  # leaf under is true if bulb 
  # conversely stem not under true if bulb
  # bulb is true if bulb
  if (morph$scheme_3_stem[i] == "bulb") {
    morph_new$bulb[i] <- 1
    morph_new$leaf_under[i] <- 1
  } else {morph_new$bulb[i] <- 0; morph_new$leaf_under[i] <- 0}
  
  # root tuber true if not normal_rt
  if (morph$scheme_3_root[i] == "rt_tuber_cont" | morph$scheme_3_root[i] == "rt_tuber_disc") {
    morph_new$root_tuber[i] <- 1
  } else { morph_new$root_tuber[i] <- 0}
  
  # add continuous and discreet 
  if (morph$scheme_3_root[i] == "rt_tuber_cont") {
    morph_new$cont_tub[i] <- 1
  } else { morph_new$cont_tub[i] <- 0}
  
  if (morph$scheme_3_root[i] == "rt_tuber_disc") {
    morph_new$disc_tub[i] <- 1
  } else { morph_new$disc_tub[i] <- 0}
  
}

# change species names format 
morph_new$species <- gsub(" ", "_", x = morph_new$species)
# remove extra columns 
morph_new[,c("genus","habit")] <- NULL

write.csv(morph_new, file = "data/morphology/morph_paramo.csv", row.names = FALSE)
