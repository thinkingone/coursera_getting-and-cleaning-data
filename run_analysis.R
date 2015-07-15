## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##
##  1. The first is merging the Training and Test data sets together.
##     I will tell you that both Training and Test data sets are made up of multiple files that you need to combine first.
##  2. The second activity is creating and outputting a Tidy data set from the combined data. 


if (!require("data.table")) {
    install.packages("data.table")
}

if (!require("reshape2")) {
    install.packages("reshape2")
}

library("data.table")
library("reshape2")

# Load activity label. Note: get rid of the id
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load column names, that is 561 features. Note: get rid of the id
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std",features)

# Load and process X_test & y_test data.
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#add the variable names
names(x_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
x_test = x_test[,extract_features] # the  first table

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]  # the second table
names(y_test) = c("Activity_ID","Activity_Label")
names(subject_test) = "subject" # the third table

#Bind data
test_data <- cbind(as.data.table(subject_test),y_test,x_test)

# Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)


#Merge test and train data
data <- rbind(test_data,train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data,file = "./tidy_data.txt",row.names = FALSE)


