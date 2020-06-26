#' recodes a treedata object based on amalgamated characters
#' @export
recode_td <- function(td, traits, states, depstates=numeric(0)){
  recover()
  tmp <- select(td, traits)
  hidden0 <- names(depstates)
  obs_char <- which(!(1:length(traits) %in% hidden0))
  for(i in 1:ncol(tmp$dat)){
    parent <- tmp$dat[[depstates[traits[i]]]]
    if(is.null(parent)){
      missingObs <- "*"
      tmp$dat[[i]] <- recode(as.character(tmp$dat[[i]]), "1"="1", "0"="0", "1 and 0"=missingObs, "0 and 1"=missingObs, .missing=missingObs)
    } else {
      tmp2 <- as.character(tmp$dat[[i]])
      tmp2[parent=="0"] <- "*"
      tmp$dat[[i]] <- recode(tmp2, "1"="1", "0"="0", "1 and 0"="*", "0 and 1"="*", .missing="*")
    }
    #recode0 <- ifelse(i %in% hidden0, "*", "0")
    
    #tmp$dat[[i]] <- recode(as.character(tmp$dat[[i]]), "1"="1", "0"=recode0, "1 and 0"=missingObs, "0 and 1"=missingObs, .missing=missingObs)
  }
  new.char <- tidyr::unite(tmp$dat, "new", sep="")
  new.char <- unname(sapply(new.char[[1]], function(x) paste(which(grepl(glob2rx(x), states))-1, collapse="&")))
  new.char[which(new.char=="")] <- "?"
  
  new.td <- select(td, -one_of(traits))
  new.td$dat[[paste(traits, collapse="+")]] <- new.char
  return(new.td)
}
