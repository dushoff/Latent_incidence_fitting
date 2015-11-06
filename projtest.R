m <- sim$BUGSoutput$sims.matrix
est <- t(apply(m, 2, function(v){quantile(v, probs = (1:3)/4)}))
est <- est[grepl("obs", row.names(est)), ]
print(est)

plot(obs)
lines(est[, 2])
lines(est[, 1], lty=3)
lines(est[, 3], lty=3)
