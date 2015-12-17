## mike noNA jags ... load all the stuff from latest wrap.r

load('hi.params.RData')
load('test.params.RData')
load('T5.hi.params.RData')
load('T5.NIH4.hi.params.RData')
load('T5.NIH4.scen.RData')
load('T5.NIH4.int.RData')

iterations=8000
source("mikehi5stan.R")
