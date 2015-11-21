require(R2jags)
require(rstan)
#Setup -----
load('hybrid.params.RData')
load('T3.hybrid.params.RData')
load('T3.NIH3.scen.RData')


set.seed(seed)

if(forecast>0) forecastobs <- c(rep(1, forecast))

numobs <- length(obs)
forecastnum <- length(forecastobs)

lag <- 5
lagvec <- 1:lag
effRepHa <- effRepHShape/(1-effRepHmean)
effRepHb <- effRepHShape/effRepHmean

preExp <- preMean/(lag+preMean)

numobs <- length(obs)

#creating the data/inits/constants -----
data <- list (obs=obs
              ,lag=lag
              ,foieps=foieps
              ,pop=pop
              ,kappa=kappa
              ,numobs=numobs
              ,forecastnum=forecastnum
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
inits <- list(list(genPos = gpMean
              , effRep = maxRep
              , forecastobs = forecastobs
              , preInc = c(rep(pre, lag), 1+obs,2+forecastobs)
              , repShape=1
              , incShape=1
              , alpha=1
              , RRprop=0.5
              , R0=1
              , genShape=1
              , obsMean=c(obs,forecastobs)
              , preker=c(1,2,3,4,5)
              , ker=c(1,2,3,4,5)
              ))

sim <- jags(model.file="mikehybrid.bug",
            data=data, inits=inits, 
            parameters = c("ker", "R0", "gen"
                           , "repMean"
                           , "effRep", "RRprop", "alpha"
                           , "obs", "forecastobs"
                           , "inc", "preInc", "foi"
            ),
            n.chains = 1, n.iter = 4000
)

sim2 <- stan(file="hybrid.stan",data=data,init=inits,
             pars=c("forecastobs"),
             iter=4000,
             chains=1)
