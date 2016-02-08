df <- data.frame(
	parest["R0", 3]
	, parest["R0", 2]
	, parest["R0", 4]
	, 7*parest["gen", 3]
	, 7*parest["gen", 2]
	, 7*parest["gen", 4]
	, NA*parest["R0", 3]
	, NA*parest["R0", 2]
	, NA*parest["R0", 4]
	, parest["repMean", 3]
	, parest["repMean", 2]
	, parest["repMean", 4]
)

write.table(df, csvname, row.names=FALSE, col.names=FALSE, sep=",")
