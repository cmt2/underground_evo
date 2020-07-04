# calls run_paramo() for 5 trees, saves results
source("paramo/scripts/run_paramo.R")
for (tree in 2:5) {
  results <- run_paramo(i = tree, N = 1000)
  save(results, file = paste0("paramo/output/paramo_results", tree,".RData"))
  rm(results)
}

