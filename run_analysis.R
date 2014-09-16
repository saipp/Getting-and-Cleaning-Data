# Load any needed libraries
library("gdata")
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

features[,2] <- gsub("Acc", "Acceleration",features[,2])
features[,2] <- gsub("Freq", "Frequency",features[,2])
features[,2] <- gsub("Mag", "Magnitude",features[,2])
features[,2] <- gsub("Gyro", "Gyrometer",features[,2])
features[,2] <- gsub("mean", "Mean",features[,2])
features[,2] <- gsub("tBody", "TimeBody",features[,2])
features[,2] <- gsub("std", "StandardDeviation",features[,2])

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
ms_cols_mean <- matchcols(combined_data, with=c("Mean"))
ms_cols_std <- matchcols(combined_data, with=c("StandardDeviation"))

# Extracting the data of interest
extracted_data <- subset(combined_data, TRUE, select=c(ms_cols_common, ms_cols_mean, ms_cols_std))

#3 Use descriptive activity names to name the activities in the data set
activities_func <- function(x){
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
extracted_data[,2] <- sapply(extracted_data[,2],activities_func)

#4 Appropriately label the data set with descriptive variable names
#4 Completed in step #1

#5 Create a second, independent tidy data set with the average of each variable for each activity and each subject
# Get the subjects and activities vector populated
subjects <- sort(unique(extracted_data[,1], incomparables=FALSE))
activities <- sort(unique(extracted_data[,2], incomparables=FALSE))
result_data <- NULL

# Loop through the subjects and activities vectors in order to operate on the subset
# Once the subset of data is filtered use sapply to get the mean
# Subsequently add the subject and activity data to the data frame
# Perform the row binding to accumulate the data for all the subjects and activities
for (i in 1:length(subjects)) {
        for (j in 1:length(activities)) {
                # Get the data subset to operate on (data per subject per activity)
                subset_data <- extracted_data[extracted_data$subject == subjects[i] & extracted_data$activity_label == activities[j],]
                
                # Get the mean for the subset of data
                summary_data <- sapply(subset_data[,3:88], mean)
                
                # Add two additional columns (subject and activity)
                enh_summary_data <- c(subjects[i], activities[j], summary_data)
                final_data <- rbind(enh_summary_data)
                df_final_data <- data.frame(final_data)
                
                # Update columns names for Subject and Activity columns
                colnames(df_final_data)[1] <- "Subject"
                colnames(df_final_data)[2] <- "Activity"
                
                # Append data to the final result set
                if ((i == 1) & (j == 1)) {
                        result_data <- df_final_data
                }
                else {
                        result_data <- rbind(result_data, df_final_data)
                }
        }
}

# Save the dataset with a comma separated file which can easily be opened in excel
write.table(result_data, "result_data.txt", row.name = FALSE)

# Perform cleanup
rm(activity_names, combined_data, extracted_data, features, result_data, subset_data, test_activity_label, test_subject)
rm(testset_data, train_activity_label, train_subject, trainset_data, i, j, ms_cols_common, ms_cols_mean, ms_cols_std)
rm(enh_summary_data, final_data, df_final_data, subjects, summary_data, activities_func, activities)