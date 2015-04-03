################################################################################
## This file contains plotting fucntions.
################################################################################

###
# Plot the dataset with x-axis being one of the covariates (X) and y-axis being
# response variable (Y). All treatment labels are put in one plot.
# 
# @param dataset The data.frame to be plotted, containing Z, X's and Y.
# @param var_name The name of variable in dataset to be used as X.
# 
# @return No return. 
###
plot_data_frame = function(dataset, var_name) {
  i = 1 #color indicator
  
  labels = unique(dataset[, 1])
  for (label in labels) {
    print(label)
    print(var_name)
    if (i == 1) {
      plot(x=dataset[, var_name][dataset[, 1]==label], 
           y=dataset[, length(dataset[1, ])][dataset[, 1]==label], 
           xlim=c(min(dataset[, var_name]), max(dataset[, var_name])), 
           ylim=c(min(dataset[, length(dataset[1, ])]), max(dataset[, length(dataset[1, ])])), 
           ylab=names(dataset)[length(names(dataset))], xlab=var_name, col=i)
    } else {
      points(x=dataset[, var_name][dataset[, 1]==label], 
             y=dataset[, length(dataset[1, ])][dataset[, 1]==label], col=i)
    }
    i = i + 1
  }
  
  if (i > 1) {
    legend("topleft", legend=labels, pch=rep(1, length(labels)), col=1:i)
  }
}


###
# Calls get_plot() for covariates X_1 to X_givenIndex. Plots different X's vs. Y.
#
# @param dataset The data.frame to be plotted, containing Z, X's and Y.
# @param max_n The maximun index to be plotted. If default, plot all.
# @param plot_dim A vector indicating the plotting dimension. If default, plot all.
#
# @return No return.
###
data_frame_plots = function(dataset, max_n=NA, plot_dim=NA) {
  # decide the plotting dimension
  if (is.na(max_n) & sum(is.na(plot_dim))) {
    max_n = length(dataset[1, ]) - 2
    r = ceiling(sqrt(max_n))
    c = ceiling(max_n / r)
    par(mfrow=c(r, c))
  } else {
    par(mfrow=plot_dim)
  }
  
  var_names = names(dataset)[2:(length(names(dataset)) - 1)]
  
  for (i in 1:max_n) {
    var_name = var_names[i]
    plot_data_frame(dataset, var_name)
  }
  
  par(mfrow=c(1,1))
}