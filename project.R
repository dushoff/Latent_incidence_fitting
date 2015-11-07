q <- c(0.05, 0.25, 0.5, 0.75, 0.95)
qm <- (1+length(q))/2

m <- sim$BUGSoutput$sims.matrix
est <- t(apply(m, 2, function(v){quantile(v, probs = q)}))
est <- est[grepl("obs", row.names(est)), ]
print(est)

t <- 1:nrow(est)

plot(t, est[, qm]
	, type="l"
	, xlab="Week", ylab="Cases"
)

points(t, obs)
for(i in 1:length(q)){
	lines(t, est[, i], lty=2)
}
