# for each paramo state 
# the average theta in that state
# and return the duration in the state
# once you do that for every branch
# findInterval 
# cumsum(history)

### source scripts
source("comparison/scripts/subset_chainOU.R")
source("comparison/scripts/reduce_to_unique_states.R")
### load in example data

# bayou
load("C:/Users/Ethan/Desktop/underground_evo/bayou/output/bayou_temp_1.RData")
bayou <- subset_chainOU(chainOU = chainOU_temp, nsamples = 100)
bayou_map <- bayou[[1]]
rm(chainOU_temp, bayou)

# paramo
load("C:/Users/Ethan/Desktop/underground_evo/paramo/output/EP_test.RData")
paramo_map <- ape::reorder.phylo(EP.maps[[10]], "postorder")
load("C:/Users/Ethan/Desktop/underground_evo/paramo/output/Qmats_test.RData")
paramo_models <- Qmats
rm(EP.maps, Qmats)

# total number of parameter states 
num_param_states = dim(paramo_models[[1]])[1] * dim(paramo_models[[2]])[1] * dim(paramo_models[[3]])[1]

# set up vectors 
cum_theta_per_state = numeric(num_param_states)
cum_state_time      = numeric(num_param_states)

# compute the change times for each history
branch = 927
p_map <- unique(data.frame(name = names(paramo_map$maps[[branch]]),
                           length = paramo_map$maps[[branch]]))

paramo_times = cumsum(reduce_to_unique_states())
bayou_times  = cumsum(bayou_map$tree$maps[[branch]])
# compute the combined change times
combined_times = sort(unique(c(paramo_times, bayou_times)))
num_times      = length(combined_times)
# loop over the combined history
previous_time = 0
for(i in 1:num_times) {
  # get the time
  this_time = combined_times[i]
  # compute the duration
  this_duration = this_time - previous_time
  # get the paramo state
  this_paramo_state = something like findIntervals(this_time, paramo_times) + 1
  # get the bayou state
  this_bayou_state = something like findIntervals(this_time, bayou) + 1
  # get the theta
  this_theta = thetas[this_bayou_state]
  # accumulate theta in this state
  cum_theta_per_state[this_paramo_state] = cum_theta_per_state[this_paramo_state] + this_theta * this_duration
  # accumulate time in this state
  cum_state_time[this_paramo_state] = cum_state_time[this_paramo_state] + this_duration
  # increment the previous time
  previous_time = this_time
}
# compute the average theta
average_theta_per_state = cum_theta_per_state / cum_state_time