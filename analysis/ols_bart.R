################################################################################
# This script is to compare the OLS vs. BART on the data.
################################################################################

### linear fit
# fit on training data
ols_fit0 = lm(Y ~ ., data=data_train)

# decompose test data
Y_test = data_test[ , length(data_test[1, ])]
Z_test = data_test[ , 1]
X_test = data_test[ , 1:(length(data_test[1, ]) - 1)]

# get predictions
Y_test_hat_ols = predict(ols_fit, X_test)

# get error rate
error_ols = Y_test - Y_test_hat_ols
MSE_ols = mean(error_ols^2)

library(BayesTree)
