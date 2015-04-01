################################################################################
## This file defines the default parameter values for simulation() in 
## "simulation_1.R". See comments in "simulation_1.R" for description on meaning
## of each parameter.
################################################################################
#treatment label
TREATMENT_LABEL = 1
#number of covariates
n0 = 3 
#number of observations
N0 = 700

### make up intercept coefficients
BETA0 = 200

### make up coefficients for covariates x1,..., xn
BETA1 = c(1, 3, 7)
### make up 2nd order interaction index dataframe for x's, and their coefficients
#INTER should be the same for all treatment_lable
INTER2 = data.frame(first=c(1,2,3), second=c(2,3,1))
BETA2 = c(-2, 5, -8)
### make up 3nd order interaction index dataframe for x's, and their coefficients
#INTER should be the same for all treatment_lable
INTER3 = data.frame(first=1, second=2, third=3)
BETA3 = 5

### means
#should be the same for all treatment_lable
MUS = c(2, 3, 4)

### specify the covariance matrix
#should be the same for all treatment_lable
SIGMA = matrix(nrow=n0, c(9, 2, 1, 
                          2, 1, 0.4, 
                          1, 0.4, 1))