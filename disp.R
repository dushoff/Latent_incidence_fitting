require("R2jags")

mult <- 1:4
maxRep <- 0.9

max <- length(obs)

# Parse the lag out of the model file name (clunky)
lag <- as.numeric(gsub("[A-Za-z_.]*", "", input_files[1]))
lagvec <- 1:lag

data <- list ("obs", "max", "lag", "lagvec")

inits <- lapply (mult, function(m){
	pre <- 1+m*obs[[1]]
	return(list(
		cases = c(
			rep(pre, lag)
			, 1+m*obs
		)
		, reporting = maxRep/m
	))
})

sim <- jags(model.file=input_files[[1]],
	data=data, inits=inits, 
	parameters = c("ker", "R0", "gen", "reporting", "obs"),
	n.chains = length(mult), n.iter = iterations
)

print(sim)
plot(sim)
# traceplot(sim)
