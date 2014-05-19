#################################################################################
# IMPORTANT NOTES:
# This script assumes that the zipped datafile ("getdata-projectfiles-UCI HAR Dataset.zip") 
# downloaded from the link given in Coursera project instructions is present under the working directory
#
# Package 'reshape2' is required for this script - please install it before running
# the script
#
# The script performs the steps 1-5 of the project instructions in a slightly different 
# order for the purpose of simplicity and completeness
#################################################################################

#################################################################################
# Unzipping the zip data file downloaded from the link given in Coursera project instructions
#################################################################################
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

#################################################################################
# The required files are loaded in data frames
# 'features.txt' file was used for giving column names of X_{train,test} files
# 'activity_labels.txt' file was used for giving activity names based on the 
# activity codes in y_{train,test} files 
#################################################################################
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("ActivityCode", "Activity")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

X_ALL <- rbind(X_train, X_test)
names(X_ALL) <- features$V2

y_ALL <- rbind(y_train, y_test)
names(y_ALL) <- "ActivityCode"

subject_ALL <- rbind(subject_train, subject_test)
names(subject_ALL) <- "Subject"

#################################################################################
# As per the step 2 of the project instructions, only columns with substrings 'mean()'
# or 'std()' in the names are retained from X_{train,test} files
# 
# Please note the columns for meanFreq() were specifically excluded. This follows
# as per the 'features_info.txt' which states:
# "meanFreq(): Weighted average of the frequency components to obtain a mean frequency"
# thus columns with 'meanFreq()' substring are assumed as a different measurement 
# and not a mean, because the corresponding standard deviation measurement is also lacking
#################################################################################

MeanCols <- grep("mean()", features$V2)
MeanFreqCols <- grep("meanFreq()", features$V2)
StDevCols <- grep("std()", features$V2)
ReqCols <- sort(c(MeanCols[!(MeanCols %in% MeanFreqCols)], StDevCols))

#################################################################################
# After the next command, 'data_ALL' data frame will conform to the project 
# instructions 1-2 and 4
# At this point, the table will contain the Activity Codes (e.g. 1 through 6) 
# instead of the descriptive activity names (e.g. Walking etc)
#################################################################################
data_ALL_temp <- cbind(subject_ALL, y_ALL, X_ALL[,ReqCols])

#################################################################################
# After the next three commands, the 'data_ALL' will contain the descriptive 
# activity names (e.g. Walking etc). The column for Activity Codes (e.g. 1 through 6) 
# is removed as it is deemed redundant at this point
#################################################################################
data_ALL <- merge(data_ALL_temp, activity_labels, by.x="ActivityCode", by.y="ActivityCode", all=FALSE)
data_ALL$ActivityCode <- NULL
data_ALL <- data_ALL[,c(1, 68, 2:67)]
#################################################################################
# !!!! Now the 'data_ALL' data frame conforms to project instructions 1-4 !!!!
#################################################################################

#################################################################################
# The following commands are used to create a tidy dataset as per step 5, from the 
# dataset obtained at the end of steps 1-4
#################################################################################
library(reshape2)
data_ALL_Melt  <- melt(data_ALL,id=c("Subject", "Activity"),measure.vars=3:68)
data_ALL_Melt$TempVar <- paste(data_ALL_Melt$Subject, data_ALL_Melt$Activity, sep=",")
tidyData <- dcast(data_ALL_Melt, TempVar ~ variable, mean)

tidyData$Subject <- as.numeric(lapply(strsplit(as.character(tidyData$TempVar), "\\,"), "[", 1))
tidyData$Activity <- as.character(lapply(strsplit(as.character(tidyData$TempVar), "\\,"), "[", 2))

tidyData <- tidyData[,c(68, 69, 1:67)]
tidyData$TempVar <- NULL

tidyData <- tidyData[order(tidyData[,1], tidyData[,2]),]
rownames(tidyData) <- seq(1:nrow(tidyData))
#################################################################################
# !!!! Now the 'tidyData' data frame conforms to project instruction 5 !!!!
# Please note the values in the variables other than Subject and Activity are mean 
# values of the variable for a given subject and given activity - however the original
# variable (column name) has been retained
#
# The next command outputs the tidy data file output
#################################################################################
write.table(tidyData, "tidy_data.txt")