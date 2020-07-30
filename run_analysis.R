##download file and putting in folder
if(!file.exists("./GCPROJDATA")){dir.create("./GCPROJDATA")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./GCPROJDATA/Data.zip")

##unzip the file
unzip(zipfile = "./GCPROJDATA/Data.zip", exdir = "./GCPROJDATA")

##unziped file put in UCI HAR Dataset
path_data<- file.path("./GCPROJDATA", "UCI HAR Dataset")

##read the activity file
activitytesty <- read.table(file.path(path_data, "test", "Y_test.txt"), header = FALSE)
activitytrainy <- read.table(file.path(path_data, "train", "Y_train.txt"), header = FALSE)

##read the subject files
subjecttest <- read.table(file.path(path_data, "test", "subject_test.txt"), header = FALSE)
subjecttrain <- read.table(file.path(path_data, "train", "subject_train.txt"), header = FALSE)

##read the features files
featuretestx <-read.table(file.path(path_data, "test", "X_test.txt"), header = FALSE)
featuretrainx <- read.table(file.path(path_data, "train", "X_train.txt"), header = FALSE)

##merges the training and the test sets to create one data set

##1.concatenate the data tables by rows
subject <- rbind(subjecttrain, subjecttest)
activity <- rbind(activitytrainy, activitytesty)
feature <- rbind(featuretrainx, featuretestx)

##2.naming the columns
Featurenames <- read.table(file.path(path_data, "features.txt"), header = FALSE)
names(feature) <- Featurenames$V2

##3.merge the data
names(activity) <- c("Activity")
names(subject) <- c("Subject")
DATAcombine <- cbind(subject, activity)
DATA <- cbind(feature, DATAcombine)

##PART2 extracts only the measurements of the means and SD for each measurement
columnwithmeansd <- Featurenames$V2[grep("mean\\(\\)|std\\(\\)", Featurenames$V2)]
selectednames <- c(as.character(columnwithmeansd), "Subject", "Activity")
DATA <- subset(DATA, select = selectednames)

##PART3- Uses the descriptive activity names to the name the activities in the data set

##activity field in exctrtdata is numeric type we need to change it to character so that it can accept
##ctivity names . The activity names are from activitylabel
activitylabels <- read.table(file.path(path_data, "activity_labels.txt"), header = FALSE)
DATA$Activity <- as.character(DATA$Activity)
for (i in 1:6){
  DATA$Activity[DATA$Activity==i] <- as.character(activitylabels[i,2])
}

##PART-4 Appropriately labels the data set with descriptive variable names.

##namres of features will be labelled using descriptive variable names
names(DATA) <- gsub("^t", "time", names(DATA))
names(DATA) <- gsub("^f", "frequency", names(DATA))
names(DATA) <- gsub("^Acc", "Accelerometer", names(DATA))
names(DATA) <- gsub("^Gyro", "Gyroscope", names(DATA))
names(DATA) <- gsub("^Mag", "Magnitude", names(DATA))
names(DATA) <- gsub("^BodyBody", "Body", names(DATA))

##check 
names(DATA)

##PART-5 creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##independent tidy data set will be created with the average of each variable for each activity and each subject based on the data set in step 4
library(plyr)
DATA2 <- aggregate(.~Subject + Activity, DATA, mean)
DATA2 <- DATA2[order(DATA2$Subject, DATA2$Activity),]
write.table(DATA2, file = "tidydata.txt", row.names = FALSE)









