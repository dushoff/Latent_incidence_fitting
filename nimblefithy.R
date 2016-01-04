require(R2jags)
load('hybrid.params.RData')
load('T3.hybrid.params.RData')
load('T3.NIH3.scen.RData')

set.seed(seed)
# forecast=4
# if(forecast>0) forecastobs <- c(rep(1, forecast))
obs <- head(obs,9)
numobs <- length(obs)
# forecastnum <- length(forecastobs)

lag <- 2
lagvec <- 1:lag
effRepHa <- effRepHShape/(1-effRepHmean)
effRepHb <- effRepHShape/effRepHmean

preExp <- preMean/(lag+preMean)

numobs <- length(obs)

#creating the data/inits/constants -----
data <- list (obs=obs)
constants <-  list(lag=lag
                   ,foieps=foieps
                   ,pop=pop
                   ,kappa=kappa
                   ,numobs=numobs
                   #    ,forecastnum=forecastnum
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

pre <- 1+obs[[1]]
inits <- list(genPos = gpMean
              , effRep = maxRep
              #         , forecastobs = forecastobs
              , preInc = c(rep(pre, lag), 1+obs)#,2+forecastobs)
              , repShape=1
              , incShape=1
              , alpha=1
              , RRprop=0.5
              , R0=1
              , genShape=1
              , obsMean=c(obs)#,forecastobs)
)
# hybrid double forloop jags ----
library(nimble)

source('nimfithy.R')

sim <- MCMCsuite(code=nimcode,
                 data=data,
                 inits=inits,
                 constants=constants,
                 #                 stan_model="hybrid.stan",
                 MCMCs=c("jags"),
                 monitor=c("gen"),
                 calculateEfficiency=TRUE,
                 makePlot=TRUE,
                 niter=2000)
# 
# 
# mod <- nimbleModel(code=nimcode,
#                    constants = constants,
#                    data = data,
#                    inits = inits,
#                    check = TRUE
#                    )
# mod$getNodeNames()
# aa <- mod$getVarNames()
# for(i in 1:22){
#   print(mod[[aa[i]]])
# }
# 
# #cmod <- compileNimble(mod) works. why?
# 
# #cmod <- configureMCMC(mod,print=TRUE)
# 

