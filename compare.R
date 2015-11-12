filetail <- sub("^T..[.]", "", rtargetname)
scenario <- sub("[.].*", "", filetail)

topQuant <- 4
qm <- (1+length(q))/2

print(length(obs))
print(nrow(est))

forecastPlot(length(obs), topQuant)
# forecastPlot(nrow(est), topQuant)
