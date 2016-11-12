library(dplyr)
library(tidyr)

setwd("~/GitHub/samsung_data_practice/UCI HAR Dataset/train")
x_train <- read.table("X_train.txt")
y_train <- read.table("Y_train.txt")
subject_train <- read.table("subject_train.txt")

setwd("~/GitHub/samsung_data_practice/UCI HAR Dataset/test")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("y_test.txt")

setwd("~/GitHub/samsung_data_practice/UCI HAR Dataset")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

setwd("~/GitHub/samsung_data_practice")

subject_df <- rbind(subject_test, subject_train) #this step took me way longer than it should, I kicked myself when I realized it was that easy.
features_df <- rbind(x_test, x_train)
activity_df <- rbind(y_test, y_train)
activity_complete <- left_join(activity_df, activity_labels) #I know I need some kind of join for merging activity_label and activity_names, but I had to puzzle out which one. 

colnames(subject_df) <- "subjects"
colnames(features_df) <- t(features[2]) #this step took me a while to figure out!
colnames(activity_complete) <- c("activity_label", "activity_name")

complete_df <- cbind(subject_df, activity_complete, features_df)
colnames(complete_df) <- make.names(colnames(complete_df), unique=TRUE)

extracted_columns <- select(complete_df, subjects, activity_label, activity_name, contains("mean"), contains("std"))
tidy_tbl <- tbl_df(extracted_columns) %>% group_by(subjects, activity_name, activity_label)

summary_means <- summarise_each(tidy_tbl, funs(mean(., na.rm=TRUE)))

