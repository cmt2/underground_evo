# calls run_paramo() for 5 trees, saves results

#normal
source("paramo/scripts/run_paramo.R")
for (tree in 6:10) {
  results <- run_paramo(i = tree, N = 1000)
  save(results, file = paste0("paramo/output/paramo_results", tree,".RData"))
  rm(results)
}

#with data recoded to remove ambiguity at tips 
source("paramo/scripts/run_paramo_recode.R")
for (tree in 6:10) {
  results <- run_paramo_recode(i = tree, N = 1000)
  save(results, file = paste0("paramo/output/paramo_results_recode", tree,".RData"))
  rm(results)
}

