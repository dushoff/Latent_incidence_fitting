iterations <- 2500
forecast <- 100
forecast <- 4
seed <- 2112

# Reporting and effective population hyper-parameters
effRepHmean <- 0.1
effRepHShape <- 0.5
hetShape <- 1
hetMean <- 0.1

# shape for the broad gammas underlying the beta-binomials
shapeH <- 0.1

# Shape for the kernel priors 
	
Rshape <- 0.1
Rmean <- 1
	
gpShape <- 0.1
gpMean <- 0.5
	
gsShape <- 0.1
gsMean <- 1

# Prior on mean cases in the pre-reporting period (these cause the first observed cases)
preMean <- 3

pop <- 6e6
foieps <- 0.001
kappa <- 3

mult <- 1:4
maxRep <- 0.75
