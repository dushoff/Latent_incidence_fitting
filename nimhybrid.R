require(nimble)

load('hybrid.params.RData')
load('T3.hybrid.params.RData')
load('T3.NIH3.scen.RData')
source("nimhy.R")
lag <- 5
lagvec <- 1:lag
effRepHa <- effRepHShape/(1-effRepHmean)
effRepHb <- effRepHShape/effRepHmean

preExp <- preMean/(lag+preMean)

max <- length(obs)
data <- list ("obs", "max", "lag", "lagvec", "pop"
              , "foieps"
              , "kappa"
              , "effRepHa", "effRepHb"
              , "preExp"
              , "hetShape" , "hetMean"
              , "shapeH"
              , "Rshape", "Rmean"
              , "gpShape", "gpMean"
              , "gsShape", "gsMean"
)

pre <- 1+obs[[1]]
inits <- list(genPos = gpMean
              , effRep = maxRep
              , preInc = c(rep(pre, lag), 1+obs)
              , predobs = c(100,100,100,100,100)
              )




inits <- list()

constants <- list(lag=lag)

hybridMCMC <- MCMCsuite(code)