df <- data.frame(
	median = parest["peakWeek", 3]
	, low = parest["peakWeek", 2]
	, high = parest["peakWeek", 4]
)

write.table(df, csvname, row.names=FALSE, col.names=FALSE, sep=",")
