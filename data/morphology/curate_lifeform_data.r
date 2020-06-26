# morphology data curation for liliales underground morphology

library(tidyverse)

##### Scheme 1: geophyte true/ false ##### 

read_csv("liliales_checklists/liliales_traits_edited.csv") %>%
  select(species, habit)  %>%
  mutate(scheme_1 = grepl("geophyte", .$habit, fixed = T)) -> morphology_matrix 

morphology_matrix$genus <- matrix(unlist(strsplit(morphology_matrix$species, " ")), 
                                  nrow = nrow(morphology_matrix), byrow = T )[,1]


##### Scheme 2: geophyte or non-geophyte or hemicryptophyte ##### 

morphology_matrix %>%
  mutate(hemicrypt = grepl("hemicr", .$habit, fixed = T)) %>%
  mutate(scheme_2 = NA) -> morphology_matrix


for (i in 1:nrow(morphology_matrix)) {
  
  if (morphology_matrix[i, "scheme_1"] == T &
      morphology_matrix[i, "hemicrypt"] == F) { 
    
    morphology_matrix$scheme_2[i] <- "geo" } else if (
      
        morphology_matrix[i, "scheme_1"] == F & morphology_matrix[i, "hemicrypt"] == F ) {
      
        morphology_matrix$scheme_2[i] <- "non_geo" }
  
  if (morphology_matrix[i,"hemicrypt"] == T) {morphology_matrix$scheme_2[i] <- "hemicrypt" }
  
}  
  
morphology_matrix$hemicrypt <- NULL

##### Scheme 3: coding for organs ##### 

# two characters: stem_mod (multistate) and root_mod (binary)
# stem_mod states: rhizome, bulb, corm, none
# root_mod states: yes/no

# start by recoding the checklist data 

morphology_matrix$scheme_3 <- dplyr::recode(morphology_matrix$habit, "tuber geophyte" = "tuber", 
                                     "geophyte rhizome" = "rhizome",
                                     "rhizome nanophan" = "rhizome",
                                     "geophyte bulb hel." = "bulb", 
                                     "tuber geophyte hel." = "tuber", 
                                     "cl." = "NA", 
                                     "tuber geophyte cl." = "tuber", 
                                     "geophyte rhizome cl." = "rhizome", 
                                     "geophyte rhizome epiphyt" = "rhizome", 
                                     "cham" = "NA",
                                     "hemicr" = "NA", 
                                     "geophyte bulb" = "bulb", 
                                     "geophyte rhizome hemicr" = "rhizome", 
                                     "nanophan" = "NA",
                                     "cl. nanophan" = "NA",  
                                     "cl. hemicr" = "NA",              
                                     "hydrogeophyte tuber" = "tuber", 
                                     "cham nanophan" = "NA",
                                     "ther" = "NA", 
                                     "phan" = "NA",
                                     "hemicr lithophyt" = "NA", 
                                     "lithophyt" = "NA", 
                                     "hemicr cham" = "NA", 
                                     "hemicr holomycotroph" = "NA", 
                                     "geophyte rhizome holomycotroph" = "rhizome",
                                     "holomycotroph" = "NA", 
                                     "cl. cham" = "NA")

# Switch NA as characters to NAs non character 
morphology_matrix[which(morphology_matrix$scheme_3 == "NA"), "scheme_3"] <- NA

# breakdown tuber category more according to Kubtizki 

# All Alstroemeria except (Alstroemeria graminea; not geo) to have rhizomes and tuberous roots 
morphology_matrix[which(morphology_matrix$genus == "Alstroemeria" & 
                          morphology_matrix$species != "Alstroemeria graminea"),"scheme_3"] <- "rt_tuber_rhizome"
morphology_matrix[which(morphology_matrix$species == "Alstroemeria graminea"), "scheme_3"] <- NA

# Androcymbium has corms (with tunicate)
morphology_matrix[which(morphology_matrix$genus == "Androcymbium"), "scheme_3"] <- "corm"

# Baeometra has corms (with tunicate)
morphology_matrix[which(morphology_matrix$genus == "Baeometra"), "scheme_3"] <- "corm"

# Burchardia has root tubers 
morphology_matrix[which(morphology_matrix$genus == "Burchardia"), "scheme_3"] <- "rt_tuber"

# Camptorrhiza has tunicate corms 
morphology_matrix[which(morphology_matrix$genus == "Camptorrhiza"), "scheme_3"] <- "corm"

# Colchicum has tunicate corm 
morphology_matrix[which(morphology_matrix$genus == "Colchicum"), "scheme_3"] <- "corm"

# Gloriosa - corm (?)
morphology_matrix[which(morphology_matrix$genus == "Gloriosa"), "scheme_3"] <- "corm"

# Hexacyrtis has tunicate corms 
morphology_matrix[which(morphology_matrix$genus == "Hexacyrtis"), "scheme_3"] <- "corm"

# Iphigenia has tunicate corms 
morphology_matrix[which(morphology_matrix$genus == "Iphigenia"), "scheme_3"] <- "corm"

# Ornithoglossum has tunicate corms 
morphology_matrix[which(morphology_matrix$genus == "Ornithoglossum"), "scheme_3"] <- "corm"

# Wurmbea has tunicate forms 
morphology_matrix[which(morphology_matrix$genus == "Wurmbea"), "scheme_3"] <- "corm"

# Bomarea has tuberous roots and rhizomes
morphology_matrix[which(morphology_matrix$genus == "Bomarea"), "scheme_3"] <- "rt_tuber_rhizome"

# Disporum jinfoshanense is a recently described species with very few 
# collections and no available information. It is the only species 
# in the genus described as having tubers rather than rhizomes. This will 
# be set to NA unless otherwise verified 

