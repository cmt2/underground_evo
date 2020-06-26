#' Automatically recode amalgamated traits in PARAMO 
#' Amalgamates traits using the matrices returned by amalgamate_deps
#' 
#' @param td A treeplyr treedata object with characters to recode 
#' @param M A list produced by the function `amalgamate_deps`
#' 
#' @export
recode_traits <- function(td, M){

  # iterate through each new amalgamated trait and recode the matrix for that trait into td
  for(i in seq_along(M$new_traits)){
    trait_name <- M$new_traits[[i]]
    
    # if trait is not connected (ie has no dependencies)
    if(pracma::strcmp(M$traits[[i]], M$new_traits[[i]]) == TRUE){
      states <- setNames(c("0", "1"), 1:2)
      td <- recode_td(td, trait_name, states)
      td$dat[[trait_name]][td$dat[[trait_name]]=="?"] <- paste0(((1:length(states))-1), collapse="&")
    }
    else{ # if it has dependencies, recode the combined matrix for that subgraph into td
      # set gtraits 
      gtraits <- M$traits[[i]]
      # set states
      states <- colnames(M$M[[trait_name]])
      depstates <- M$depstates[[trait_name]]
      td <-recode_td(td, gtraits, states, depstates) 
      td$dat[[trait_name]][td$dat[[trait_name]]=="?"] <- paste0(((1:length(states))-1), collapse="&")
    }
  }
  
  return(td)
}