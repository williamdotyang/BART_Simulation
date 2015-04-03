################################################################################
# This script is to compare the OLS vs. BART on the data.
################################################################################

# decompose datasets by variable names
Y_train = data_train[ , length(data_train[1, ])]
Z_train = data_train[ , 1]
X_train = data_train[ , 2:(length(data_train[1, ]) - 1)]
Y_test = data_test[ , length(data_test[1, ])]
Z_test = data_test[ , 1]
X_test = data_test[ , 2:(length(data_test[1, ]) - 1)]


### OLS fit on whole training data
ols_fit = lm(Y ~ ., data=data_train)

# get predictions
Y_hat_ols_whole = predict(ols_fit, data.frame(Z=Z_test, X_test))

# get error rate
error_ols_whole = Y_test - Y_hat_ols_whole
MSE_ols_whole = mean(error_ols_whole^2)


### BART fit on whole training data
library(BayesTree)
bart_obj_whole = bart(x.train=data.frame(Z=Z_train, X_train), y.train=Y_train, 
                x.test=data.frame(Z=Z_test, X_test))

# get pridictions
Y_hat_bart_whole = bart_obj_whole$yhat.test.mean

# get error rate
error_bart_whole = Y_test - Y_hat_bart_whole
MSE_bart_whole = mean(error_bart_whole^2)


### OLS and BART fit on separate treatment labels
error_ols_separate = NULL
error_bart_separate = NULL
Y_hat_ols_separate = NULL
Y_hat_bart_separate = NULL

labels = unique(Z_test)
for (label in labels) {
  # subsetting
  X_train_label = X_train[Z_train==label, ]
  Y_train_label = Y_train[Z_train==label]
  X_test_label = X_test[Z_test==label, ]
  Y_test_label = Y_test[Z_test==label]
  #data_train_label = data_train[Z_train==label, ]
  #data_test_label = data_test[Z_test==label, ]
  
  # fitting
  ols_fit_label = lm(Y ~ ., data=data.frame(X_train_label, Y=Y_train_label))
  Y_hat_ols_label = predict(ols_fit_label,  X_test_label)
  error_ols_label = Y_test_label - Y_hat_ols_label
  
  bart_obj_label = bart(x.train=X_train_label, 
                        y.train=Y_train_label, 
                        x.test=X_test_label)
  Y_hat_bart_label = bart_obj_label$yhat.test.mean
  error_bart_label = Y_test_label - Y_hat_bart_label
  
  
  error_ols_separate = c(error_ols_separate, error_ols_label)
  error_bart_separate = c(error_bart_separate, error_bart_label)
  Y_hat_ols_separate = c(Y_hat_ols_separate, Y_hat_ols_label)
  Y_hat_bart_separate = c(Y_hat_bart_separate, Y_hat_bart_label)
}

MSE_ols_separate = mean(error_ols_separate^2)
MSE_bart_separate = mean(error_bart_separate^2)

### plotting errors
# fitted with whole data
methods = c(rep("ols", length(error_ols_whole)), 
                 rep("bart", length(error_bart_whole)))
errors_whole = c(error_ols_whole, error_bart_whole)
Y_hat_whole = c(Y_hat_ols_whole, Y_hat_bart_whole)
errors_whole = data.frame(methods=methods, Y_hat=Y_hat_whole, 
                          errors=errors_whole)

data_frame_plots(errors_whole)
(MSE_ols_whole)
(MSE_bart_whole)

# fitted with separate data
methods = c(rep("ols", length(error_ols_separate)), 
            rep("bart", length(error_bart_separate)))
errors_separate = c(error_ols_separate, error_bart_separate)
Y_hat_separate = c(Y_hat_ols_separate, Y_hat_bart_separate)
errors_separate = data.frame(methods=methods, Y_hat=Y_hat_separate, 
                             errors=errors_separate)

data_frame_plots(errors_separate)
(MSE_ols_separate)
(MSE_bart_separate)