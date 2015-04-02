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
  
  labels = unique(dataset$Z)
  for (label in labels) {
    print(label)
    print(var_name)
    if (i == 1) {
      plot(x=dataset[, var_name][dataset$Z==label], 
           y=dataset$Y[dataset$Z==label], 
           xlim=c(min(dataset[, var_name]), max(dataset[, var_name])), 
           ylim=c(min(dataset$Y), max(dataset$Y)), 
           ylab=names(dataset)[length(names(dataset))], xlab=var_name, col=i)
    } else {
      points(x=dataset[, var_name][dataset$Z==label], 
             y=dataset$Y[dataset$Z==label], col=i)
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
# @param max_n The maximun index to be plotted
# @param plot_dim A vector indicating the plotting dimension.
#
# @return No return.
###
data_frame_plots = function(dataset, max_n, plot_dim) {
  par(mfrow=plot_dim)
  var_names = names(dataset)[2:(length(names(dataset)) - 1)]
  
  for (i in 1:max_n) {
    var_name = var_names[i]
    plot_data_frame(dataset, var_name)
  }
  
  par(mfrow=c(1,1))
}