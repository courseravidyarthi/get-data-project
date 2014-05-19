The descriptions of the column headers are as per the file 'features_info.txt' which is part of the input data files

As per the step 2 of the project instructions, only columns with substrings 'mean()' or 'std()' in the names are retained from X_{train,test} files
Please note the columns for meanFreq() were specifically excluded. This follows as per the 'features_info.txt' which states:
"meanFreq(): Weighted average of the frequency components to obtain a mean frequency"
Thus columns with 'meanFreq()' substring are assumed as a different measurement and not a mean, 
because the corresponding standard deviation measurement is also lacking

Important Note for value in the final dataset for tiday data: 
(This refers to data frame 'tidyData' created as well as its output text file 'tidy_data.txt' on running the script)
Please note the values in the variables other than Subject and Activity are mean values of the variable for a given subject and given activity 
- however the original variable (column name) has been retained
