filetail <- sub("^T..[.]", "", rtargetname)
scenario <- sub("[.].*", "", filetail)

topQuant <- 4
qm <- (1+length(q))/2

forecastPlot(length(obs), topQuant)
