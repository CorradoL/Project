Getting and Cleaning Data Course Project
=========================


Code Book
========
  
This is a code book that describes the variables, data, and any transformations or work that you performed to clean up the data.


Raw data collection
-------------------
  
  ### Collection
  
  Raw data are obtained from UCI Machine Learning repository: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
  
  You can read there the general description of the experiments.


Raw Data transformation
-------------------
  
  The raw data sets are processed with the script run_analysis.R script to create a tidy data set as request by the project.

1. Merges the training and the test sets to create one data set (the variables are named by the original names);
2. Extracts only the measurements on the mean and standard deviation for each measurement;
3. Uses descriptive activity names to name the activities in the data set;
4. Appropriately labels the data set with descriptive variable names (use a syntactically valid names). 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Tidy data set
-------------------
  
### Variables
  
  The tidy data set contains :
  
* a __Subject__ variable that describe who (IDs: 1--30) perform the specific train (each single row);
* an __Activity__ variable (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) that describe the specific kind of activity which are performed (by _Subject_);
* all the other variables are measurement of the signal detected during the experiments (numeric value which means can be found in the general description provided above).

### Note
For the variable in the final stage we add _.avarage_ extension to the name to clearity.


Output
-----------
The data set is written to the file 'avaragedata_by_subject.txt'.