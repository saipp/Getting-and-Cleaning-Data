================================================================
Getting and Cleaning Data Course Project
================================================================

The program "run_analysis.R" reads the Samsung data from the working directory and summarizes the data. 
The relative path is .\ucihar\UCI HAR Dataset
================================================================

When the program executes it creates a tidy dataset in a file called "result_data.txt", a space separted text file.

The program is implemented as follows

Merge the training and the test sets to create one data set and label the data set with descriptive variable names

Read in the features, activty names, train dataset

Add the two columns for subject and activity label to the train dataset

Read in the test dataset

Add the two columns for subject and activity label to the test dataset

Merge the two datasets

Extract only the measurements on the mean and standard deviation for each measurement

Assemble the columns of interest

Extract the data of interest

Use descriptive activity names to name the activities in the data set

Update extracted data with the activity names

Create a second, independent tidy data set with the average of each variable for each activity and each subject

Get the subjects and activities vector populated

Loop through the subjects and activities vectors in order to operate on the subset

Once the subset of data is filtered use sapply to get the mean

Subsequently add the subject and activity data to the data frame

Perform the row binding to accumulate the data for all the subjects and activities

Save the dataset with a comma separated file which can easily be opened in excel

Perform cleanup
 
================================================================

The codebook for the dataset is in the file code_book.================================================================

Here is the information from the original README.MD file

========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.