################################################################################
## This file contains functions for modifying raw data.frame [Z, X's, Y].
################################################################################

###
# Delete some rows of a data.frame, in order to create non-overlapping data.
#
# @param dataset The original full data.frame.
# @param variable The variable name in dataset subject to deleting condition.
# @param direction Either "upper" or "lower", meaning the direction of the data 
# to be deleted.
# @param percentile The percentile(always < 50%) to be deleted.
#
# @return A vector of indicies of observations to be deleted in dataset.
###
get_nonovl_indicies = function(dataset, variable, direction, percentile) {
  # to be stored with deleted observations' indicies
  missing_indicies = NULL
  
  for (i in 1:length(dataset[ ,1])) {
    if (direction == "upper") {
      if (dataset[i, variable] >= quantile(dataset[, variable], 1-percentile)) {
        missing_indicies = c(missing_indicies, i)
      }
    } else {
      if (dataset[i, variable] <= quantile(dataset[, variable], percentile)) {
        missing_indicies = c(missing_indicies, i)
      }
    }
  }
  
  return(missing_indicies)
}


###
# Standardize the covariates, leave treatment label and response variable
# untouched. When standardizing, training and test data are put together.
#
# @param dataset_train The training dataset to be standardized.
# @param dataset_test The test dataset to be standardized.
#
# @return A list of two dataset, standardized training and standardized testing.
###
get_std = function(data_train, data_test) {
  #data extraction
  Z_train = data_train[ , 1]
  Z_test = data_test[ , 1]
  X_train = data_train[ , 2:(length(data_train[1, ]) - 1)]
  X_test = data_test[ , 2:(length(data_test[1, ]) - 1)]
  Y_train = data_train[ , length(data_train[1, ])]
  Y_test = data_test[ , length(data_test[1, ])]
  
  #standardize X
  X_train_std = X_train #to be substituted by stded rows
  X_test_std = X_test #to be substituted by stded rows
  labels = unique(Z_train)
  for (label in labels) {
    Xlab_pool = rbind(subset(X_train, Z_train==label), 
                      subset(X_test, Z_test==label))
    Xlab_pool_std = scale(Xlab_pool)
    
    #split train and test
    Xlab_train_std = Xlab_pool_std[1:sum(Z_train==label), ]
    Xlab_test_std = Xlab_pool_std[(sum(Z_train==label)+1):
                                    (sum(Z_train==label)+sum(Z_test==label)), ]
    
    #insert std values into original places
    X_train_std[Z_train==label, ] = Xlab_train_std
    X_test_std[Z_test==label, ] = Xlab_test_std
  }
  
  list_obj = list()
  list_obj$train = data.frame(Z=Z_train, X_train_std, Y=Y_train)
  list_obj$test = data.frame(Z=Z_test, X_test_std, Y=Y_test)
  return(list_obj)
}

