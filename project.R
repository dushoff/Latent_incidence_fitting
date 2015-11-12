
filetail <- sub("^T.[.]", "", rtargetname)
scenario <- sub("[.].*", "", filetail)

topQuant <- 4
shortWindow <- 4
qm <- (1+length(q))/2
forecastPlot(shortWindow+sum(!is.na(obs)), topQuant)
forecastPlot(nrow(est), topQuant)
