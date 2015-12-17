## mike noNA jags ... load all the stuff from latest wrap.r
t1 <- proc.time()
load('hi.params.RData')
load('test.params.RData')
load('T5.hi.params.RData')
load('T5.NIH4.hi.params.RData')
load('T5.NIH4.scen.RData')
load('T5.NIH4.int.RData')

iterations=5000
input_files <- c("mikehi5.bug")
source("mikehi5.R")
t2 <- proc.time()


