---
title: "Untitled"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introduction

This project uses the UCI HAR dataset using Samsung Galaxy S phones. Information from the Readme provided:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

This project used the dplyr and tidr packages and data manipulation was carried out in RStudio. 

## Data Manipulation

The data was divided into two parts: a test data set and a training data set. These two data sets were merged to create an overall data frame containing all the research data. 

Next, any columns containing the mean or standard deviation were extracted and placed in a separate data set. From there, the data was grouped by subject ID and activity ID. Averages for each of these values were calculated and placed into a separate data set. 

## Loading Data into RStudio

```
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
```
The dataset provided was divided into a number of different files in several different directories. This code simply loaded all the files provided into RStudio as data frames so they could be manipulated. 

At this point, the "x_test" and "x_train" data frames contained the raw numerical data, the "y_test" and "y_train" frames contained the activity IDs, and the "subject_test" and "subject_train" sets contained the subject IDs. The "features" and "activity_labels" contained the metadata for the name of each measurement condition and activity the subjects performed, respectively. The first task was to merge these disparate sources into a single, coherent data set.

## Merging the Test and Train datasets

```
subject_df <- rbind(subject_test, subject_train) 
features_df <- rbind(x_test, x_train)
activity_df <- rbind(y_test, y_train)
activity_complete <- left_join(activity_df, activity_labels)
```

According to the parameters of the project, the first step was to combine the "test" datasets and the "train" datasets. These lines of code first merged the subject IDs, activity IDs, and test data together. The final line combined the activity IDs with the metadata, so each activity ID was paired with its corresponding activity name. 

## Creating the Overall Data Frame

```
complete_df <- cbind(subject_df, activity_complete, features_df)
colnames(complete_df) <- make.names(colnames(complete_df), unique=TRUE)
```

This code simply merged all the data frames into a single table. The second line was needed because some of the labels repeated themselves, so the make.names function was used to generate unique names for each column. 

## Extracting the Mean and STD
```
extracted_columns <- select(complete_df, subjects, activity_label, activity_name, contains("mean"), contains("std"))
```
The next part of the assignment was to extract all the columns that contained information on the mean and standard deviation of each task. This was done using dplyr's "select" command, which can use the "contains" argument to only look for columns that have the words "mean" and "std" in them. 

## Creating a Summary Dataset
```
tidy_tbl <- tbl_df(extracted_columns) %>% group_by(subjects, activity_name, activity_label)

summary_means <- summarise_each(tidy_tbl, funs(mean(., na.rm=TRUE)))
```

The last step was to create a dataset that provided the average of each task grouped by subject and activity. Again, the dplyr package for R makes this process much simpler, allowing quick grouping of each variable and then extracting  the average of each subject's activity data. The data was saved in table form, a variation on data frames used by dplyr.