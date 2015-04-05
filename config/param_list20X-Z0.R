################################################################################
## This file defines the default parameter values for simulation() in 
## "src/simulation_1.R". See comments in "simulation_1.R" for description 
## on meaning of each parameter.
## Treatment Label: 0, number of covariates: 20
################################################################################
# treatment label
TREATMENT_LABEL = 0
# number of covariates, should be the same for all treatment_lable, 
# only need to assign once
n0 = 20
# number of observations
N0 = 500

### make up intercept coefficients
BETA0 = 0

### make up coefficients for covariates x1,..., xn
BETA1 = rep(2, 20)
### make up 2nd order interaction index dataframe for x's, and their coefficients
# INTER should be the same for all treatment_lable, only need to assign once
INTER2 = choose2inter(n=n0, 10)
BETA2 = rep(1, 10)
### make up 3nd order interaction index dataframe for x's, and their coefficients
# INTER should be the same for all treatment_lable, only need to assign once
INTER3 = choose3inter(n=n0, 5)
BETA3 = rep(1, 5)

### means
# should be the same for all treatment_lable
MUS = rep(2, n0)

### specify the covariance matrix
# should be the same for all treatment_lable, only need to assign once
SIGMA = matrix(rep(0.5, 100), nrow=10, ncol=10) + diag(0.5, 10)