# for each paramo state 
# the average theta in that state
# and return the duration in the state
# once you do that for every branch
# findInterval 
# cumsum(history)

paramo_map <- EP.maps[[500]]
bayou_map <- test[[1]]
paramo_models <- Qmats


num_param_states = dim(paramo_models[[1]])[1] * dim(paramo_models[[2]])[1] * dim(paramo_models[[3]])[1]
cum_theta_per_state = numeric(num_param_states)
cum_state_time      = numeric(num_param_states)
# compute the change times for each history
paramo_times = cumsum(paramo_history)
bayou_times  = cumsum(bayou_history)
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