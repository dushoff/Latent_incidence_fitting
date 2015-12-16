iterations <- 100
iterations <- 5000

# Reporting and effective population hyper-parameters
repHmean <- 0.5
repHShape <- 0.5
effPropHmean <- 0.5
effPropHShape <- 0.5
hetShape <- 0.1
hetMean <- 0.5

# shape for the broad gammas underlying the beta-binomials
shapeH <- 0.01

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
