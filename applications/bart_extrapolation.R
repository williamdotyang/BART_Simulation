################################################################################
## This script is to study extrapolation on non-overlapping data using BART.
################################################################################

### plotting
source("./src/plotting.R")
# setting plotting parameters
plot_range = 1:3
plot_dim=c(1,3)

# plot original data
data_frame_plots(dataset=data_train, range=plot_range, plot_dim=plot_dim)

# plot non-overlapping data
data_frame_plots(data_train_nonovl, plot_range, plot_dim)
add_points(data_test_nonovl, plot_range, plot_dim)


### decompose datasets by variable names
Y_train = data_train_nonovl[ , length(data_train_nonovl[1, ])]
Z_train = data_train_nonovl[ , 1]
X_train = data_train_nonovl[ , 2:(length(data_train_nonovl[1, ]) - 1)]
Y_test = data_test_nonovl[ , length(data_test_nonovl[1, ])]
Z_test = data_test_nonovl[ , 1]
X_test = data_test_nonovl[ , 2:(length(data_test_nonovl[1, ]) - 1)]


### extrapolation using BART
library(BayesTree)

## fit BART on whole data
bart_extr_obj_whole = bart(x.train=data.frame(Z=Z_train, X_train), 
                           y.train=Y_train, 
                           x.test=data.frame(Z=Z_test, X_test))

# get pridictions
Y_hat_bart_extr_whole = bart_extr_obj_whole$yhat.test.mean

# get error rate
error_bart_extr_whole = Y_test - Y_hat_bart_extr_whole
data_bart_extr_whole = data_test_nonovl
data_bart_extr_whole$Y = Y_hat_bart_extr_whole
MSE_bart_extr_whole = mean(error_bart_extr_whole^2)


## fit BART seperately on each label
#stores extrapolated data from bart
Y_hat_bart_extr_sep = NULL
#stores errors of extrapolated data from bart
error_bart_extr_sep = NULL
#stores extrapolated data as a data.frame [Z_test, X_test, Y_hat_bart_extr]
data_bart_extr_sep = NULL 

labels = unique(Z_test)
for (label in labels) {
  # subsetting
  X_train_label = X_train[Z_train==label, ]
  Y_train_label = Y_train[Z_train==label]
  X_test_label = X_test[Z_test==label, ]
  Y_test_label = Y_test[Z_test==label]
  
  # fitting
  bart_extr_obj_label = bart(x.train=X_train_label, 
                             y.train=Y_train_label, 
                             x.test=X_test_label)
  Y_hat_bart_extr_label = bart_extr_obj_label$yhat.test.mean
  error_bart_extr_sep_label = Y_test_label - Y_hat_bart_extr_label
  
  # updating 
  data_bart_extr_sep = rbind(data_bart_extr_sep, 
                    data.frame(label, X_test_label, Y=Y_hat_bart_extr_label))
  Y_hat_bart_extr_sep = c(Y_hat_bart_extr_sep, Y_hat_bart_extr_label)
  error_bart_extr_sep = c(error_bart_extr_sep, error_bart_extr_sep_label)
}

MSE_bart_extr_sep = mean(error_bart_extr_sep^2)


### show the results
## plot extrapolated data points from wholly fitted BART
# plot non-overlapping data
data_frame_plots(data_train_nonovl, plot_range, plot_dim)
# add extrapolated data points on non-overlapping data
add_points(data_bart_extr_whole, plot_range, plot_dim, col="green")

## plot extrapolated data points from separately fitted BART
# plot non-overlapping data
data_frame_plots(data_train_nonovl, plot_range, plot_dim)
# add extrapolated data points on non-overlapping data
add_points(data_bart_extr_sep, plot_range, plot_dim, col="green")

## plot residuals
methods = c(rep("wholly fitted", length(error_bart_extr_whole)),
            rep("separately fitted", length(error_bart_extr_sep)))
errors_extr = c(error_bart_extr_whole, error_bart_extr_sep)
Y_hat_extr = c(Y_hat_bart_extr_whole, Y_hat_bart_extr_sep)
errors_extr = data.frame(methods=methods, Y_hat=Y_hat_extr, 
                          errors=errors_extr)

data_frame_plots(errors_extr)
(MSE_bart_extr_whole)
(MSE_bart_extr_sep)
