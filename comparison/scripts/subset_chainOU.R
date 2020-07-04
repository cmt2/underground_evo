
# function to produce simmaps for samples from bayou posterior
subset_chainOU <- function(chainOU, nsamples){
  r <- sample(1:length(chainOU$gen), size = nsamples, replace = FALSE)
  results <- vector("list", length = length(r))
  t <- attributes(chainOU)$tree
  for (i in 1:length(r)) {
    sample <- list(gen = chainOU$gen[[r[i]]],
                   lnL = chainOU$lnL[[r[i]]],
                   prior = chainOU$prior[[r[i]]],
                   alpha = chainOU$alpha[[r[i]]],
                   sig2 = chainOU$sig2[[r[i]]],
                   k = chainOU$k[[r[i]]],
                   ntheta = chainOU$ntheta[[r[i]]],
                   sb = chainOU$sb[[r[i]]],
                   loc = chainOU$loc[[r[i]]],
                   t2 = chainOU$t2[[r[i]]],
                   theta = chainOU$theta[[r[i]]])
   sm <- pars2simmap(pars = sample, tree = t)
   results[[i]] <- sm
  }
  return(results)
}


#test <- subset_chainOU(chainOU = chainOU_temp, nsamples = 100)

