# test for constant states in characters for simulated paramo data 

for (tree in 8:10) {
  print(paste0("working on tree ", tree))
  load(paste0("paramo/simulations/sim_tree_",tree,".RData"))
  s1 <- results[[2]][[1]]
  s2 <- results[[2]][[2]]
  s3 <- results[[2]][[3]]
  sim <- results[[3]]
  rm(results)
  
  #### first character 
  nchars <- vector("numeric", length = length(s1))
  for (s in 1:length(s1)){
    nchars[s] <- length(unique(names(unlist(s1[[s]]$maps))))
  }
  poops <- which(nchars == 0)
  if (length(poops) > 1){
    for (p in poops) {
      print(paste("poop in first character, sims:", poops))
      print(table(s1[[p]]$states))
    } 
  } else if (length(poops) == 1) {
    print(paste("poop in first character, sims:", poops))
    print(table(s1[[poops]]$states))
  } else {
    print("no poops")
  }
  
  ####  second character 
  nchars <- vector("numeric", length = length(s2))
  for (s in 1:length(s2)){
    nchars[s] <- length(unique(names(unlist(s2[[s]]$maps))))
  }
  poops <- which(nchars == 0)
  if (length(poops) > 1){
    for (p in poops) {
      print(paste("poop in second character, sims:", poops))
      print(table(s2[[p]]$states))
    } 
  } else if (length(poops) == 1){
    print(paste("poop in second character, sims:", poops))
    print(table(s2[[poops]]$states))
  } else {
    print("no poops")
  }
  
  
  #### third character 
  
  nchars <- vector("numeric", length = length(s3))
  for (s in 1:length(s3)){
    nchars[s] <- length(unique(names(unlist(s3[[s]]$maps))))
  }
  poops <- which(nchars == 0)
  if (length(poops) > 1){
    for (p in poops) {
      print(paste("poop in third character, sims:", poops))
      print(table(s3[[p]]$states))
    } 
  } else if (length(poops) == 1) {
    print(paste("poop in third character, sims:", poops))
    print(table(s3[[poops]]$states))
  } else {
    print("no poops")
  }
  
  rm(s1,s2,s3,nchars,poops,s)
}

