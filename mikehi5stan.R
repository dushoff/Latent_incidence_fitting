require(rstan)
set.seed(seed)
forecast=4
if(forecast>0) forecastobs <- c(rep(1, forecast))

numobs <- length(obs)

lag <- 5
interventions <- interventions[1:length(c(obs,forecastobs)), ]

lagvec <- 1:lag
numobs <- length(obs)

#creating the data/inits/constants -----
data <- with(interventions, list (
  obs = obs
  , numobs = length(obs)
  , forecast = forecast
  , lag = lag
  , lagvec = 1:lag
  , pop = pop
  , foieps = foieps
  , kappa = kappa
  , effRepHa = effRepHShape/(1-effRepHmean)
  , effRepHb = effRepHShape/effRepHmean
  , preExp = preMean/(lag+preMean)
  , hetShape = hetShape
  , hetMean = hetMean
  , shapeH = shapeH
  , Rshape = Rshape
  , Rmean = Rmean
  , gpShape = gpShape
  , gpMean = gpMean
  , gsShape = gsShape
  , gsMean = gsMean
  , Burial = Burial, BurMean=BurMean, BurShape=BurShape
  , ETU = ETU, ETUmean=ETUmean, ETUshape=ETUshape
  , Tracing = Tracing, TracMean=TracMean, TracShape=TracShape
))

pre <- 1+obs[[1]]
inits <- list(list(genPos = gpMean
                   , effRep = maxRep
                   , forecastobs = forecastobs
                   , preInc = c(rep(pre, lag), 1+obs,2+forecastobs)
                   , repShape=shapeH
                   , incShape=shapeH
                   , alpha=hetShape
                   , RRprop=0.5
                   , R0=1
                   , genShape=gsShape
                   , obsMean=c(obs,forecastobs)
                   , preker = c(rep(0.5,5))
                   , BurEff = BurShape
                   , ETUEff = ETUshape
                   , TracEff = TracShape
))
# hybrid stan----
sim <- stan(file="hi5.stan",data=data,init=inits,
            pars=c("forecastobs"),
            iter=500,
            chains=1)

print(sim)
