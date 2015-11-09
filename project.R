q <- c(0.05, 0.25, 0.5, 0.75, 0.95)
qm <- (1+length(q))/2
topQuant <- 4
shortWindow <- 4

scenario <- sub("[.].*", "", rtargetname)

m <- sim$BUGSoutput$sims.matrix
est <- t(apply(m, 2, function(v){quantile(v, probs = q)}))
est <- est[grepl("obs", row.names(est)), ]
print(est)

forecast_plot <- function(finTime){

	t <- 1:finTime
	est <- est[1:finTime, ]
	obs <- obs[1:finTime]

	plot(t, est[, qm]
		, main=scenario
		, type="l"
		, xlab="Week", ylab="Cases"
		, ylim = c(0, max(est[, topQuant]))
	)

	points(t, obs)
	for(i in 1:length(q)){
		lines(t, est[, i]
			, lty = 1 + abs(i-qm)
		)
	}
}

forecast_plot(shortWindow+sum(!is.na(obs)))
forecast_plot(nrow(est))
