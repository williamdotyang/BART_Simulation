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

# when studying non-overlapping data, only use train dataset, the test dataset 
# will split from the train dataset, according to the missingness indicies
dataZ0_nonovl = dataZ0_train
dataZ1_nonovl = dataZ1_train


###########################modifying data#######################################
source("./src/modify.R")

## standardize
data_train = rbind(dataZ0_train, dataZ1_train)
data_test = rbind(dataZ0_test, dataZ1_test)

# std for the pooled data, pooling train & test of each of the same label
pooled_std_obj = get_pooled_std(data_train, data_test)
data_train_pooled_std = pooled_std_obj$train
data_test_pooled_std = pooled_std_obj$test

dataZ0_train_pooled_std = data_train_pooled_std[which(data_train_pooled_std$Z==0), ]
dataZ1_train_pooled_std = data_train_pooled_std[which(data_train_pooled_std$Z==1), ]
dataZ0_test_pooled_std = data_test_pooled_std[which(data_test_pooled_std$Z==0), ]
dataZ1_test_pooled_std = data_test_pooled_std[which(data_test_pooled_std$Z==1), ]

# std for only training data, the test data splits from the training data, using
# the missingness indicies produced by get_nonovl_indicies()
data_solo_std = get_solo_std(data_train)
dataZ0_solo_std = data_solo_std[data_solo_std$Z==0, ]
dataZ1_solo_std = data_solo_std[data_solo_std$Z==1, ]


#***********IF DONT WANT TO STANDARDIZE, COMMENT OUT THIS BLOCK****************#
# replace original data with the X's been stded
data_train = data_train_pooled_std
data_test = data_test_pooled_std
dataZ0_train = dataZ0_train_pooled_std
dataZ1_train = dataZ1_train_pooled_std
dataZ0_test = dataZ0_test_pooled_std
dataZ1_test = dataZ1_test_pooled_std
dataZ0_nonovl = dataZ0_solo_std
dataZ1_nonovl = dataZ1_solo_std
#***********IF DONT WANT TO STANDARDIZE, COMMENT OUT THIS BLOCK****************#

## produce non-overlapping data
miss_index0 = get_nonovl_indicies(dataZ0_nonovl, "X1", "upper", percentile=0.2)
miss_index1 = get_nonovl_indicies(dataZ1_nonovl, "X1", "lower", percentile=0.2)
dataZ0_train_nonovl = dataZ0_nonovl[-miss_index0, ]
dataZ1_train_nonovl = dataZ1_nonovl[-miss_index1, ]
dataZ0_test_nonovl = dataZ0_nonovl[miss_index0, ]
dataZ1_test_nonovl = dataZ1_nonovl[miss_index1, ]

data_train_nonovl = rbind(dataZ0_train_nonovl, dataZ1_train_nonovl)
data_test_nonovl = rbind(dataZ0_test_nonovl, dataZ1_test_nonovl)


###########################applications on data#################################
### compare linear regression and BART 
# source("./applications/ols_bart.R")


### extrapolation
source("applications/bart_extrapolation.R")