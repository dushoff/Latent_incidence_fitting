require("R2jags")

set.seed(2112)
# iterations <- 100

mult <- 1:4
maxRep <- 0.75

max <- length(obs)

# Parse the lag out of the model file name (clunky)
lag <- as.numeric(gsub("[A-Za-z_.]*", "", input_files[1]))
lagvec <- 1:lag
pop <- 6e6
epscase <- 0.01

data <- list ("obs", "max", "lag", "lagvec", "pop", "epscase")

inits <- lapply (mult, function(m){
	pre <- 1+m*obs[[1]]
	return(list(
		cases = c(
			rep(pre, lag)
			, 1+m*obs
		)
		# , repMean = maxRep/m
		, ker = rep(1/lag, lag)
	))
})

print(inits)

sim <- jags(model.file=input_files[[1]],
	data=data, inits=inits, 
	parameters = c("ker", "R0", "gen"
		, "repMean"
		, "obs"
		, "effProp", "alpha"
	),
	n.chains = length(mult), n.iter = iterations
)

print(sim)
plot(sim)
# traceplot(sim)
