set.seed(1)
n = 120
Z = rbinom(n, 1, 0.5)
X = rep(0, n)
Y = rep(0, n)

for (i in 1:n) {
  if (Z[i] == 1) {
    X[i] = rnorm(1, 40, 10)
    Y[i] = rnorm(1, 90 + exp(0.06 * X[i]), 1)
  } else if (Z[i] == 0) {
    X[i] = rnorm(1, 20, 10)
    Y[i] = rnorm(1, 72 + 3 * sqrt(X[i]), 1)
  } else {
    cat("expect Z to be either 0 or 1")
  }
}

#remove the NaN
na_index = -which(is.na(Y))
X = X[na_index]
Y = Y[na_index]
Z = Z[na_index]

plot(X[Z==0], Y[Z==0], pch=5, xlab="X", ylab="Y", xlim=c(0,65), ylim=c(75, 130))
points(X[Z==1], Y[Z==1], pch=1)

#true response curve
xgrid = seq(from=0, to=65, by=0.5)
ygrid1 = 90 + exp(0.06 * xgrid)
ygrid0 = 72 + 3 * sqrt(xgrid)
lines(xgrid, ygrid1)
lines(xgrid, ygrid0)

#least square fit
ols_fit1 = lm(Y[Z==1] ~ X[Z==1])$coefficient
ols_fit0 = lm(Y[Z==0] ~ X[Z==0])$coefficient
#abline(ols_fit1, lty=4)
#abline(ols_fit0, lty=4)

#bart
library(BayesTree)
x_train1 = data.frame(Z=1, X=X[Z==1])
x_train0 = data.frame(Z=0, X=X[Z==0])
x_test1 = data.frame(Z=0, X=X[Z==1])
x_test0 = data.frame(Z=1, X=X[Z==0])
x_train_whole = rbind(x_train0, x_train1)
x_test_whole = rbind(x_test1, x_test0)

bart_obj1 = bart(x.train=x_train1, y.train=Y[Z==1], x.test=x_test0)
bart_obj0 = bart(x.train=x_train0, y.train=Y[Z==0], x.test=x_test1)
bart_obj_whole = bart(x.train=x_train_whole, y.train=c(Y[Z==0], Y[Z==1]), 
                      x.test=x_test_whole)
bart_fit1 = bart_obj1$yhat.test.mean
bart_fit0 = bart_obj0$yhat.test.mean
bart_fit_whole = bart_obj_whole$yhat.test.mean

points(X[Z==0], bart_fit1, col="blue", pch=1)
points(X[Z==1], bart_fit0, col="red", pch=5)
lines(sort(X[Z==0]), sort(bart_fit1), col="blue", lty=2)
lines(sort(X[Z==1]), sort(bart_fit0), col="red", lty=2)
legend("topleft", pch=c(1,5,1,5), lty=c(1,2,1,2), col=c(1,1,4,2),
       legend=c("simulated points, Z=1", "simulated points, Z=0", 
                "extrapolated points, Z=1", "extrapolated points, Z=0"),)


plot(X[Z==0], Y[Z==0], pch=5, xlab="X", ylab="Y", xlim=c(0,65), ylim=c(75, 130))
points(X[Z==1], Y[Z==1], pch=1)
lines(xgrid, ygrid1)
lines(xgrid, ygrid0)
points(sort(x_test_whole$X[x_test_whole$Z==1]), 
       sort(bart_fit_whole[x_test_whole$Z==1]), col="blue")
points(sort(x_test_whole$X[x_test_whole$Z==0]), 
       sort(bart_fit_whole[x_test_whole$Z==0]), col="red", pch=5)
lines(sort(x_test_whole$X[x_test_whole$Z==1]), 
       sort(bart_fit_whole[x_test_whole$Z==1]), col="blue", lty=2)
lines(sort(x_test_whole$X[x_test_whole$Z==0]), 
       sort(bart_fit_whole[x_test_whole$Z==0]), col="red", lty=2)
legend("topleft", pch=c(1,5,1,5), lty=c(1,2,1,2), col=c(1,1,4,2),
       legend=c("simulated points, Z=1", "simulated points, Z=0", 
                "extrapolated points, Z=1", "extrapolated points, Z=0"),)
