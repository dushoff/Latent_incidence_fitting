df <- data.frame(
	peakMed = parest["peakWeek", 3]
	, peak25 = parest["peakWeek", 2]
	, peak75 = parest["peakWeek", 4]
	, lastMed = parest["lastWeek", 3]
	, last25 = parest["lastWeek", 2]
	, last75 = parest["lastWeek", 4]
)

write.table(df, csvname, row.names=FALSE, col.names=FALSE, sep=",")