morphology_matrix[which(morphology_matrix$species == "Disporum jinfoshanense"), "scheme_3"] <- NA

# Smilax & Ripogonum have rhizomes 
# Smilax (and Ripogonum) is a troublesome genus - but most descriptions say it has rhizomes rather than tubers

morphology_matrix[which(morphology_matrix$genus == "Smilax"), "scheme_3"] <- "rhizome"

morphology_matrix[which(morphology_matrix$genus == "Ripogonum"), "scheme_3"] <- "rhizome"

# Luzuriaga and Drymophila have rhizomes 

morphology_matrix[which(morphology_matrix$genus == "Luzuriaga"), "scheme_3"] <- "rhizome"

morphology_matrix[which(morphology_matrix$genus == "Drymophila"), "scheme_3"] <- "rhizome"

# Petermannia has rhizomes

morphology_matrix[which(morphology_matrix$genus == "Petermannia"), "scheme_3"] <- "rhizome"

# Chionographis has rhizomes 

morphology_matrix[which(morphology_matrix$genus == "Chionographis"), "scheme_3"] <- "rhizome"

# Amianthim muscitoxicum is a bulb 
# Travis, Joseph. "Breeding system, pollination, and pollinator limitation in a perennial herb,  
# Amianthium muscaetoxicum (Liliaceae)." American journal of botany (1984): 941-947.

morphology_matrix[which(morphology_matrix$species == "Amianthium muscitoxicum"), "scheme_3"] <- "bulb"

# Helonias has a rhizome 

morphology_matrix[which(morphology_matrix$genus == "Helonias"), "scheme_3"] <- "rhizome"

# Paris caobangensis has a rhizome
# Heng, JI Yun-Heng LI, and Z. H. O. U. Zhe-Kun. "Paris caobangensis YH Ji, H. Li & ZK Zhou (Trilliaceae), 
# a new species from northern Vietnam." 植物分类学报 44.6 (2006): 700-703.

morphology_matrix[which(morphology_matrix$species == "Paris caobangensis"), "scheme_3"] <- "rhizome"

# Veratrum maximum isn't a valid species.. can't find it anywhere! leave as NA
# Veratrum anticleoides can't locate any articles - leave as NA

# Xerophyllum has bulbs 

morphology_matrix[which(morphology_matrix$genus == "Xerophyllum"), "scheme_3"] <- "bulb"

# Clintonia has rhizomes

morphology_matrix[which(morphology_matrix$genus == "Clintonia"), "scheme_3"] <- "rhizome"

# Streptopus simplex has rhizomes http://eol.org/pages/1082278/overview

morphology_matrix[which(morphology_matrix$species == "Streptopus simplex"), "scheme_3"] <- "rhizome"

# Tricyrtis has "stoloniform" rhizome (not thickened)

morphology_matrix[which(morphology_matrix$genus == "Tricyrtis"), "scheme_3"] <- "rhizome"

# Campynema doesn't have USO, leave NA

# Campynemanthe has rhizomes 

morphology_matrix[which(morphology_matrix$genus == "Campynemanthe"), "scheme_3"] <- "rhizome"

# Arachnitis has tuberlike roots 

morphology_matrix[which(morphology_matrix$genus == "Arachnitis"), "scheme_3"] <- "rt_tuber"

# Corsiopsis is described in the following paper as having the same kind of und. morph as 
# Arachnitis. While it calls this organ a 'short rhizome,' the illustration makes it appear
# to be simply a small portion of underground stem. I will leave it as NA due to the confusion

# Zhang, Dianxiang, Richard MK Saunders, and Chi-Ming Hu. "Corsiopsis chinensis 
# gen. et sp. nov.(Corsiaceae): first record of the family in Asia." Systematic Botany (1999): 311-314.

# Both Philesia and Lapageria have rhizomes 

morphology_matrix[which(morphology_matrix$genus == "Philesia"), "scheme_3"] <- "rhizome"
morphology_matrix[which(morphology_matrix$genus == "Lapageria"), "scheme_3"] <- "rhizome"

# now split the character into two: scheme_3_stem and scheme_3_root

morphology_matrix %>%
  mutate(scheme_3_stem = dplyr::recode(scheme_3, "rt_tuber" = "none", "rt_tuber_rhizome" = "rhizome")) %>%
  mutate(scheme_3_root = dplyr::recode(scheme_3, "bulb" = F, "corm" = F, "rhizome" = F, 
                                          "rt_tuber" = T, "rt_tuber_rhizome" = T)) %>%
  select(genus, species, habit, scheme_1, scheme_2, scheme_3_root, scheme_3_stem) -> morphology_matrix

# recode some NAs as having no modification 

#Campynema has no USO, see above
morphology_matrix[which(morphology_matrix$genus == "Campynema"),
                  c("scheme_3_stem","scheme_3_root")] <- c("none",F)

#Alstroemeria graminea has no USO, see above
morphology_matrix[which(morphology_matrix$species == "Alstroemeria graminea"),
                  c("scheme_3_stem","scheme_3_root")] <- c("none",F)

##### Scheme 4: coding for organs #####

morphology_matrix$scheme_4_stem <- dplyr::recode(morphology_matrix$scheme_3_stem, 
                                          "bulb" = T,
                                          "corm" = T,
                                          "rhizome" = T,
                                          "none" = F)

morphology_matrix$scheme_4_root <- morphology_matrix$scheme_3_root

##### set NA characters #####

morphology_matrix[is.na(morphology_matrix$scheme_3_root),c(4,5)] <- NA

# save as a csv file 

write.csv(morphology_matrix, "morphology_datasets/morphology_matrix.csv")





