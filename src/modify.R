################################################################################
## This file contains functions for modifying raw data.frame [Z, X's, Y].
################################################################################

###
# Delete some rows of a data.frame, in order to create non-overlapping data.
#
# @param dataset The original full data.frame.
# @param variable The variable name in dataset subject to deleting condition.
# @param direction Either "upper" or "lower", meaning the direction of the data 
# to be deleted.
# @param percentile The percentile(always < 50%) to be deleted.
#
# @return A data.frame where the cases deleted. 
###
get_nonovl = function(dataset, variable, direction, percentile) {
  # to be stored with deleted observations' indicies
  missing_indicies = NULL
  
  for (i in 1:length(dataset[ ,1])) {
    if (direction == "upper") {
      if (dataset[i, variable] >= qnorm(0.8, mean=MUS[1], sd=sqrt(SIGMA[1,1]))) {
        # by probability of miss_p
        #if (rbinom(1, 1, miss_prob) == 1) {
        missing_indicies = c(missing_indicies, i)
        #}
      }
      # for Z=1
    } else {
      # X1 which is in lower 25% is subject to missing 
      if (data$X1[i] <= qnorm(0.2, mean=MUS[1], sd=sqrt(SIGMA[1,1]))) {
        # by probability of miss_p
        #if (rbinom(1, 1, miss_prob) == 1) {
        missing_indicies = c(missing_indicies, i)
        #}
      }
    }
  }
  return(dataset[-missing_indicies, ])
}


###
# Standardize the covariates, leave treatment label and response variable
# untouched.
#
# @param dataset The original full data.frame.
###
get_std = function() {
  
}

