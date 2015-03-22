# A R script to clean Activity-Recognition data set

In order to clean data the `run()` functin in `run_analysis.R` has to be used.

To clean the data with default values simply call `run()` after loading the source file: 

    > source('run_analysis.R')
    > run()

Two data.frames are created `clean_data` and `clean_data_mean`.

In this case the data file default location is `./UCI HAR Dataset` (this can be set as `base.folder` parameter in `run(base.folder)`). The base folder should have the following sructure:

    ./UCI HAR Dataset
              |---- activity_labels.txt
              |---- features.txt
              |
              |---- train
              |     |---- subject_train.txt
              |     |---- X_train.txt
              |     |---- y_train.txt
              |
              |---- test
                    |---- subject_test.txt
                    |---- X_test.txt
                    |---- y_test.txt
          
The script does the following:
  1. Merges the training and the test sets.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Labels the data set with descriptive variable names. (output: `clean_data`)
  5. Creates a second tidy data set with the average of each variable for each activity and each subject. (output: `clean_data_mean`)
