---
title: "samsung_codebook"
author: "zrodnick"
date: "November 11, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Codebook - UCI HAR Dataset

Packages Used:
dplyr
tidyr
```{r packages, include=FALSE}
library(dplyr)
library(tidyr)
```

```{r extracting, echo=FALSE}
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
## Activity Labels
```{r activity_labels}
print(activity_labels)
```

## Features
```{r features}
print(features)
```

##Code for Merging Training and Test Sets
```
subject_df <- rbind(subject_test, subject_train) 
features_df <- rbind(x_test, x_train)
activity_df <- rbind(y_test, y_train)
activity_complete <- left_join(activity_df, activity_labels) 

colnames(subject_df) <- "subjects"
colnames(features_df) <- t(features[2]) 
colnames(activity_complete) <- c("activity_label", "activity_name")

complete_df <- cbind(subject_df, activity_complete, features_df)
colnames(complete_df) <- make.names(colnames(complete_df), unique=TRUE)
```

## Code for Extracting Mean and STD
```
extracted_columns <- select(complete_df, subjects, activity_label, activity_name, contains("mean"), contains("std"))
tidy_tbl <- tbl_df(extracted_columns) %>% group_by(subjects, activity_name, activity_label)

summary_means <- summarise_each(tidy_tbl, funs(mean(., na.rm=TRUE)))
```
