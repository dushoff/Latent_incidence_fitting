require(nimble)
#Setup -----
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

#creating the data/inits/constants -----
data <- list (obs=obs)

pre <- 1+obs[[1]]
inits <- list(genPos = gpMean
              , effRep = maxRep
              , preInc = c(rep(pre, lag), 1+obs)
#              , predobs = c(100,100,100,100,100)
              , repShape=1
              , incShape=1
              , alpha=1
              , RRprop=0.5
              , R0=1
              , genShape=1
              , obsMean=obs
              )

constants <- list(lag=lag
                  ,foieps=foieps
                  ,pop=pop
                  ,kappa=kappa
                  ,max=max
                  ,effRepHa=effRepHa
                  ,effRepHb=effRepHb 
                  ,hetShape=hetShape
                  ,hetMean=hetMean
                  ,Rshape=Rshape 
                  ,Rmean=Rmean
                  ,gpShape=gpShape
                  ,gpMean=gpMean
                  ,gsShape=gsShape 
                  ,gsMean=gsMean
                  ,preExp=preExp
                  ,shapeH=shapeH
                  ,lagvec=lagvec)

#nimble fit/mcmc ----

#it won't build the model, skip MCMCsuite first and try to build in nimble.

hybridMCMC <- MCMCsuite(code=nimcode,
                        data=data,
                        inits=inits,
                        constants=constants,
                        monitors=c('genPos'),
                        niter=9000,
                        MCMCs=c("jags"),
                        makePlot=TRUE,
                        savePlot=TRUE)



# mod <- nimbleModel(code=nimcode, data=data, inits=inits, constants=constants)
# 
# modmcmc <- buildMCMC(mod)
