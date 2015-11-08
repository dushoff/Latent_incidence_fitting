q <- c(0.05, 0.25, 0.5, 0.75, 0.95)
qm <- (1+length(q))/2
top <- 4

scenario <- sub("[.].*", "", rtargetname)

m <- sim$BUGSoutput$sims.matrix
est <- t(apply(m, 2, function(v){quantile(v, probs = q)}))
est <- est[grepl("obs", row.names(est)), ]
print(est)

t <- 1:nrow(est)

plot(t, est[, qm]
	, main=scenario
	, type="l"
	, xlab="Week", ylab="Cases"
	, ylim = c(0, max(est[, top]))
)

points(t, obs)
for(i in 1:length(q)){
	lines(t, est[, i]
		, lty = 1 + abs(i-qm)
	)

}
