# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('hybrid.params.RData')
load('T3.hybrid.params.RData')
load('T3.NIH3.scen.RData')


input_files <- c("mikehybrid.bug")

source('hybridnoNA.R', echo=TRUE)
# Begin RR postscript

# If you see this in your terminal, the R script T3.NIH1.hybrid.wrap.R (or something it called) did not close properly
save.image(file="T3.mike.hybrid.RData")
