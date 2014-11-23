## Setting the working directory to the directory where the data files have been extracted to manually
setwd("C:/Users/Abhay Prasad/Documents/gcdnov14/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#### Step 1. Merges the training and the test sets to create one data set.

## Read the data from the generic files that are relevant to both the Train and Test sets
features <- read.table('./features.txt',header=FALSE)
# The features.txt file contains the names of the 561 parameters.
activityType <- read.table('./activity_labels.txt',header=FALSE)
#The data in the file activity_labels.txt is read into the array activityType. This array is of dimension 2X6 and contains the names of the 6 descriptive activities

## Read the data from the files that pertain to the Test data and allocate column names
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest <- read.table('./test/x_test.txt',header=FALSE)
yTest <- read.table('./test/y_test.txt',header=FALSE)
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"
testData <- cbind(yTest,subjectTest,xTest)

## Read the data from the files that pertain to the Training data and allocate names to columns
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain <- read.table('./train/x_train.txt',header=FALSE)
yTrain <- read.table('./train/y_train.txt',header=FALSE)
colnames(activityType) <- c('activityId','activityType')
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- features[,2] 
colnames(yTrain) <- "activityId"
trainingData <- cbind(yTrain,subjectTrain,xTrain)

### Merging the Training and the Test sets to create one data set using rbind function
mergedData <- rbind(trainingData,testData)

#### Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Identify and extract columns that pertain to ID, mean() & stddev() columns
colNames <- colnames(mergedData)
VectorforID <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))
mergedData <- mergedData[VectorforID==TRUE]

#### Step 3. Uses descriptive activity names to name the activities in the data set

# Allocate descriptive activity names using the names given in activity_labels.txt
mergedData <- merge(mergedData,activityType,by='activityId',all.x=TRUE)
colNames <- colnames(mergedData)

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

colnames(mergedData) <- colNames

#### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

sansActivityType <- mergedData[,names(mergedData) != 'activityType']

tidyDataSet <- aggregate(sansActivityType[,names(sansActivityType) != c('activityId','subjectId')],by=list(activityId=sansActivityType$activityId,subjectId = sansActivityType$subjectId),mean)

# Merging the tidyData with activityType to include descriptive acitvity names
tidyDataSet <- merge(tidyDataSet,activityType,by='activityId',all.x=TRUE)

# Export the resultant set for this final step 
write.table(tidyDataSet, './tidyDataSet.txt',row.names=FALSE,sep='\t')

