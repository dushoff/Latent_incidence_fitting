q <- c(0.05, 0.25, 0.5, 0.75, 0.95)

m <- as.data.frame(sim)
  
tstats <- as.data.frame(t(apply(m, 1, function(r){
  obs <- r[grepl("forecastobs", names(r))]
  return(c(
    finalSize = sum(obs) 
    , peakSize = max(obs)
    , peakWeek = which.max(obs)
    , endWeek = suppressWarnings(min(which(obs==0)))
  ))
})))
names(tstats) <- c("finalSize", "peakSize", "peakWeek", "endWeek")

m <- cbind(m, tstats)

print(summary(m))


allest <- t(apply(m, 2, function(v){quantile(v, probs = q)}))
oc <- grepl("forecastobs", row.names(allest))

est <- allest[oc, ]
obsdat <- matrix(rep(obs,each=5),ncol=5,nrow=length(obs),byrow=TRUE)
est<-rbind(obsdat,est)
parest <- allest[!oc, ]

print(parest)

