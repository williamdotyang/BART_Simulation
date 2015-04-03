################################################################################
## This file is the top-level code for whole procedure of simulation, calling 
## the functions and data in other files.
################################################################################
rm(list=ls())
set.seed(1)
### source the simulation function
source("./src/simulation_1.R")


### create raw data, in case of Z=0 & 1
# data matrix for Z=0
source("./config/param_list0-1.R")
# the number of generated observations 
dataZ0_train = simulation()
dataZ0_test = simulation(N=300)

# data matrix for Z=1
source("./config/param_list1-1.R")
# the number of generated observations
dataZ1_train = simulation()
dataZ1_test = simulation(N=300)


### data modification
source("./src/modify.R")
# standardize
# dataZ0_std = get_std(dataZ0)
# dataZ1_std = get_std(dataZ1)

# produce non-overlapping data
# dataZ0_nonovl = get_nonovl(dataset=dataZ0, variable=, direction=, percentile=)
# dataZ1_nonovl = get_nonovl(dataset=dataZ1, variable=, direction=, percentile=)

# combind the data with different treatment labels
data_train = rbind(dataZ0_train, dataZ1_train)
data_test = rbind(dataZ0_test, dataZ1_test)


### plot the data
source("./src/plotting.R")
data_frame_plots(dataset=data_train, max_n=3, plot_dim=c(1,3))


### compare linear regression and BART 
source("./applications/ols_bart.R")
