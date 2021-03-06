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
    #print(var_name)
    #print(label)
    if (i == 1) {
      plot(x=dataset[, var_name][dataset[, 1]==label], 
           y=dataset[, length(dataset[1, ])][dataset[, 1]==label], 
           xlim=c(min(dataset[, var_name]), max(dataset[, var_name])), 
           ylim=c(min(dataset[, length(dataset[1, ])]), max(dataset[, length(dataset[1, ])])), 
           ylab=names(dataset)[length(names(dataset))], xlab=var_name, col=i)
    } else {
      points(x=dataset[, var_name][dataset[, 1]==label], 
             y=dataset[, length(dataset[1, ])][dataset[, 1]==label], col=i, pch=i)
    }
    i = i + 1
  }
  
  if (i > 1) {
    legend("topleft", legend=labels, col=1:i, pch=1:i)
  }
}


###
# Calls get_plot() for covariates X_1 to X_givenIndex. Plots different X's vs. Y.
#
# @param dataset The data.frame to be plotted, containing Z, X's and Y.
# @param range A set of indicies to be plotted. If default, plot all.
# @param plot_dim A vector indicating the plotting dimension. If default, plot all.
#
# @return No return.
###
data_frame_plots = function(dataset, range=NA, plot_dim=NA) {
  # decide the plotting dimension
  if (sum(is.na(range)) & sum(is.na(plot_dim))) {
    range = 1:(length(dataset[1, ]) - 2)
    r = ceiling(sqrt(range))
    c = ceiling(range / r)
    par(mfrow=c(r, c))
  } else {
    par(mfrow=plot_dim)
  }
  
  var_names = names(dataset)[2:(length(names(dataset)) - 1)]
  
  for (i in range) {
    var_name = var_names[i]
    plot_data_frame(dataset, var_name)
  }
  
  par(mfrow=c(1,1))
}

###
# Add points to current figure(s).
#
# @param dataset The data.frame to be plotted, containing Z, X's and Y.
# @param range A set of indicies to be plotted.
# @param plot_dim A vector indicating the plotting dimension.
#
# @return No return.
###
add_points = function(dataset, range, plot_dim, col="blue") {
  par(mfrow=plot_dim)
  
  labels = unique(dataset[, 1])
  for (i in range) {
    # select subplot
    par(mfg=c(1,i))
    # reset pch starting value
    pch=1
    
    for (label in labels) {
      points(dataset[dataset[, 1]==label, 1+i], 
             dataset[dataset[, 1]==label, length(dataset[1, ])], 
             col=col, pch=pch)
      pch = pch + 1
    }
  }
  
  par(mfrow=c(1,1))
}