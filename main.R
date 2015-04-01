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
source("./config/param_list0.R")
# the number of generated observations 
dataZ0 = simulation()

# data matrix for Z=1
source("./config/param_list1.R")
# the number of generated observations
dataZ1 = simulation()


### data modification
source("./src/modify.R")
# standardize
# dataZ0 = get_std(dataZ0)
# dataZ1 = get_std(dataZ1)

# produce non-overlapping data
# dataZ0 = get_nonovl(dataset=dataZ0, variable=, direction=, percentile=)
# dataZ1 = get_nonovl(dataset=dataZ1, variable=, direction=, percentile=)

# combind the data with different treatment labels
data = rbind(dataZ0, dataZ1)


### plot the data
source("./src/plotting.R")
data_frame_plots(dataset=data, max_n=3, plot_dim=c(1,3))


### BART fitting 
