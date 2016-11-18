# Review criteria 
# 1. The submitted data set is tidy.
# 2. The Github repo contains the required scripts.
# 3. GitHub contains a code book that modifies and updates the available codebooks with the data to 
#    indicate all the variables and summaries calculated, along with units, and any other relevant information.
# 4. The README that explains the analysis files is clear and understandable.
# 5. The work submitted for this project is the work of the student who submitted it.

# You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work 
# that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.


# 1. Merges the training and the test sets to create one data set.

# Alle filer: "Y_test.txt", "Y_train.txt", "subject_train.txt", "subject_test.txt", "X_test.txt", "X_train.txt"

# "subject_train.txt" og "subject_test.txt": Indeholder til sammen nummeridentifikatoren på de 30 personer, som kan køres sammen med X-filerne
# "Y_test.txt" og "Y_train.txt" indeholder nummerreferencen til aktivtiteten, der kan ses activity_labels.txt
# "X_test.txt", "X_train.txt": Disse filer indeholder de egentlige træningsdata, der skal joines med subjetcs og activities (Y)


setwd("C:\\Users\\jjc\\Documents\\R-projekter\\DataScienceCoursera\\GettingCleaning\\data\\UCI HAR Dataset")
library(dplyr)

###### TEST DATA #####

# Read the file with subjects and give it the variable name "subject"
subject_test <- read.csv("./test/subject_test.txt", sep = " ", header = FALSE)
subject_test <- rename(subject_test, subject = V1)

# Read the file with activities and give it the variable name "activity"
activity_test <- read.csv("./test/y_test.txt", sep = " ", header = FALSE)
activity_test <- rename(activity_test, activity = V1)

# Read the file with all the accelerator data and change the variable names to the names from the features.txt file
acc_data_test <- read.table("./test/X_test.txt")
features <- read.csv("./features.txt", sep = " ", header = FALSE)
names(acc_data_test) <- features$V2 

# Combine the all the testdata files into one data frame
all_test_data <- cbind.data.frame(subject_test, activity_test, acc_data_test)

###### TRAINING DATA #####

# Read the file with subjects and give it the variable name "subject"
subject_train <- read.csv("./train/subject_train.txt", sep = " ", header = FALSE)
subject_train <- rename(subject_train, subject = V1)

# Read the file with activities and give it the variable name "activity"
activity_train <- read.csv("./train/y_train.txt", sep = " ", header = FALSE)
activity_train <- rename(activity_train, activity = V1)

# Read the file with all the accelerator data and change the variable names to the names from the features.txt file
acc_data_train <- read.table("./train/X_train.txt")
names(acc_data_train) <- features$V2 

# Combine the all the train data files into one data frame
all_train_data <- cbind.data.frame(subject_train, activity_train, acc_data_train)

###### TEST & TRAINING DATA COMBINED #####

all_data <- rbind(all_test_data, all_train_data)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Due to the formulation of the assignment I will limit my extraction to the variables indicating specifially a Mean()
# and exclude the MeanFreq() and the gravityMean
# length(grep("[Mm]ean\\(\\)|[Ss]td\\(\\)", features$V2, value = TRUE))


meanMeasurements <- all_data[, c("subject", "activity", grep("[Mm]ean\\(\\)|[Ss]td\\(\\)", features$V2, value = TRUE))]

# 3. Uses descriptive activity names to name the activities in the data set
# Read the file with the descriptive activity labels from activity_labels.txt and change the variable names
descr_act_names <- read.csv("./activity_labels.txt", sep = " ", header = FALSE)
descr_act_names <- rename(descr_act_names, activity = V1, activityname = V2)

# I merge the complete datafile with all the mean and std variables with the activity label file and get the new column with the activity label
meanMeasurements <- merge(meanMeasurements, descr_act_names, by.x = "activity", by.y = "activity")


# 4. Appropriately labels the data set with descriptive variable names.
# I already labelled the variables in step 1 in order to easily extract the std and mean columns of the dataset in step 2
# In week 4 in the course the following guidelines were given regarding naming variables
# All lower case when possible
# Descriptive names
# Not duplicated
# Not have underscores or dots or white spaces

# I check for underscores or dots or white spaces in the variable names
length(grep("_|\\.| ", names(meanMeasurements), value = TRUE))
# [1] 0

# Following the above guidelines the only obvious change to make to the variable names given from features.txt is to convert them to all lower cases
meanMeasurementsToLower <- meanMeasurements
names(meanMeasurementsToLower) <- tolower(names(meanMeasurementsToLower))


# 5. From the data set in step 4, creates a second, independent tidy data 
#    set with the average of each variable for each activity and each subject.

library(plyr)
groupColumns <- c("subject", "activity", "activityname")
dataColumns <- grep("[Mm]ean\\(\\)|[Ss]td\\(\\)", names(meanMeasurementsToLower), value = TRUE)
groupsMeasurementsAvg1 <- ddply(meanMeasurementsToLower, groupColumns, function(x) colMeans(x[dataColumns]))
head(groupsMeasurementsAvg1, 10)

write.table(groupsMeasurementsAvg1, file = "./mysubmissionWeek4GettigCleaningData.txt", row.names = FALSE, quote = FALSE) 

# alternative method resultning in the same averages
groupsMeasurementsAvg2 <- aggregate(meanMeasurementsToLower, by = list(meanMeasurementsToLower$subject, meanMeasurementsToLower$activity), FUN = "mean", simplify = TRUE)
groupsMeasurementsAvg2 <- arrange(groupsMeasurementsAvg2, subject, activity)
head(groupsMeasurementsAvg2, 10)
