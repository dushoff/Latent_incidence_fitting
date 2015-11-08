require("R2jags")

set.seed(2112)

max <- length(obs)

# Parse the lag out of the model file name (clunky)
lag <- as.numeric(gsub("[A-Za-z_.]*", "", input_files[1]))
lagvec <- 1:lag

### Make parameters in bug form
repHa <- repHShape/(1-repHmean)
repHb <- repHShape/repHmean

effPropHa <- effPropHShape/(1-effPropHmean)
effPropHb <- effPropHShape/effPropHmean

preExp <- preMean/(lag+preMean)

data <- list ("obs", "max", "lag", "lagvec", "pop"
	, "foieps"
	, "kappa"
	, "repHa", "repHb"
	, "effPropHa", "effPropHb"
	, "preExp"
	, "kerShape" , "kerMean"
	, "shapeH"
)

inits <- lapply (mult, function(m){
	pre <- 1+m*obs[[1]]
	return(list(
		inc = c(
			rep(pre, lag)
			, 1+m*obs
		)
		, repMean = maxRep/m
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
		# , "S", "inc", "incMean"
	),
	n.chains = length(mult), n.iter = iterations
)

print(sim)
plot(sim)
# traceplot(sim)

proc.time()
