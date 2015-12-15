##initial setup ----
# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('hi.params.RData')
load('test.params.RData')
load('T5.hi.params.RData')
load('T5.NIH4.hi.params.RData')
load('T5.NIH4.scen.RData')
load('T5.NIH4.int.RData')


input_files <- c("hi5.autobug")
rtargetname <- "T5test.NIH4.hi"
pdfname <- "T5test.NIH4.hi.Rout.pdf"
csvname <- "T5test.NIH4.hi.Rout.csv"

# Nimble setup -----
require(nimble)
require("R2jags")

set.seed(seed)
lag <- 5
interventions <- interventions[1:length(obs), ]

nimdata <- list(obs=obs)
  
nimconstants <- with(interventions,list(max = length(obs)
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

pre = 1+obs[[1]]

niminits <- list(genPos = gpMean
  , effRep = maxRep/1
  , preInc = c(rep(pre, lag), 1+obs)
  , repShape = shapeH
  , incShape = shapeH
  , alpha = hetShape
  , RRprop = 0.7
  , R0 = 1
  , genShape = gsShape
  , BurEff = BurShape
  , ETUEff = ETUshape
  , TracEff = TracShape
  , obsMean = obs
)


source("nimhi.R")

sim <- MCMCsuite(code = nimcode
  , data = nimdata
  , inits = niminits
  , constants = nimconstants
  , MCMCs = c("jags","nimble")
  , monitors = c("gen")
  , calculateEfficiency = TRUE
  , niter = 4000
  , makePlot = TRUE)

mod <- nimbleModel(code=nimcode
  , constants = nimconstants
  , data = nimdata
  , inits = niminits
  , check = FALSE)

cmod <- configureMCMC(mod,print=TRUE,)

cmod <- configureMCMC(mod,print=TRUE)
