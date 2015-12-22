## forecasting simulator

##jags test 

dat <- sim$BUGSoutput$mean



simforecasting <- function(ker, inc0, S0, alpha, BurEff, 
                        Burial, ETUEff, ETU, TracEff, Tracing, foieps, 
                        incShape, repMean, kappa, repShape, forecast, lag, numobs){
  predictions <- obsMean <- foi <- preIncShape <-preInc <- numeric(forecast)
  inc <- numeric(forecast+numobs+lag)
  inc[1:length(inc0)] <- inc0
  S <- numeric(forecast+numobs+lag)
  S[1:length(S0)] <- S0
  for(j in 1:forecast){
  foi[j] <- (
    (ker[1]*inc[numobs+j+4] + ker[2]*inc[numobs+j+3] + ker[3]*inc[numobs+j+2] + ker[4]*inc[numobs+j+1] + ker[5]*inc[numobs+j])
    * ((S[numobs+lag+j]/S[1])^(1+alpha))
    * exp(-BurEff*Burial[numobs+j])
    * exp(-ETUEff*ETU[numobs+j]/inc[numobs+j])
    * exp(-TracEff*Tracing[numobs+j])
    + foieps
  )
  preIncShape[j] <- (incShape*foi[j]/repMean)/(incShape+foi[j]/repMean)
  
  preInc[j] <-rgamma(1, shape=preIncShape[j], rate=preIncShape[j]/foi[j])
  
  inc[lag+numobs+j] <- foieps + S[lag+numobs+j]*repMean*(1 - (1+preInc[j]/(S[lag+numobs+j]*repMean*kappa))^(-kappa))
  
  S[lag+numobs+j+1] <- foieps + S[lag+numobs+j] - inc[numobs+lag+j]/repMean
  
  obsMean[j] <- rgamma(1,shape=repShape, rate=repShape/inc[numobs+lag+j])
  predictions[j] <- rpois(1,obsMean[j])
}
  return(predictions)    
}

jf <- (simforecasting(ker=dat$ker
                      , inc0 = dat$inc
                      , S0 = dat$S
                      , alpha = dat$alpha
              #        , S_last = tail(dat$S,1)
                      , BurEff = dat$BurEff
                      , Burial = interventions$Burial
                      , ETUEff = dat$BurEff
                      , ETU = interventions$ETU
                      , TracEff = dat$TracEff
                      , Tracing = interventions$Tracing
                      , foieps = foieps
                      , incShape = dat$incShape
                      , repMean = dat$repMean
                      , kappa = kappa 
                      , repShape = dat$repShape
                      , forecast = forecast
                      , lag = lag 
                      , numobs = length(obs)
))

print(jf)