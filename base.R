require("R2jags")

max = length(obs)
data <- list ("obs", "max")

# Parse the lag out of the model file name (clunky)
lag <- as.numeric(gsub("[A-Za-z_.]*", "", input_files[1]))
precases = c(rep(2, lag-1), 2)

inits1 <- { list(
	precases = precases, 
	postcases = 1+1*obs,
	reporting = 0.9
)}

inits2 <- { list(
	precases = precases, 
	postcases = 1+2*obs,
	reporting = 0.5
)}

inits3 <- { list(
	precases = precases, 
	postcases = 1+3*obs,
	reporting = 0.3
)}

inits = list(inits1, inits2, inits3)

sim <- jags(model.file=input_files[[1]],
	data=data, inits=inits, 
	parameters = c("ker", "R0", "gen", "reporting", "obs"),
	n.chains = 3, n.iter = iterations
)

print(sim)
plot(sim)
# traceplot(sim)
