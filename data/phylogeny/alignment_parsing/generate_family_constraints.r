# create family constraints 

library(ape)
library(tidyverse)

##### read in list of all OTUS #####

ali <- read.nexus.data("~/Documents/liliales_paper_big_files/phylogeny/align_new/final_alignments/aligned/chosen_alignments/renamed/trimmed/contain_all_otus/nexus_files/final_nexus_files/trimmed_by_col_OTU/atpB-rbcL.nexus")
taxa <- names(ali)

##### create taxonomic info data frame #####
fam_gen <- read.csv("~/Documents/liliales_paper/liliales_fam_genus.csv")

genus <- character()
for (i in 1:length(taxa)) {
  genus[i] <- strsplit(taxa[i], split = "_")[[1]][1]
}

data.frame(tip = taxa, genus = genus) %>%
  left_join(fam_gen) %>%
  select(tip, family) -> tip_fam

##### Print list of taxa for each family #####

families <- c("Alstroemeriaceae","Campynemataceae","Colchicaceae",
              "Corsiaceae", "Liliaceae","Melanthiaceae", "Petermanniaceae",
              "Philesiaceae", "Ripogonaceae", "Smilacaceae")
for (i in 1:length(families)) {
  print(families[i])
  print(paste(tip_fam[which(tip_fam$family == families[i]),"tip"], sep = "", collapse="', '"))
}


