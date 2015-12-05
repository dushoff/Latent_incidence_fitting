filetail <- sub("^T..[.]", "", rtargetname)
scenario <- sub("[.].*", "", filetail)

topQuant <- 4
qm <- (1+length(q))/2

print(length(obs))
print(nrow(est))

forecastPlot(est, obs, length(obs), topQuant)
forecastPlot(est, obs, nrow(est), topQuant)
