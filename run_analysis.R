

## Initiate by cleaning up the R session workspace. Helps avoid conflicts and errors due to preexisting variables in memory.
rm(list=ls())

## Setting the working directory to the directory where the data files have been extracted to manually
setwd("./gcdnov14/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#### Step 1. Merges the training and the test sets to create one data set.

## Read the data from the generic files
features <- read.table('./features.txt',header=FALSE)
activityType <- read.table('./activity_labels.txt',header=FALSE)

## Read the data from the files that pertain to the Training data and allocate names to columns
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain <- read.table('./train/x_train.txt',header=FALSE)
yTrain <- read.table('./train/y_train.txt',header=FALSE)
colnames(activityType) <- c('activityId','activityType')
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- features[,2] 
colnames(yTrain) <- "activityId"
trainingData <- cbind(yTrain,subjectTrain,xTrain)

## Read the data from the files that pertain to the Test data and allocate column names
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest <- read.table('./test/x_test.txt',header=FALSE)
yTest <- read.table('./test/y_test.txt',header=FALSE)
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"
testData <- cbind(yTest,subjectTest,xTest)

### Merging the Training and the Test sets to create one data set
finalData <- rbind(trainingData,testData)

#### Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Identify and extract columns that pertain to ID, mean() & stddev() columns
colNames <- colnames(finalData)
logicalVector <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))
finalData <- finalData[logicalVector==TRUE]

#### Step 3. Uses descriptive activity names to name the activities in the data set

# Allocate descriptive activity names using the names given in activity_labels.txt
finalData <- merge(finalData,activityType,by='activityId',all.x=TRUE)
colNames <- colnames(finalData)

#### Step 4. Appropriately labels the data set with descriptive variable names. 

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
        colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] <- gsub("\\()","",colNames[i])
        colNames[i] <- gsub("-mean","Mean",colNames[i])
        colNames[i] <- gsub("^(t)","time",colNames[i])
        colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] <- gsub("^(f)","freq",colNames[i])
        colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] <- gsub("-std$","StdDev",colNames[i])
        colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
}

colnames(finalData) <- colNames

#### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

finalDataNoActivityType <- finalData[,names(finalData) != 'activityType']

tidyData <- aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean)

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData <- merge(tidyData,activityType,by='activityId',all.x=TRUE)

# Export the resultant set for this final step 
write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t')