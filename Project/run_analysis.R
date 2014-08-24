library(gdata)
library(reshape2)
library(plyr)

#1 Merge the training and the test sets to create one data set
# and
#4 Appropriately label the data set with descriptive variable names

# Reading in the features
features <- read.table("./ucihar/UCI HAR Dataset/features.txt")

# Updating the variable names to descriptive names
features[,2] <- gsub("tBody", "TimeBody",features[,2])
features[,2] <- gsub("tGravity", "TimeGravity",features[,2])
features[,2] <- gsub("fBody", "FreqBody",features[,2])
features[,2] <- gsub("\\()", "",features[,2])

# Reading in the activty names
activity_names <- read.table("./ucihar/UCI HAR Dataset/activity_labels.txt")

# Reading in the train dataset
trainset_data <- read.table("./ucihar/UCI HAR Dataset/train/X_train.txt", col.names= features[,2])
train_activity_label <- read.table("./ucihar/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./ucihar/UCI HAR Dataset/train/subject_train.txt")

# Adding the two columns for subject and activity label to the train dataset
trainset_data <- cbind(train_activity_label, trainset_data)
trainset_data <- cbind(train_subject, trainset_data)

# Reading in the test dataset
testset_data <- read.table("./ucihar/UCI HAR Dataset/test/X_test.txt", col.names= features[,2])
test_activity_label <- read.table("./ucihar/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./ucihar/UCI HAR Dataset/test/subject_test.txt")

# Adding the two columns for subject and activity label to the test dataset
testset_data <- cbind(test_activity_label, testset_data)
testset_data <- cbind(test_subject, testset_data)

# Merging the datasets
combined_data <- rbind(trainset_data, testset_data)

#2 Extract only the measurements on the mean and standard deviation for each measurement
colnames(combined_data)[1] <- "subject"
colnames(combined_data)[2] <- "activity_label"

# Assembling the columns of interest
ms_cols_common <- matchcols(combined_data, with=c("subject", "activity_label"), method="or")
ms_cols_mean <- matchcols(combined_data, with=c("mean"))
ms_cols_std <- matchcols(combined_data, with=c("std"))

# Extracting the data of interest
extracted_data <- subset(combined_data, TRUE, select=c(ms_cols_common, ms_cols_mean, ms_cols_std))

#3 Use descriptive activity names to name the activities in the data set
activities <- function(x){
        if (x == '1') {
                x <- "WALKING"
        } else if (x == '2') {
                x <- "WALKING_UPSTAIRS"
        } else if (x == '3') {
                x <- "WALKING_DOWNSTAIRS"
        } else if (x == '4') {
                x <- "SITTING"
        } else if (x == '5') {
                x <- "STANDING"
        } else if (x == '6') {
                x <- "LAYING"
        }
}

# Update extracted data with the activity names
extracted_data[,2] <- sapply(extracted_data[,2],activities)

#4 Appropriately label the data set with descriptive variable names
#4 Completed in step #1

#5 Create a second, independent tidy data set with the average of each variable for each activity and each subject

# Apply melt and ddply to get the summary
molten_data <- melt(extracted_data, id.vars=c("subject", "activity_label"))
result_data <- ddply(molten_data, c("subject", "activity_label"), summarise, mean=mean(value))

# Save the dataset with a comma separated file which can easily be opened in excel
write.table(result_data, "result_data.csv", sep = ",", row.name=FALSE)