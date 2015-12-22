## forecasting simulator

##jags test 
bb <- sim$BUGSoutput$sims.list
ff <- matrix(0,nrow=252,ncol=100)

simforecasting <- function(ker, inc0, S0, S_last, alpha, BurEff, 
                        Burial=interventions$Burial, ETUEff, 
                        ETU=interventions$ETU, TracEff, 
                        Tracing=interventions$Tracing, hack=foieps, 
                        incShape, repMean, ka=kappa, repShape, future=forecast, 
                        preT=lag,numobs=length(obs)){
  predictions <- obsMean <- foi <- preIncShape <-preInc <- numeric(future)
  inc <- numeric(future+preT)
  inc[1:5] <- inc0
  S <- numeric(future+1)
  S[1] <- S_last
  for(j in 1:future){
  foi[j] <- (
    (ker[1]*inc[j+4] + ker[2]*inc[j+3] + ker[3]*inc[j+2] + ker[4]*inc[j+1] + ker[5]*inc[j])
    * ((S[j]/S[1])^(1+alpha))
    * exp(-BurEff*Burial[numobs+j])
    * exp(-ETUEff*ETU[numobs+j]/inc[j])
    * exp(-TracEff*Tracing[numobs+j])
    + hack
  )
  preIncShape[j] <- (incShape*foi[j]/repMean)/(incShape+foi[j]/repMean)
  
  preInc[j] <-rgamma(1, shape=preIncShape[j], rate=preIncShape[j]/foi[j])
  
  inc[preT+j] <- hack + S[j]*repMean*(1 - (1+preInc[j]/(S[j]*repMean*ka))^(-ka))
  
  S[j+1] <- hack + S[j] - inc[preT+j]/repMean
  
  obsMean[j] <- rgamma(1,shape=repShape, rate=repShape/inc[preT+j])
  predictions[j] <- rpois(1,obsMean[j])
}
  return(predictions)    
}

for(i in 1:252){
  ff[i,]<-simforecasting(ker=bb$ker[i,],
                                 inc0=bb$inc[i,36:40],
                                 S0=bb$S[i,1],
                                 S_last=bb$S[i,41],
                                 alpha=bb$alpha[i],
                                 BurEff=bb$BurEff[i],
                                 ETUEff=bb$ETUEff[i],
                                 TracEff=bb$TracEff[i],
                                 incShape=bb$incShape[i],
                                 repMean=bb$repMean[i],
                                 repShape=bb$repShape[i])
}

q <- c(0.05, 0.25, 0.5, 0.75, 0.95)

est<-t(apply(ff, 2, function(v){quantile(v, probs = q)}))
