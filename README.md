#run_analysis

- **run_analysis.R** contains a single script to perform the actions required for the Getting and Cleaning Data Course project. All functionality is contained in a single script -- it is not that long. No other scripts are sourced and all you need to do to execute the script it source it.

##Prereqs

- Make sure you have installed the **dplyr** package before running this script
- Place and run this script in the ***UCI HAR Dataset folder*** created when you unzipped the course project files.

##Running

- This script will produce a copy of the ***"HARdataAverage.txt"*** file that was uploaded with the course project.  
- You can read that file back in using a commmand like:

     yourtable <- read.table("HARdataAverage.txt", header = TRUE) 
     
## Other Information
- Check the codebook or look at the script comments. 
