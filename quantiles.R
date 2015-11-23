q <- c(0.05, 0.25, 0.5, 0.75, 0.95)

m <- sim$BUGSoutput$sims.matrix
allest <- t(apply(m, 2, function(v){quantile(v, probs = q)}))
print(allest)
est <- allest[grepl("obs", row.names(allest)), ]

# rdsave(q, est, allest, obs)
