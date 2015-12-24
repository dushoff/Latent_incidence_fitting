
# This is probably the only thing that's changed from est, so this is bad design
q <- c(0.05, 0.15, 0.35, 0.6, 0.95)

m <- sim$BUGSoutput$sims.matrix

tstats <- as.data.frame(t(apply(m, 1, function(r){
	obs <- r[grepl("obs", names(r))]
	return(c(
		finalSize = sum(obs) 
		, peakSize = max(obs)
		, peakWeek = which.max(obs)
		, endWeek = suppressWarnings(min(which(obs==0)))
	))
})))
names(tstats) <- c("finalSize", "peakSize", "peakWeek", "endWeek")

m <- cbind(m, tstats)

print(summary(m))


allest <- t(apply(m, 2, function(v){quantile(v, probs = q)}))
oc <- grepl("obs", row.names(allest))

est <- allest[oc, ]
parest <- allest[!oc, ]

print(parest)

# rdsave(q, est, parest, obs)

