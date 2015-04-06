ols_whole500 = c(12028.08, 14902.18, 16121.96, 24890.62)
ols_separate500 = c(1088.04, 1166.44, 1040.016, 1697.47)
bart_whole500 = c(233.67, 515.09, 474.69, 1438.19)
bart_separate500 = c(129.84, 210.82, 230.91, 440.39)
ols_whole1000 = c(11426.64, 14528.32, 18007.36, 20079.47)
ols_separate1000 = c(1277.24, 1373.92, 1342.97, 923.84)
bart_whole1000 = c(355.92, 278.18, 386.08, 594.80)
bart_separate1000 = c(142.19, 132.84, 156.73, 203.99)

# x = c(10, 20, 30, 50)
# plot(x, ols_whole500, xlab="number of X's", ylab="MSE", 
#      xlim=c(0, 60), ylim=c(200, 25000), pch=NA)
plot(x, ols_separate500, xlab="number of X's", ylab="MSE", 
     xlim=c(0, 60), ylim=c(0, 2000), pch=NA)
lines(x, ols_whole500)
lines(x, ols_separate500, col=2)
lines(x, bart_whole500, lty=2)
lines(x, bart_separate500, lty=2, col=2)
legend("topleft", lty=c(1,1,2,2), col=c(1,2,1,2), 
       legend=c("OLS whole", "OLS separate", "BART whole", "BART separate"))

#plot(x, ols_whole1000, xlab="number of X's", ylab="MSE", 
#     xlim=c(0, 60), ylim=c(200, 25000), pch=NA)
#lines(x, ols_whole1000)
plot(x, ols_separate1000, xlab="number of X's", ylab="MSE", 
     xlim=c(0, 60), ylim=c(0, 2000), pch=NA)
lines(x, ols_separate1000, col=2)
lines(x, bart_whole1000, lty=2)
lines(x, bart_separate1000, lty=2, col=2)
legend("topright", lty=c(1,1,2,2), col=c(1,2,1,2), 
       legend=c("OLS whole", "OLS separate", "BART whole", "BART separate"))

