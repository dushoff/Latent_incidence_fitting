nimcode <- nimbleCode({
# Dispersion----
repShape ~ dgamma(shapeH, shapeH)
incShape ~  dgamma(shapeH, shapeH)
  

# Effective population size and response----
alpha ~ dgamma(hetShape, hetShape/hetMean)
effRep ~ dbeta(effRepHa, effRepHb)
RRprop ~ dunif(0, 1)
effProp <- pow(effRep,1-RRprop)
repMean <- pow(effRep,RRprop)
  
S[1] <- effProp*pop
  

# Kernel and pre-observation period ----
R0 ~ dgamma(Rshape, Rshape/Rmean)
  
genPos ~ dbeta(gpShape/(1-gpMean), gpShape/gpMean)
genShape ~ dgamma(gsShape, gsShape/gsMean)
  
for (j in 1:lag){
    preker[j] <- pow(j, genShape/(1-genPos))*pow(lag-j+1,
                                                 genShape/genPos)
    ker[j] <- R0*preker[j]/sum(preker[1:lag])
    preInc[j] ~ dexp(preExp)
  }
  

# Observation period ----
  for (j in 1:numobs){
    # _FOICHAIN_ is a magic word that's expanded in the autobug
    ## foi is the expected number _reported_. 
    ## e.g. (ker[1]*inc[j+2] + ker[2]*inc[j+1] + ker[3]*inc[j+0])
    foi[j] <- (ker[1]*inc[j+4] + ker[2]*inc[j+3] + ker[3]*inc[j+2] + ker[4]*inc[j+1] + ker[5]*inc[j+0])*pow(S[lag+j]/S[1], 1+alpha)+foieps
    
    ## inc is really "shadow" incidence:
    ##  the expected number reported _given_ the true incidence
    ## preInc is calculated first to make sure inc is not too big
    ## (cannot exceed S[lag+j]*repMean)
    
    preIncShape[j] <- (incShape*foi[j]/repMean)/(incShape+foi[j]/repMean)
    preInc[lag+j] ~ dgamma(preIncShape[j], preIncShape[j]/foi[j])
    
    # Observation process
    obsMean[j] ~ dgamma(repShape, repShape/inc[lag+j])
    obs[j] ~ dpois(obsMean[j])
  }
  

# Updates that are consistent over both periods----
  for(j in 1:(lag+numobs)){
    S[j+1] <- foieps + S[j] - inc[j]/repMean
    
    inc[j] <- foieps + S[j]*repMean*
      (1 - pow(1+preInc[j]/(S[j]*repMean*kappa), -kappa)) 
  }

  for(j in 1:forecastnum){
    S[lag+numobs+j+1] <- foieps + S[lag+numobs+j] - inc[lag+numobs+j]/repMean
    
    inc[lag+numobs+j] <- foieps + S[lag+numobs+j]*repMean*
      (1 - pow(1+preInc[lag+numobs+j]/(S[lag+numobs+j]*repMean*kappa), -kappa))
    
    foi[numobs+j] <- (ker[1]*inc[numobs+j+4] + ker[2]*inc[numobs+j+3] + ker[3]*inc[numobs+j+2] + ker[4]*inc[numobs+j+1] + ker[5]*inc[numobs+j+0])*pow(S[numobs+lag+j]/S[1], 1+alpha)+foieps
    
    ## inc is really "shadow" incidence:
    ##  the expected number reported _given_ the true incidence
    ## preInc is calculated first to make sure inc is not too big
    ## (cannot exceed S[lag+j]*repMean)
    
    preIncShape[numobs+j] <- (incShape*foi[numobs+j]/repMean)/(incShape+foi[numobs+j]/repMean)
    preInc[numobs+lag+j] ~ dgamma(preIncShape[numobs+j], preIncShape[numobs+j]/foi[numobs+j])
    
    # Observation process
    obsMean[numobs+j] ~ dgamma(repShape, repShape/inc[numobs+lag+j])
    forecastobs[j] ~ dpois(obsMean[numobs+j])
    
  }
  

# Summary parameters----
  gen <- (lagvec[1]*ker[1]+lagvec[2]*ker[2]+
            lagvec[3]*ker[3]+lagvec[4]*ker[4]+lagvec[5]*ker[5])/R0
  })