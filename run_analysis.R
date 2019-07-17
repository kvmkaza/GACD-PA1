run_analysis <- function () {
  
  ##Read and merge test & train "Measurement" Data:
    
    tmpX <- lapply(list("./X_test.txt","X_train.txt"), read.table)
    X_combined <- do.call(rbind,tmpX)
  
    ## Set descriptive variable names from features.txt file
      
    feature_names <- readLines("./features.txt")
    colnames(X_combined) <- feature_names
      
    ## Extract only mean/standard deviation for each measurement
    
    X_combined <- X_combined %>% select(contains("mean"), contains("std"))
    
    ##Read and merge test & train "Activity" data
    
    tmpY <- lapply(list("./Y_test.txt","./Y_train.txt"), read.table)
    Y_combined <- do.call(rbind,tmpY)
  
    ## Set descriptive column name for Activity DF
    colnames(Y_combined)[1]="Activity"
    
    ## provide descriptive activity names from activity_labels.txt
    
    act_names <- readLines("./activity_labels.txt")
    
    for (i in seq_along(act_names)) {
      
      Y_combined$Activity <- gsub(strsplit(act_names[i]," ")[[1]][1], 
                          strsplit(act_names[i]," ")[[1]][2], Y_combined$Activity )
    }
    
    
  ##Read and merge test & train "Subject" data:
    
    tmpSub <- lapply(list("./subject_test.txt","./subject_train.txt"), read.table)
    subCombined <- do.call(rbind,tmpSub)
  
    ## Set descriptive column name for Subject DF
    colnames(subCombined)[1]="Subject"
    
    
  ## Prepare tidy data set by merging Subject, Activity and Measurement data
  
    ## Define a new column "rn" with rownames as ID for merging
    X_combined$rn <- rownames(X_combined)
    Y_combined$rn <- rownames(Y_combined)
    subCombined$rn <- rownames(subCombined)

    ##Merge data sets
    tidyDF <- join_all(list(X_combined,Y_combined,subCombined))
    
    ## Summarize average of each Measurement by Subject and Activity
    tidyDF_Summ <- ddply(tidyDF, .(Subject,Activity), numcolwise(mean))

    ##Write a tidy data set file from above summarized data
    write.table(tidyDF_Summ,"./tidyTestandTrain.txt", row.names = FALSE)

}