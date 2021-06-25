# trim OTUs and columns from final nexus alignments
library(ape)

setwd("/Users/carrietribble/Documents/liliales_paper_big_files/phylogeny/align_new/final_alignments/aligned/chosen_alignments/renamed/trimmed/contain_all_otus/nexus_files/final_nexus_files")

##### define functions #####

# function check if base pair is a gap
is_gap <- function(bp) {
  bp == "-"
}

# function to calculate percent missing base pairs in alignment 
perc_missing_matrix <- function(m) {
  gaps <- sum(apply(m, c(1,2), is_gap))
  total_bp <- length(m)
  perc_missing <- gaps/total_bp
  return(perc_missing)
}


# function to calculate percent missing for a column 
perc_missing_col <- function(col) {
  gaps <- sum(unlist(lapply(col, is_gap)))
  total_bp <- length(col)
  perc_missing <- gaps/total_bp
  return(perc_missing)
}

# function to remove matrix columns based on cut-offs
remove_cols <- function(m, c) {
  col_percs <- apply(m, 2, perc_missing_col)
  output <- m[, col_percs <= c] # if less than or equal to max % missing data
  return(output)
}

# define not in operator 
'%!in%' <- function(x,y)!('%in%'(x,y))

#####

##### lsit of files to loop over  ####

files <- c("atpB-rbcL.nexus", "atpB.nexus", "matK.nexus", 
           "nadhF.nexus", "rbcL.nexus", "rpl16.nexus", 
           "trnL_trnF.nexus", "unique_combined_its.nexus", 
           "unique_combined_psba_new_aligned.nexus", 
           "unique_combined_rps16.nexus")
#####

##### taxa to include ####
load("~/Documents/liliales_paper/final_data.rdata")
taxa <- gsub("Ripogonum", "Rhipogonum", final_data$tree$tip.label)  
#####

##### loop over all files and save new alignments ####

cut_off <- 0.95

for (i in 1:length(files)) {
  
  ali <- read.nexus.data(files[i])
  output <- matrix(unlist(ali), ncol = length(ali[[1]]), byrow = TRUE)
  rownames(output) <- names(ali)
  rm(ali)
  new_ali <- remove_cols(m = output[rownames(output) %in% taxa, ], c = cut_off) 
  write.nexus.data(new_ali, file = paste0("trimmed_by_col_OTU/", files[i]))
  
}

