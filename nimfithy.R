nimcode <- nimbleCode({
  # Dispersion----
  repShape ~ dgamma(shapeH, shapeH)
  incShape ~  dgamma(shapeH, shapeH)

  # Effective population size and response----
  alpha ~ dgamma(hetShape, hetShape/hetMean)
  effRep ~ dbeta(effRepHa, effRepHb)
  RRprop ~ dunif(0,1)

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
    
    S[j+1] <- foieps + S[j] - inc[j]/repMean
    inc[j] <- foieps + S[j]*repMean*
      (1 - pow(1+preInc[j]/(S[j]*repMean*kappa), -kappa)) 
  }
  
  
  # Observation period ----
  for (j in 1:numobs){
    # _FOICHAIN_ is a magic word that's expanded in the autobug
    ## foi is the expected number _reported_. 
    ## e.g. (ker[1]*inc[j+2] + ker[2]*inc[j+1] + ker[3]*inc[j+0])
    foi[j] <- (ker[1]*inc[j+1] + ker[2]*inc[j+0])*pow(S[lag+j]/S[1], 1+alpha)+foieps
    
    ## inc is really "shadow" incidence:
    ##  the expected number reported _given_ the true incidence
    ## preInc is calculated first to make sure inc is not too big
    ## (cannot exceed S[lag+j]*repMean)
    
    preIncShape[j] <- (incShape*foi[j]/repMean)/(incShape+foi[j]/repMean)
    preInc[lag+j] ~ dgamma(preIncShape[j], scale=foi[j]/preIncShape[j])
    
    # Observation process

    obsMean[j] ~ dgamma(repShape, rate=inc[lag+j]/repShape)
    obs[j] ~ dpois(obsMean[j])
    
    S[lag+j+1] <- foieps + S[lag+j] - inc[lag+j]/repMean
    inc[lag+j] <- foieps + S[lag+j]*repMean*
      (1 - pow(1+preInc[lag+j]/(S[lag+j]*repMean*kappa), -kappa)) 
  }
  
  # Summary parameters----
  gen <- (lagvec[1]*ker[1]+lagvec[2]*ker[2])/R0
})