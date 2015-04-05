################################################################################
## This file contains functions for generating simulation datasets.
## ALL the parameter setting are done in "./congig/param_list*".
## DO NOT change unless for simulation scheme changes.
################################################################################

### 
# Simulate the X's covariates and corresponding reponse variable's value, without
# treatment lable Z.
#
# @param n Number of covariates
# @param N Number of observations
# @param treatment_lable The value of treatment label vraiable Z.
# @param mus X_i ~ rmvnorm(n, mus, sigma)
# @param sigma X_i ~ rmvnorm(n, mus, sigma)
# @param beta1 The coefficients for x_i
# @param beta2 The coefficients for x_i*x_j (i & j are chosen in inter2)
# @param beta3 The coefficients for x_i*x_j*x_k (i & j & k are chosen in inter3)
# @param inter2 (2D array) Second order interaction indicies
# @param inter3 (2D array) Third order interaction indicies
# 
# @return A data.frame with variable names [Z, X1, ...,Xn, Y]
###
simulation = function(n=n0, N=N0, 
                         treatment_label = TREATMENT_LABEL,
                         mus=MUS,
                         sigma=SIGMA,
                         beta0=BETA0,
                         beta1=BETA1,
                         beta2=BETA2, 
                         beta3=BETA3,
                         inter2=INTER2, 
                         inter3=INTER3) {
  
  # construct an empty data matrix
  data = matrix(0, N, n+2)
  data[, 1] = treatment_label
  
  # generate X matrix for dependent X's
  library(mvtnorm)
  x = rmvnorm(N, mean=mus, sigma)
  data[, 2:(n+1)] = x
  
  #error term
  epcilon = rnorm(N, mean=0, sd=1)
  
  # construct y_i
  for (i in 1:N) {  
    x_i = data[i, 2:(n+1)]
    
    y_i = beta0 + sum(beta1 * x_i) + 
      sum(beta2 * x_i[inter2$first] * x_i[inter2$second]) + 
      sum(beta3 * x_i[inter3$first] * x_i[inter3$second] * x_i[inter3$third])
    
    data[i, n+2] = y_i + epcilon[i]
  }
  
  # set data type to be dataframe and fix the variable names
  data = as.data.frame(data)
  name_label = c("Z", rep("X", n), "Y")
  for (i in 1:n) {
    name_label[1 + i] = paste0("X", i)
  }
  names(data) = name_label
  return(data)
}


##
# From x_i's choose given number of pairs of 2-way interactions, 
# creates a dataframe for indexes indicating the interaction terms. This avoids
# creating the quadratic term.
#
# @param n The number of covariates.
# @param term The number of interactions to be created.
#
# @return A data.frame of [first, second], indicating the indicies of x_i's.
##
choose2inter = function(n, term) { 
  flag = T
  while(flag) {
    first = sample(n, term)
    second = sample(n, term)
    
    flag = F
    for (i in 1:term) {
      if (length(unique(c(first[i], second[i]))) < 2) {
        flag = T
      }
    }
  }
  
  return(data.frame(first, second))
}


##
# From x_i's choose given number of pairs of 3-way interactions, 
# creates a dataframe for indexes indicating the interaction terms. This avoids
# creating cubic terms.
#
# @param n The number of covariates.
# @param term The number of interactions to be created.
#
# @return A data.frame of [first, second, third], 
# indicating the indicies of x_i's.
##
choose3inter = function(n=3, term=1) { 
  flag = T
  while(flag) {
    first = sample(n, term)
    second = sample(n, term)
    third = sample(n, term)
    
    flag = F
    for (i in 1:term) {
      if (length(unique(c(first[i], second[i], third[i]))) < 3) {
        flag = T
      }
    }
  }
  
  return(data.frame(first, second, third))
}

#### test code
##import the default parameter settings
#source("./param_list1.R")
#data = simulation()
