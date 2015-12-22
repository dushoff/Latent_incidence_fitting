require("R2jags")

set.seed(seed)
if(forecast>0) forecastobs <- rep(1, forecast)

# Parse the lag out of the model file name (clunky)
lag <- 5
interventions <- interventions[1:length(c(obs,forecastobs)), ]

data <- with(interventions, list (
  obs = obs
  , max = length(obs)
#  , forecast = forecast
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
#    forecastobs = forecastobs
     genPos = gpMean
    , effRep = maxRep/m
    , preInc = c(
      rep(pre, lag)
      , 1+obs
    )
  ))
})


sim <- jags(model.file=input_files[[1]],
            data=data, inits=inits, 
            parameters = c(#"R0", "gen"
                            "ker", "alpha"
                           # "effRep", 
                            , "repMean"#, "RRprop"
                           , "ETUEff", "BurEff", "TracEff"
                           , "inc", "S", "incShape", "repShape"
                           #, "obs", "forecastobs"
                           # , "inc", "preInc", "foi"
            ),
            n.chains = length(inits), n.iter = iterations, n.thin=2
)

print(sim)
proc.time()
