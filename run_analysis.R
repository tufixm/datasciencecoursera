subjectTrainData = read.table("./train/subject_train.txt")
subjectTestData = read.table("./test/subject_test.txt")

xTrainData = read.table("./train/X_train.txt")
yTrainData = read.table("./train/y_train.txt")

xTestData = read.table("./test/X_test.txt")
yTestData = read.table("./test/y_test.txt")

featuresData = read.table("features.txt", stringsAsFactors=FALSE)
activityLabels = read.table("activity_labels.txt", stringsAsFactors=FALSE)

sum(is.na(xTrainData))
sum(is.na(yTrainData))
sum(is.na(xTestData))
sum(is.na(yTestData))

xData = rbind(xTrainData, xTestData)
yData = rbind(yTrainData, yTestData)
subjectData = rbind(subjectTrainData, subjectTestData)

meanStdCols = grep("(-mean\\(\\))|(-std\\(\\))", featuresData$V2)
selected.x.data = xData[, meanStdCols]

colnames(selected.x.data) = featuresData$V2[meanStdCols]
colnames(subjectData) = c("SubjectId")
colnames(yData) = c("Activity")

data.full = cbind(subjectData, selected.x.data, yData)
data.final = merge(data.full, activityLabels, by.x = "Activity", by.y = "V1")[, -1]
colnames(data.final)[68] = "Activity"

agg.data.final = aggregate(data.final[, 2:67], by = data.final[,c("SubjectId", "Activity")], mean)
