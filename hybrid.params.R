iterations <- 100000
iterations <- 100

# Reporting and effective population hyper-parameters
effRepHmean <- 0.5
effRepHShape <- 1.5
hetShape <- 1
hetMean <- 0.1

# shape for the broad gammas underlying the beta-binomials
shapeH <- 0.1

# Shape for the kernel priors and mean of their _sum_ (R0)
kerShape <- 0.1
kerMean <- 1

# Prior on mean cases in the pre-reporting period (these cause the first observed cases)
preMean <- 3

pop <- 6e6
foieps <- 0.001
kappa <- 3

mult <- 1:4
maxRep <- 0.75
