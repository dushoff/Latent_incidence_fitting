require(rstan)
set.seed(seed)
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


inits <- lapply (mult, function(m){
  pre <- 1+obs[[1]]
  return(list(
    forecastobs = forecastobs
    , genPos = gpMean
    , effRep = maxRep/m
    , preInc = c(
      rep(pre, lag)
      , 1+obs,1+forecastobs 
    )
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
})

sim <- stan(file="hi5.stan",data=data,init=inits,
            pars=c("obsMean","R0","BurEff","ETUEff","TracEff"),
            iter=iterations,
            chains=length(mult),thin = 2)

print(sim)
proc.time()