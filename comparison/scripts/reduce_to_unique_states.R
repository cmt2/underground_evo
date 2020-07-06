reduce_to_unique_states <- function(vec) {
  diffs <- diff_than_prev(names(vec))
  index <- which(diffs == TRUE)
  split <- splitAt(vec, index)
  new <- unlist(lapply(split, sum))
  names(new) <- names(vec)[index]
  return(new)
}

diff_than_prev <- function(x) {
  if (length(x) > 1){
    r <- vector("logical", length = length(x))
    r[1] <- TRUE
    for(i in 2:length(x)){
      if (i > 0){
        r[i] <- x[i] != x[i - 1]
      }
    }
  } else {
    r <- TRUE
  }
  return(r)
}

splitAt <- function(x, pos) unname(split(x, cumsum(seq_along(x) %in% pos)))
