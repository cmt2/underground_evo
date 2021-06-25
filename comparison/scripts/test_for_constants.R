# test for constant states in characters for simulated paramo data 

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
  } else {
    print(paste("poop in first character, sims:", poops))
    print(table(s1[[poops]]$states))
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
  } else {
    print(paste("poop in second character, sims:", poops))
    print(table(s2[[poops]]$states))
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
  } else {
    print(paste("poop in third character, sims:", poops))
    print(table(s3[[poops]]$states))
  }

  rm(s1,s2,s3,nchars,poops,s)

  