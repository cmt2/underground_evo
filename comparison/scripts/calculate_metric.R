# estimate comparison metric 
chars <- c("1", "2","3","combined")
clim_vars <- c("bio4","bio15")
trees <- as.character(1:5)

results_cols <- c("ch1_bio4_1","ch1_bio4_2","ch1_bio4_3","ch1_bio4_4","ch1_bio4_5",
                  "ch1_bio15_1","ch1_bio15_2","ch1_bio15_3","ch1_bio15_4","ch1_bio15_5",
                  
                  "ch2_bio4_1","ch2_bio4_2","ch2_bio4_3","ch2_bio4_4","ch2_bio4_5",
                  "ch2_bio15_1","ch2_bio15_2","ch2_bio15_3","ch2_bio15_4","ch2_bio15_5",
                  
                  "ch3_bio4_1","ch3_bio4_2","ch3_bio4_3","ch3_bio4_4","ch3_bio4_5",
                  "ch3_bio15_1","ch3_bio15_2","ch3_bio15_3","ch3_bio15_4","ch3_bio15_5",
                  
                  "combined_bio4_1","combined_bio4_2","combined_bio4_3","combined_bio4_4","combined_bio4_5",
                  "combined_bio15_1","combined_bio15_2","combined_bio15_3","combined_bio15_4","combined_bio15_5")

results <- data.frame(matrix(nrow = 1000, ncol = length(results_cols)))
colnames(results) <- results_cols

for (ch in chars) {
  for (cv in clim_vars) {
    for (t in trees) {
      # identify column to store results in
      if (ch != "combined") {
        this_col <- paste0("ch", ch, "_", cv, "_", t)
      } else {
          this_col <- paste(ch,cv,t, sep = "_")
          }
      col <- which(results_cols == this_col)
      
      # get paths to stored morph-averaged thetas
      if (ch != "combined") {
        emp_path <- paste0("comparison/character_results/", 
                           cv, "_tree_", t,"_character_", ch,
                           "_collapsed.csv") 
        sim_path <- paste0("comparison/character_results/sim_", 
                           cv, "_tree_", t,"_character_", ch,
                           "_collapsed.csv") 
      } else if (ch == "combined") {
        emp_path <- paste0("comparison/combined_results/", 
                           cv, "_tree_", t, "_collapsed.csv") 
        sim_path <- paste0("comparison/combined_results/sim_", 
                           cv, "_tree_", t, "_collapsed.csv") 
      }
      
      # read in data
      emp <- read.csv(emp_path, row.names = 1)
      sim <- read.csv(sim_path, row.names = 1)
    
      colnames(emp) <- gsub("X", "", colnames(emp))
      colnames(sim) <- gsub("X", "", colnames(sim))
      
      # calculate metric
      for (row in 1:nrow(emp)) {
        x <- unlist(emp[row,][sort(names(emp[row,]))])
        x <- x[!is.na(x)]
        y <- unlist(sim[row,][sort(names(sim[row,]))])
        y <- y[!is.na(y)]
        
        common_names <- intersect(names(x),names(y))
        if (length(common_names) == 0) {
          results[row,col] <- NA
        } else {
          x_sub <- x[common_names]
          y_sub <- y[common_names]
          results[row,col] <- norm(as.matrix(dist(x_sub, upper=TRUE, diag=TRUE)), type="F") - 
                              norm(as.matrix(dist(y_sub, upper=TRUE, diag=TRUE)), type="F")
        }
        
      }
    }
  }
}

write.csv(results, file = "comparison/metric_results.csv")

