# Coursera Getting and Cleanning Data Assignment
## Jorge Cabrita de Sousa
### Feb  16, 2015

## Use run_analysis.R as follows:

** Internet Conection is required **

In R console:

1. source("run_analysis.R")
2. run_analysis()


The run_analysis() function is expected to work as follows:

0) If not exists, downloads the file in https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, saves it as "data.zip" and unzips the file;
1) Loads all relevant datasets;
2) Labels Activities according to their activity_labels;
3) Prepares the relevant "subjects" files;
4) Cleans the "features" data;
5) Adds "features" (Column names) to both datasets;
6) Removes duplicate columns;
7) Converts all values to "double";
8) Merges all datasets using cbind and rbind accordingly into one unique dataset;
9) Selects only the "mean" and "std" columns;
10) Writes the first "tidy" dataset;

11) groups dataset by Subject and Activities;
12) Calculates average values as required;
13) Saves second dataset file;

NB: The original data file is downloaded if not present in working directory. 