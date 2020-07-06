source("comparison/scripts/compare_samples.R")

# bayou data
load("~/Documents/underground_evo/bayou/output/bayou_temp_1.RData")
b_b04_t1 <- subset_chainOU(chainOU = chainOU_temp, 1000)
rm(chainOU_temp)
load("~/Documents/underground_evo/paramo/output/paramo_results1.RData")
p_b04_t1 <- results$EP.maps
rm(results)

b04_t1 <- compare_samples(bayou = b_b04_t1, paramo = p_b04_t1)

# make data frame 
columns <- vector()
for (row in 1:length(b04_t1)){
  columns <- append(columns, names(b04_t1[[row]]))
}
columns <- unique(columns)

df <- data.frame(matrix(nrow = length(b04_t1), ncol = length(columns)))
colnames(df) <- columns

#fill with data
for (row in 1:length(b04_t1)) {
  for (col in columns){
    if (col %in% names(b04_t1[[row]])) {
      df[row,col] <- b04_t1[[row]][col] 
    } else {df[row,col] <- NA }
  }
}
  
  