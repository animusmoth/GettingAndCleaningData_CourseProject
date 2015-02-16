
run_analysis = function () {

fileName1 = paste("./data.zip", sep="")
if (!file.exists(fileName1)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = fileName1, method="curl")
  unzip(fileName1)
}

library(dplyr)
library(stringr)

## Load required Data
print("Loading required datasets...")
x_test <-read.csv2("UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)      ## loads test data
x_train <-read.csv2("UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)     ## loads train data

subject_test <- read.csv2("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE)   ## loads test subjects
subject_train <- read.csv2("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE)  ## loads train subjects

activity_test <- read.csv2("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE)## loads test activity
activity_train <- read.csv2("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE) ## loads train activity

activity_labels <- read.csv2("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE)  ## loads activity labels
feature <- read.csv2("UCI HAR Dataset/features.txt", header=FALSE, sep=" ", stringsAsFactors=FALSE) ## loads features vector
print("All data in!!")

## Label Activities
colnames <- c("Activity_ID", "Activity_Label")
activity_test <- inner_join(activity_test, activity_labels)
names(activity_test) <- colnames
activity_train <- inner_join(activity_train, activity_labels)
names(activity_train) <- colnames
print("Activities are labeled...")


## Label Subjects
colnames <- c("Subjects")
names(subject_test) <- colnames
names(subject_train) <- colnames
print("Subjects are ready...")


## Prepare Features 
### Tidy feature
feature$V2<-str_replace_all(str_replace_all(feature$V2,"[-,\\,]","_"), "[()]", "")
### Checks for duplicate feature
dup<-duplicated(feature$V2)
featureNotDup<-feature$V2[!dup]
print("Features prepared...")

## Place features in dataset
names(x_test) <- feature$V2
names(x_train) <- feature$V2
print("Features added to both datasets...")

## remove duplicates from dataset
test <- x_test[,featureNotDup]
train <- x_train[,featureNotDup]
print("Duplicate columns removed...")

## convert all values to double
print("Converting values do 'double'...")
test <- sapply(test, as.double)
train <- sapply(train, as.double)
print("All values converted to double...")

## Put everything together
test <- cbind(subject_test, test, activity_test)
train <- cbind(subject_train, train, activity_train)

## merge everything
data <- rbind(test,train)
print("Final dataset ready!")

## change to tbl_df to make things easier to select and do subsequent group_by for question 5
df_data <- tbl_df(data) %>%
    select(Subjects, matches(".mean."), matches(".std."), Activity_Label)   ## select mean and std dev
print("Mean and std dev selected...")


## write first tidy data file
write.table(df_data, "Tidy_Data.txt", row.name = FALSE)
print("First file ready!")

## answer to question #5
gr_data <- na.omit(df_data) %>%     ## omit NA 
      group_by(Subjects, Activity_Label) %>%  ## group_by as required
      summarise_each(funs(mean(.,na.rm=TRUE)))  ## summarise each column as required
print("Groupped and Summarized, Average values calculated...")

## write second tidy data file
write.table(gr_data, "Grouped_Data.txt", row.name = FALSE)
print("Second file ready!!")

}

