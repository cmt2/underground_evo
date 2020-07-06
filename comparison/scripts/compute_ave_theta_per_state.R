# bayou_map should be a single bayou simmap 
# paramo_map should be a single paramo EP simmap 
# the maps should be in a same order and be on the same tree 

### source scripts
source("comparison/scripts/subset_chainOU.R")
source("comparison/scripts/reduce_to_unique_states.R")
library(bayou)

### load in data

compute_ave_theta_per_state <- function(bayou_map, paramo_map) {
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
    paramo_times <- round(cumsum(reduce_to_unique_states(paramo_map$maps[[branch]])), digits = 10)
    bayou_times  <- round(cumsum(bayou_map$tree$maps[[branch]]), digits = 10)
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
    # compute the average theta
    average_theta_per_state <- cum_theta_per_state / cum_state_time
  }
  return(average_theta_per_state)
}

# bayou
#load("bayou/output/bayou_temp_1.RData")
#bayou <- subset_chainOU(chainOU = chainOU_temp, nsamples = 100)
#bayou_map <- bayou[[1]]
#rm(chainOU_temp, bayou)
# paramo
#load("paramo/output/EP_test.RData")
#paramo_map <- phytools::reorderSimmap(EP.maps[[10]], "postorder")
#load("paramo/output/Qmats_test.RData")
#paramo_models <- Qmats
#rm(EP.maps, Qmats)

# total number of parameter states 
#num_param_states <- dim(paramo_models[[1]])[1] * dim(paramo_models[[2]])[1] * dim(paramo_models[[3]])[1]
#param_states <- unique(names(unlist(paramo_map$maps)))
#num_param_states <- length(param_states)
## set up vectors 
#cum_theta_per_state <- numeric(num_param_states)
#names(cum_theta_per_state) <- param_states
#cum_state_time <- numeric(num_param_states)
#names(cum_state_time) <- param_states
#
## compute the change times for each history
#
#for (branch in 1:length(paramo_map$edge.length)) {
#  paramo_times <- round(cumsum(reduce_to_unique_states(paramo_map$maps[[branch]])), digits = 10)
#  bayou_times  <- round(cumsum(bayou_map$tree$maps[[branch]]), digits = 10)
#  # compute the combined change times
#  combined_times <- sort(unique(c(paramo_times, bayou_times)))
#  num_times      <- length(combined_times)
#  # loop over the combined history
#  previous_time <- 0
#  for(i in 1:num_times) {
#    # get the time
#    this_time <- combined_times[i]
#    # compute the duration
#    this_duration <- this_time - previous_time
#    # get the paramo state
#    this_paramo_state <- names(paramo_times)[findInterval(this_time, 
#                                                          paramo_times, 
#                                                          left.open = T) + 1]
#    # get the bayou state
#    this_bayou_state <- names(bayou_times)[findInterval(this_time, 
#                                                        bayou_times, 
#                                                        left.open = T) + 1]
#    # get the theta
#    this_theta <- bayou_map$pars$theta[as.integer(this_bayou_state)]
#    # accumulate theta in this state
#    cum_theta_per_state[this_paramo_state] <- cum_theta_per_state[this_paramo_state] + this_theta * this_duration
#    # accumulate time in this state
#    cum_state_time[this_paramo_state] <- cum_state_time[this_paramo_state] + this_duration
#    # increment the previous time
#    previous_time <- this_time
#  }
#  # compute the average theta
#  average_theta_per_state <- cum_theta_per_state / cum_state_time
#}

