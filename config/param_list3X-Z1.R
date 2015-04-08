################################################################################
## This file defines the default parameter values for simulation() in 
## "src/simulation_1.R". See comments in "simulation_1.R" for description 
## on meaning of each parameter.
## Treatment Label: 1, number of covariates: 3
################################################################################
# treatment label
TREATMENT_LABEL = 1
# number of covariates, should be the same for all treatment_lable, 
# only need to assign once
#n0 = 3 
# number of observations
N0 = 500

### make up intercept coefficients
BETA0 = 200

### make up coefficients for covariates x1,..., xn
BETA1 = c(-1, -1, -1)
### make up 2nd order interaction index dataframe for x's, and their coefficients
# INTER should be the same for all treatment_lable, only need to assign once
#INTER2 = data.frame(first=c(1,2,3), second=c(3,1,2))
BETA2 = c(-2, -2, -2)
### make up 3nd order interaction index dataframe for x's, and their coefficients
# INTER should be the same for all treatment_lable, only need to assign once
#INTER3 = data.frame(first=1, second=2, third=3)
BETA3 = -1

### means
# should be the same for all treatment_lable
MUS = c(2, 2, 2)

### specify the covariance matrix
# should be the same for all treatment_lable, only need to assign once
# SIGMA = matrix(nrow=n0, c(1, 0.5, 0.5, 
#                           0.5, 1, 0.5, 
#                           0.5, 0.5, 1))