################################################################################
## This file is the top-level code for whole procedure of simulation, calling 
## the functions and data in other files.
################################################################################
rm(list=ls())
set.seed(1)

###########################generating data######################################
### source the simulation function
source("./src/simulation_1.R")


### create raw data, in case of Z=0 & 1
# data matrix for Z=0
source("./config/param_list3X-Z0.R")
# the number of generated observations 
dataZ0_train = simulation()
dataZ0_test = simulation(N=300)

# data matrix for Z=1
source("./config/param_list3X-Z1.R")
# the number of generated observations
dataZ1_train = simulation()
dataZ1_test = simulation(N=300)


###########################modifying data#######################################
source("./src/modify.R")

## standardize
data_train = rbind(dataZ0_train, dataZ1_train)
data_test = rbind(dataZ0_test, dataZ1_test)

std_obj = get_std(data_train, data_test)
data_train_std = std_obj$train
data_test_std = std_obj$test

dataZ0_train_std = data_train_std[which(data_train_std$Z==0), ]
dataZ1_train_std = data_train_std[which(data_train_std$Z==1), ]
dataZ0_test_std = data_test_std[which(data_test_std$Z==0), ]
dataZ1_test_std = data_test_std[which(data_test_std$Z==1), ]

#***********IF DONT WANT TO STANDARDIZE, COMMENT OUT THIS BLOCK****************#
# replace original data with the X's been stded
data_train = data_train_std
data_test = data_test_std
dataZ0_train = dataZ0_train_std
dataZ1_train = dataZ1_train_std
dataZ0_test = dataZ0_test_std
dataZ1_test = dataZ1_test_std
#***********IF DONT WANT TO STANDARDIZE, COMMENT OUT THIS BLOCK****************#


## produce non-overlapping data
miss_index0 = get_nonovl_indicies(dataZ0_train, "X1", "upper", percentile=0.2)
miss_index1 = get_nonovl_indicies(dataZ1_train, "X1", "lower", percentile=0.2)
dataZ0_nonovl = dataZ0_train[-miss_index0, ]
dataZ1_nonovl = dataZ1_train[-miss_index1, ]
dataZ0_deleted = dataZ0_train[miss_index0, ]
dataZ1_deleted = dataZ1_train[miss_index1, ]
data_train_nonovl = rbind(dataZ0_nonovl, dataZ1_nonovl)
data_test_nonovl = rbind(dataZ0_deleted, dataZ1_deleted)


###########################applications on data#################################
### compare linear regression and BART 
# source("./applications/ols_bart.R")


### extrapolation
source("applications/bart_extrapolation.R")