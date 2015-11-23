
diffs <- est[, 4] - est[, 5]
currWeek <- min(which(diffs<0))-1
print(currWeek)
print(diffs)
print(est)

df <- data.frame(
	parest["peakSize", 3]
	, parest["peakSize", 2]
	, parest["peakSize", 4]
	, 0.76*parest["peakSize", 3]
	, 0.76*parest["peakSize", 2]
	, 0.76*parest["peakSize", 4]
	, est[currWeek+1, 3]
	, est[currWeek+1, 2]
	, est[currWeek+1, 4]
	, est[currWeek+2, 3]
	, est[currWeek+2, 2]
	, est[currWeek+2, 4]
	, est[currWeek+3, 3]
	, est[currWeek+3, 3]
	, est[currWeek+3, 2]
	, est[currWeek+3, 4]
	, est[currWeek+4, 3]
	, est[currWeek+4, 2]
	, est[currWeek+4, 4]
)

write.table(df, csvname, row.names=FALSE, col.names=FALSE, sep=",")
