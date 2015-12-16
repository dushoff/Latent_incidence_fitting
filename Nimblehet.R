library(nimble)
load('het.params.RData')
load('NIH3.het.params.RData')
load('NIH3.scen.RData')
source("nimhet.R")

set.seed(2112)
obs <- obs[!is.na(obs)]
max <- length(obs)
lag <- 5
lagvec <- c(1:5)

repHa <- repHShape/(1-repHmean)
repHb <- repHShape/repHmean

effPropHa <- effPropHShape/(1-effPropHmean)
effPropHb <- effPropHShape/effPropHmean

preExp <- preMean/(lag+preMean)

nimdata <- list(obs=obs)

nimconstants <- list(max=max
                     , lag=lag
                     , lagvec = lagvec
                     , pop = pop
                     , foieps = foieps
                     , kappa = kappa
                     , repHa = repHa
                     , repHb = repHb
                     , effPropHa = effPropHa
                     , effPropHb = effPropHb
                     , preExp = preExp
                     , kerShape = kerShape
                     , kerMean = kerMean
                     , hetShape = hetShape
                     , hetMean = hetMean
                     , shapeH = shapeH)

pre <- 1 + obs[[1]]
niminits <- list(inc = c(rep(pre, lag), 1+obs)
    , repMean = maxRep
    , ker = c(rep(1/lag, lag))
    , repShape = 0.5
    , incShape = 0.5
    , alpha = 0.5
    , effProp = 0.5
    , S0 = round(0.5*pop)
    , repa = rep(1/max,max)
    , repb = rep(1/max,max)
    , S = c(rep(pre, lag), 1+obs)
    , foi = obs
    , inca = rep(1/max,max)
    , incb = rep(1/max,max)
)

sim <- MCMCsuite(code = nimcode
                 , data = nimdata
                 , inits = niminits
                 , constants = nimconstants
                 , MCMCs = c("jags","nimble")
                 , monitors = c("R0")
                 , niter = 4000
                 , calculateEfficiency = TRUE
                 , makePlot = TRUE
)
# 
# mod <- nimbleModel(code = nimcode, data=nimdata, inits = niminits,
#                    constants = nimconstants)
# 
# configmod <- configureMCMC(mod,print=TRUE)
