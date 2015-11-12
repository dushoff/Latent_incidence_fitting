q <- c(0.05, 0.25, 0.5, 0.75, 0.95)

m <- sim$BUGSoutput$sims.matrix
est <- t(apply(m, 2, function(v){quantile(v, probs = q)}))
est <- est[grepl("obs", row.names(est)), ]
print(est)

# rdsave(q, est, obs)

