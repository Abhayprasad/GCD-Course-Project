GCD-Course-Project
==================

Project Submission for Getting and Cleaning Data course

Introduction

The project assignment for the course, Getting and Cleaning Data, requires us to submit links to sources / repositories:

(i) The first submission is a .txt file that is uploaded to the project submission form on Coursera website. This file is the final output of the R algorithm that serves the 5 steps required as per the project
(ii) The second submission is a link to the student's Github repository. This repository contains the following three components/files:
	(a) "run_analysis.R" - this is the R code / algorithm that processes the raw data that has been downloaded.
	(b) "README.md" - the Readme file contains the description that you are now reading.
	(c) "CodeBook.md" - a code book that describes the variables, the data, and any transformations or work that ws performed to clean up the data

Below are the required steps that the R code/algorithm most follow as its processes the raw data:

Step 1: Merges the training and the test sets to create one data set.
Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
Step 3: Uses descriptive activity names to name the activities in the data set
Step 4: Appropriately labels the data set with descriptive variable names. 
Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The raw data is sourced from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script run_analysis.R assumes that the data has been downloaded (and inzipped manually). The script starts by setting the working directory to the local directory where this data has been downloaded. 

RStudio version 0.98.977
 for Window 8 was used to develop the R script. 



