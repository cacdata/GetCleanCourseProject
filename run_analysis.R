###### Get ready
        print("loading libraries...")
        ## from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
        ## Make sure you have unzippped this data set and made the UCI DataSet folder your working directory
        ## Make sure you have installed the dplyr package
        library(dplyr)
        
####### Assemble the data set 
        print("reading data - this may take a while...")
        ## 1 Merges the training and the test sets to create one data set.
        ## read in test data
        testdata <- read.table("test/X_Test.txt")  
        ## read in training data
        traindata <-read.table("train/X_Train.txt")
        ## attach column headers to both data sets from the features list
        featurenames <- read.table("features.txt")
        columnNames <- as.vector(featurenames$V2)
        # tidy up those names, get rid of commas, dashes, and parens
        # they will just make it hard to use the names in various functions.
        
        columnNames <- gsub("-","_",columnNames)
        columnNames <- gsub("()","", columnNames, fixed = TRUE)
        columnNames <- gsub("(","__", columnNames, fixed = TRUE)
        columnNames <- gsub(")","__", columnNames, fixed = TRUE)
        columnNames <- gsub(",","_", columnNames, fixed = TRUE)
        ## some of the column names are dups, they aren't mean or std ones, so I'm just going to
        ## let this function clean them up for me so they don't get in my way later. 
        columnNames <- make.names(columnNames, unique=TRUE)
        colnames(testdata) <- columnNames
        colnames(traindata) <- columnNames
        
        
        ## attach the subject list to each data set
        subjecttrain <- read.table("train/subject_train.txt")
        traindata <- cbind(subjecttrain,traindata)
        colnames(traindata)[1] <- "subject"
        subjecttest <- read.table("test/subject_test.txt")
        testdata <- cbind(subjecttest,testdata)
        colnames(testdata)[1] <- "subject"
        
        
        ## attach the activity list to each data set
        activitytrain <- read.table("train/y_train.txt")
        traindata <- cbind(activitytrain,traindata)
        colnames(traindata)[1] <- "activity"
        activitytest <- read.table("test/y_test.txt")
        testdata <- cbind(activitytest,testdata)
        colnames(testdata)[1] <- "activity"
        
        
        ## now merge test and train into one big data set
        fullHARdata <- rbind(testdata, traindata)
        
####### Get the columns we are looking at today
        print("selecting data subset")
        
        ## 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
        ## excluding meanFreq and the Angle values which happened to have mean in their names but aren't what I want in this project
        meanstdHARdata <- select(fullHARdata, subject, activity, contains("_mean"), -contains("meanFreq"),-contains("angle"),contains("_std")) 

####### Map activity codes to human readable strings
        
        ## 3 Uses descriptive activity names to name the activities in the data set
        print("updating activity names")
        
        meanstdHARdata <-  mutate(meanstdHARdata, activity = ifelse(activity == 1 , "Walking",
                       ifelse(activity == 2 , "Walking_Upstairs",
                       ifelse(activity == 3 , "Walking_Downstairs",
                       ifelse(activity == 4 , "Sitting",
                       ifelse(activity == 5 , "Standing",
                       ifelse(activity == 6 , "Laying", NA)))))))
                    
######## Clean up the column header names       
        
        
        ## 4 Appropriately labels the data set with descriptive variable names. 
        ## I read in the activity neames before merging, so just going to do a little more 
        ## cleanup at this step
        print('labeling data...')
        meanstdHARDataNames <- colnames(meanstdHARdata)
        meanstdHARDataNames <- gsub("BodyBody","Body",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("fBody","FreqBody",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("tBody","TimeBody",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("fGravity","FreqGravity",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("tGravity","TimeGravity",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("Mag_","Magnitude_",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("std_X","X_std",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("std_Y","Y_std",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("std_Z","Z_std",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("mean_X","X_mean",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("mean_Y","Y_mean",meanstdHARDataNames)
        meanstdHARDataNames <- gsub("mean_Z","Z_mean",meanstdHARDataNames)
        colnames(meanstdHARdata) <- meanstdHARDataNames
        
######## Make the requested data set for uploading        
        
        ## 5 From the data set in step 4, creates a second, independent tidy data set with the average 
        ## of each variable for each activity and each subject.
        ## This is a wide data set, assuming each X, Y, Z is an independent variable
        print ("making new data set")
        meanstdHARdataAverage <- meanstdHARdata %>% 
                group_by(subject,activity) %>%
                summarise_each(funs(mean(., na.rm = TRUE)))
        ## prefix ave to note these are the average means and stds for each in this data set.
        meanstdHARdataAverageNames <- colnames(meanstdHARdataAverage)
        meanstdHARdataAverageNames <- gsub("^","avg",meanstdHARdataAverageNames)
        colnames(meanstdHARdataAverage)[3:ncol(meanstdHARdataAverage)] <- meanstdHARdataAverageNames[3:ncol(meanstdHARdataAverage)]
      
        ## Final data set is in meantstdHARdataAverage
        ## save it to a file for upload
        print("writing to a file")
        write.table(meanstdHARdataAverage,"HARdataAverage.txt", row.name = FALSE)
        ## you can read this table back in using 
        ## yourtable <- read.table("HARdataAverage.txt", header = TRUE) 
        
## That's all.  You've reached the end of the script
        print("complete")



