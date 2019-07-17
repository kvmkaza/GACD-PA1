# GACD-PA1
GACD PA1
Getting and Cleaning Data course - Programming Assignment
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 2.0
==================================================================
Original experiments and Data collection (Version 1.0) was conducted by:

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

=================================================================================================================

As part of this Programming Assignment, the training and test data sets have been merged into a single dataset.

First we set 'working directory' to the directory where the data sets are located.

Measurement Data: ('X dataset')
=================================================================================================================
Import and merge 'test' & 'train' Measurement data 

> tmpX <- lapply(list("./X_test.txt","X_train.txt"), read.table)
> X_combined <- do.call(rbind,tmpX)
> dim(X_combined)
[1] 10299   561
==================================================================
Set descriptive variable names for the measurement DF from features.txt file

> feature_names <- readLines("./features.txt")
> colnames(X_combined) <- feature_names
==================================================================
Extract only mean/standard deviation for each measurement
    
> X_combined <- X_combined %>% select(contains("mean"), contains("std"))
=================================================================================================================
Activity data ( Y-test data):
===================================================================
Import and merge 'test' & 'train' Activity data :

> tmpY <- lapply(list("./Y_test.txt","./Y_train.txt"), read.table)
> Y_combined <- do.call(rbind,tmpY)
> dim(Y_combined)
[1] 10299     1

===================================================================
We set column name(V1) to a more meaningful 'Activity'

> colnames(Y_combined)[1]="Activity"
===================================================================
We now set descriptive activity names for the activity codes from given activity_labels.txt
Read the activity labels into 'act_names'

> act_names <- readLines("./activity_labels.txt")
===================================================================    
Read through the act_names and substitute the activity name for the respective activity code as given   here:
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

> for (i in seq_along(act_names)) {
      
      Y_combined$Activity <- gsub(strsplit(act_names[i]," ")[[1]][1], 
				strsplit(act_names[i]," ")[[1]][2],
			              Y_combined$Activity)
    	}


Partial Output of Y_combined DF with updated column name and data values:

> str(Y_combined)
'data.frame':	10299 obs. of  1 variable:
 $ Activity: chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
=================================================================================================================

Subject Data:
=====================================================================
Import and merge 'test' & 'train' Subject data :

> tmpSub <- lapply(list("./subject_test.txt","./subject_train.txt"), 				read.table)
> subCombined <- do.call(rbind,tmpSub)

======================================================================
We set column names for Subject DF (V1) to a more meaningful 'Subject'

> colnames(subCombined)[1]="Subject"

Partial Output of subCombined DF with updated column values:
> str(subCombined)
'data.frame':	10299 obs. of  1 variable:
 $ Subject: int  2 2 2 2 2 2 2 2 2 2 ...

=================================================================================================================
For preparing a tidy data set by merging Subject, Activity and Measurement data we first need to add an ID column (based on row number) for all three DFs.
Define a new column "rn" with rownames as ID for merging

> X_combined$rn <- rownames(X_combined)
> Y_combined$rn <- rownames(Y_combined)
> subCombined$rn <- rownames(subCombined)

======================================================================
Merge data sets to create a new DF

> tidyDF <- join_all(list(X_combined,Y_combined,subCombined))
Joining by: rn
Joining by: rn

> dim(tidyDF)
[1] 10299   564 
	++ New columns added from Subject/Activity DFs and row-number (ID)

=====================================================================
We then proceed to compute mean of Measurement by Subject and Activity:

> tidyDF_Summ <- ddply(tidyDF, .(Subject,Activity), numcolwise(mean))

Sample output of mean of Measurement by Subject and Activity:
> tidyDF_Summ[1:10,1:5]
   Subject           Activity 1 tBodyAcc-mean()-X 2 tBodyAcc-mean()-Y 3 tBodyAcc-mean()-Z
1        1             LAYING           0.2215982        -0.040513953          -0.1132036
2        1            SITTING           0.2612376        -0.001308288          -0.1045442
3        1           STANDING           0.2789176        -0.016137590          -0.1106018
4        1            WALKING           0.2773308        -0.017383819          -0.1111481
5        1 WALKING_DOWNSTAIRS           0.2891883        -0.009918505          -0.1075662
6        1   WALKING_UPSTAIRS           0.2554617        -0.023953149          -0.0973020
7        2             LAYING           0.2813734        -0.018158740          -0.1072456
8        2            SITTING           0.2770874        -0.015687994          -0.1092183
9        2           STANDING           0.2779115        -0.018420827          -0.1059085
10       2            WALKING           0.2764266        -0.018594920          -0.1055004

=======================================================================
We output the tidy data set from above summarized data to a new file:

> write.table(tidyDF_Summ,"./tidyTestandTrain.txt", row.names = FALSE)

=================================================================================================================

The dataset includes the following files:
=========================================

- 'README.md' (this file)
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'tidyTestandTrain.txt': Tidy data with the average of each variable for each activity and each subject.
- 'Codebook.md': Codebook with details about data and its transformation steps to arrive at the tidy data set.
- 'run_analysis.R' : R program file with the actual programming construct

- 'X_test.txt' and 'X_train.txt': Original Measurement test and train data sets 
- 'Y_test.txt' and 'Y_train.txt': Original Activity test and train data sets 
- 'subject_test.txt' and 'subject_train.txt': Original Subject test and train data sets 

License:
========
The data set for this Programming Assignement is referenced from:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
======================================================================================

