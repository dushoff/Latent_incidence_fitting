nimcode <- nimbleCode(
{
    # Dispersion
    repMean ~ dbeta(repHa, repHb)
    repShape ~ dgamma(shapeH, shapeH)
    incShape ~  dgamma(shapeH, shapeH)
    
    # Effective population size and response
    alpha ~ dgamma(hetShape, hetShape/hetMean)
    effProp ~ dbeta(effPropHa, effPropHb)
    S0 ~ dbin(effProp,pop)
    S[1] <- S0
    
    # Pre-observation and kernel
    for (j in 1:lag){
      ker[j] ~ dgamma(kerShape, lag*kerShape/kerMean)
      inc[j] ~ dnegbin(preExp, 1)
      S[j+1] <- S[j] - inc[j]
    }
    
    for (j in 1:max){
      # _FOICHAIN_ is a magic word that's expanded in the autobug
      foi[j] <- ((ker[1]*inc[j+4] + ker[2]*inc[j+3] + ker[3]*inc[j+2] + ker[4]*inc[j+1] + ker[5]*inc[j+0])*pow(S[lag+j]/S[1], -alpha) + foieps)/S[1]
      incMean[j] <- 1 - pow(1+foi[j]/kappa, -kappa) 
      inca[j] ~ dgamma(incShape/(1-incMean[j]), 1)
      incb[j] ~ dgamma(incShape/incMean[j], 1)
      inc[lag+j] ~ dbin(inca[j]/(inca[j]+incb[j]), S[lag+j])
      
      S[lag+j+1] <- S[lag+j] - inc[lag+j]
      
      # Observation process
      # rep[j] ~ dbeta(repShape/repMean, repShape/(1-repMean))
      repa[j] ~ dgamma(repShape/(1-repMean), 1)
      repb[j] ~ dgamma(repShape/repMean, 1)
      obs[j] ~ dbin(repa[j]/(repa[j]+repb[j]), inc[lag+j])
    }
    
    R0 <- sum(ker[1:5])
#    gtot <- inprod(lagvec[1:5],tempker[1:5])
    gtot <- ker[1] + 2*ker[2] + 3*ker[3] + 4*ker[4] + 5*ker[5]
    gen <- (gtot/R0)
  }
  
)