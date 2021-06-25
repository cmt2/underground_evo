# Calculate alignment stats 
# Drop columns that are represented by n% or fewer taxa, and calculate what percent
# of the matrix has data 

library(ape)
library(car)
library(seqinr)

##### Cut down number of regions based on taxon coverage 

# read in each fasta file and record the number of OTUs it contains 
base_dir <- "/Users/carrietribble/Documents/liliales_paper_big_files/phylogeny/align_new/final_alignments/aligned/chosen_alignments/renamed/trimmed/"

fasta_files <- c("atpB-rbcL.fasta", "atpB.fasta", "cob.fasta", "matK.fasta", "matR.fasta", 
                 "nadhF.fasta", "pastajob.marker001.atpF_atpH.aln", 
                 "pastajob.marker001.rpl16.aln", "pastajob.marker001.trnL_trnF.aln", 
                 "pastajob.marker001.unique_combined_its.aln", 
                 "pastajob.marker001.unique_combined_psba_new_aligned.aln", "rbcL.fasta", 
                 "rpl32_rpl32-trnL.fasta", "trnY.fasta", "unique_combined_rps16.fasta")

fasta_otus <- data.frame(fasta_files = fasta_files, 
                         num_otus = NA, stringsAsFactors = F)

for (i in 1:length(fasta_files)) {
  
  ali <- read.fasta(file = paste0(base_dir, fasta_files[i]))
  
  fasta_otus$num_otus[i] <- length(ali)
}

# Drop fasta files w/ less than 150 OTUs 
fasta_otus$fasta_files[fasta_otus$num_otus < 150]

# see alignment workflow for this step - files are dropped before adding all OTUs
#####

###### only include taxa in super matrix with complete niche and morph data 

# import supermatrix

super <- read.nexus.data("/Users/carrietribble/Documents/liliales_paper_big_files/phylogeny/align_new/final_alignments/aligned/chosen_alignments/renamed/trimmed/contain_all_otus/nexus_files/final_nexus_files/supermatrix.nex")
output <- matrix(unlist(super), ncol = 17091, byrow = TRUE)
rownames(output) <- names(super)
rm(super)

# get list of taxa to include 
load("~/Documents/liliales_paper/final_data.rdata")
taxa <- gsub("Ripogonum", "Rhipogonum", final_data$tree$tip.label)  
matrix <- output[rownames(output) %in% taxa,]

#####

###### test effect of different allowed % missing data per column on
###### total % missing data in alignment 

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

# calculate percentages for various column cut-off stages

# df of allowed % missing data per column & resulting missing data in alignment
results <- data.frame(cut_offs = seq(from = 1, to = 0.5, by = -0.05),
                      perc_missing = NA,
                      num_bp = NA)

for (i in 1:nrow(results)) {
  print(i)
  new_matrix <- remove_cols(m = matrix,
                            c = results$cut_offs[i])
  results$perc_missing[i] <- perc_missing_matrix(new_matrix)
  results$num_bp[i] <- length(new_matrix[!new_matrix == "-"])
}

# plot % allowed missing data vs. total missing data 

plot(rev(results$cut_offs), rev(results$perc_missing), 
     xlim=rev(range(results$cut_offs)), pch = 20,
     xlab = "Percent of missing data allowed per column",
     ylab = "Missing data in the resulting matrix")

plot(rev(results$cut_offs), rev(results$num_bp), 
     xlim=rev(range(results$cut_offs)), pch = 20,
     xlab = "Percent of missing data allowed per column",
     ylab = "Total Data in Matrix")
