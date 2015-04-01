###extrapolating the linear trend using BART
x1 = runif(100, min=0, max=50)
x2 = runif(80, min=0, max=40)
y1 = 3 + 0.5 * x1 + rnorm(length(x1))
y2 = 1 - 0.5 * x2 + rnorm(length(x2))
plot(x1, y1, xlim=range(x1) * 1.2, ylim=c(min(min(y1), min(y2)) * 1.2, 
                                  max(max(y1), max(y2))) * 1.2)
points(x2, y2)

###fitting BART
x_train1 = data.frame(z=1, x=x1)
x_train2 = data.frame(z=2, x=x2)
x_train_whole = data.frame(z=c(rep(1, length(x1)), rep(2, length(x2))), 
                           x=c(x1, x2))
x_test1 = data.frame(z=2, x=x1)

library(BayesTree)
bart_obj1 = bart(x.train=x_train2, y.train=y2, x.test=x_test1)
y2_hat = bart_obj1$yhat.test.mean
points(x1, y2_hat, col="red")

bart_obj2 = bart(x.train=x_train_whole, y.train=c(y1, y2), x.test=x_test1)
y2_hat2 = bart_obj2$yhat.test.mean
points(x1, y2_hat2, col="blue")
legend("topleft", pch=c(1,1,1), col=c("black","red","blue"),
       legend=c("original", "extrapolated with z=2 only", "extrapolated with both z's"))
