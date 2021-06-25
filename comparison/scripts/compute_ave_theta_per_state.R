# bayou_map should be a single bayou simmap 
# paramo_map should be a single paramo EP simmap 
# the maps should be in a same order and be on the same tree 

### source scripts
source("comparison/scripts/reduce_to_unique_states.R")
library(bayou)

### load in data

compute_ave_theta_per_state <- function(bayou_map, paramo_map, combined = TRUE, char = NA) {

  # for some climate variables, tips with var = 0 were dropped prior to bayou analysis
  # drop the corresponding tips in the paramo tree for comparison 
  if (length(bayou_map$tree$tip.label) != length(paramo_map$tip.label)) {
    tip_to_drop <- paramo_map$tip.label[!paramo_map$tip.label %in% bayou_map$tree$tip.label]
    paramo_map <- phytools::drop.tip.simmap(paramo_map, tip = tip_to_drop)
    paramo_map <- phytools::reorderSimmap(paramo_map, order = "postorder")
  } else {
    paramo_map <- phytools::reorderSimmap(paramo_map, order = "postorder")
  }
  if(any((bayou_map$tree$edge == paramo_map$edge) == FALSE) == TRUE) {stop("edges don't match")}
  # total number of parameter states 
  param_states <- unique(names(unlist(paramo_map$maps)))
  num_param_states <- length(param_states)
  # set up vectors 
  cum_theta_per_state <- numeric(num_param_states)
  names(cum_theta_per_state) <- param_states
  cum_state_time <- numeric(num_param_states)
  names(cum_state_time) <- param_states
  for (branch in 1:length(paramo_map$edge.length)) {
    
    paramo_times <- sort(cumsum(reduce_to_unique_states(paramo_map$maps[[branch]])))
    bayou_times  <- sort(cumsum(bayou_map$tree$maps[[branch]]))
    
    # change last paramo time and bayou time to be branch length 
    paramo_times[length(paramo_times)] <- bayou_map$tree$edge.length[[branch]]
    bayou_times[length(bayou_times)] <- bayou_map$tree$edge.length[[branch]]

    # compute the combined change times
    combined_times <- sort(unique(c(paramo_times, bayou_times)))
    num_times      <- length(combined_times)
    
    # loop over the combined history
    previous_time <- 0
    for(i in 1:num_times) {
      # get the time
      this_time <- combined_times[i]
      # compute the duration
      this_duration <- this_time - previous_time
      # get the paramo state
      this_paramo_state <- names(paramo_times)[findInterval(this_time, 
                                                            paramo_times, 
                                                            left.open = T) + 1]
      # get the bayou state
      this_bayou_state <- names(bayou_times)[findInterval(this_time, 
                                                          bayou_times, 
                                                          left.open = T) + 1]
      # get the theta
      this_theta <- bayou_map$pars$theta[as.integer(this_bayou_state)]
      # accumulate theta in this state
      cum_theta_per_state[this_paramo_state] <- cum_theta_per_state[this_paramo_state] + this_theta * this_duration
      # accumulate time in this state
      cum_state_time[this_paramo_state] <- cum_state_time[this_paramo_state] + this_duration
      # increment the previous time
      previous_time <- this_time
    }
  }
  # collapse states (add cum_theta and add cum_state_time) before averaging for combined analyses
  if (combined == TRUE) {
    recodes <- data.frame(matrix(unlist(strsplit(names(cum_theta_per_state), split = "")), ncol = 3, byrow = TRUE))
    colnames(recodes) <- c("l","s","r")
    recodes$original <- names(cum_theta_per_state)
    recodes$theta <- cum_theta_per_state
    recodes$time <-  cum_state_time
    
    #recode first digit:
    # 2 -> 0 
    # 3 -> 1 
    recodes$l[which(recodes$l == "2")] <- "0"
    recodes$l[which(recodes$l == "3")] <- "1"
    #recode second digit:
    # 4 -> 0
    # 5 -> 1
    # 6 -> 2
    # 7 -> 3
    recodes$s[which(recodes$s == "4")] <- "0"
    recodes$s[which(recodes$s == "5")] <- "1"
    recodes$s[which(recodes$s == "6")] <- "2"
    recodes$s[which(recodes$s == "7")] <- "3"
    #recode third digit:
    # 4 -> 0
    # 5 -> 1
    # 6 -> 2
    # 7 -> 3
    recodes$r[which(recodes$r == "4")] <- "0"
    recodes$r[which(recodes$r == "5")] <- "1"
    recodes$r[which(recodes$r == "6")] <- "2"
    recodes$r[which(recodes$r == "7")] <- "3"
    
    # new state names:
    recodes$new <- paste0(recodes$l, recodes$s, recodes$r, collapste = "")
    
    # create new output vectors
    unique_new_states <- unique(recodes$new)
    new_theta <- vector("numeric", length = length(unique_new_states))
    new_time <- vector("numeric", length = length(unique_new_states))
    names(new_theta) <- names(new_time) <- unique_new_states
    
    # collapse states 
    for (code in unique_new_states) {
      thetas_for_code <- recodes$theta[which(recodes$new == code)]
      times_for_code <- recodes$time[which(recodes$new == code)]
      new_theta[code] <- sum(thetas_for_code)
      new_time[code] <- sum(times_for_code)
    }
    # compute the average theta
    average_theta_per_state <- new_theta/ new_time 
  } else {
    if (char == 1){
      # 2 -> 0 
      # 3 -> 1 

      thetas <- cum_theta_per_state
      names(thetas)[names(thetas) == "2"] <- "0" 
      names(thetas)[names(thetas) == "3"] <- "1" 
      
      times <- cum_state_time
      names(times)[names(times) == "2"] <- "0" 
      names(times)[names(times) == "3"] <- "1" 
      
      unique_new_states <- unique(names(thetas))
      new_theta <- vector("numeric", length = length(unique_new_states))
      names(new_theta) <- unique_new_states
      new_time <- vector("numeric", length = length(unique_new_states))
      names(new_time) <- unique_new_states
      
      for (code in unique_new_states) {
        thetas_for_code <- thetas[which(names(thetas) == code)]
        times_for_code <- times[which(names(times) == code)]
        new_theta[code] <- sum(thetas_for_code)
        new_time[code] <- sum(times_for_code)
      }
      
    } else {
      
      # 4 -> 0
      # 5 -> 1
      # 6 -> 2
      # 7 -> 3
      
      thetas <- cum_theta_per_state
      names(thetas)[names(thetas) == "4"] <- "0" 
      names(thetas)[names(thetas) == "5"] <- "1" 
      names(thetas)[names(thetas) == "6"] <- "2" 
      names(thetas)[names(thetas) == "7"] <- "3" 
      
      times <- cum_state_time
      names(times)[names(times) == "4"] <- "0"  
      names(times)[names(times) == "5"] <- "1"  
      names(times)[names(times) == "6"] <- "2"  
      names(times)[names(times) == "7"] <- "3"  
      
      unique_new_states <- unique(names(thetas))
      new_theta <- vector("numeric", length = length(unique_new_states))
      names(new_theta) <- unique_new_states
      new_time <- vector("numeric", length = length(unique_new_states))
      names(new_time) <- unique_new_states
      
      for (code in unique_new_states) {
        thetas_for_code <- thetas[which(names(thetas) == code)]
        times_for_code <- times[which(names(times) == code)]
        new_theta[code] <- sum(thetas_for_code)
        new_time[code] <- sum(times_for_code)
      } 
    }
    average_theta_per_state <- new_theta / new_time
    }
  return(average_theta_per_state)
}

