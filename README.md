# getting-cleaning-data
This repo contains files made as part of the work done in connection with the Coursera course Getting and Cleaning Data

# How the script works
The script run_analysis.R can be executed as one single exectution with the data and data structure for the UCI HAR Dataset, and it will result in one outputfile named mySubmissionWeek4GettigCleaningData.txt in your working directory.
You need to make sure that your working directory is in the folder, where you have all the files in the UCI HAR Dataset. Running the command dir() should result in the following contents from the UCI HAR Dataset with  at least the test and train folders and their original contents:
> dir()
[1] "activity_labels.txt" "features.txt"        "features_info.txt"   "README.txt"          "test"               
[6] "train"    

# Code book describing the variables
The output file mySubmissionWeek4GettigCleaningData.txt is a file based on all of the measurements in the UCI HAR Dataset, that have been grouped on subject and activity and then averaged for every column. For one test subject a subset of the data will look like this:

> head(groupsMeasurementsAvg, 10)

>   subject activity       activityname tbodyacc-mean()-x tbodyacc-mean()-y tbodyacc-mean()-z tbodyacc-std()-x

>1        1        1            WALKING         0.2773308      -0.017383819        -0.1111481      -0.28374026

>2        1        2   WALKING_UPSTAIRS         0.2554617      -0.023953149        -0.0973020      -0.35470803

>3        1        3 WALKING_DOWNSTAIRS         0.2891883      -0.009918505        -0.1075662       0.03003534

>4        1        4            SITTING         0.2612376      -0.001308288        -0.1045442      -0.97722901

>5        1        5           STANDING         0.2789176      -0.016137590        -0.1106018      -0.99575990

>6        1        6             LAYING         0.2215982      -0.040513953        -0.1132036      -0.92805647



The output file contains the following three grouping variables:

1                      subject: The id of the test subject

2                     activity: The id of the activity

3                 activityname: The decriptive name of the activity such as WALKING, SITTING...

All 66 following variables come from the original file "features.txt" and they are described in the features_info.txt in the original UCI HAR Dataset. The changes that have been made are that all the characters have been converted to lower case and the data are now in the output file calculated as a mean of all the values in the original column grouped by the subject and the activity. The names are

4            tbodyacc-mean()-x

5            tbodyacc-mean()-y

6            tbodyacc-mean()-z

7             tbodyacc-std()-x

8             tbodyacc-std()-y

9             tbodyacc-std()-z

10        tgravityacc-mean()-x

11        tgravityacc-mean()-y

12        tgravityacc-mean()-z

13         tgravityacc-std()-x

14         tgravityacc-std()-y

15         tgravityacc-std()-z

16       tbodyaccjerk-mean()-x

17       tbodyaccjerk-mean()-y

18       tbodyaccjerk-mean()-z

19        tbodyaccjerk-std()-x

20        tbodyaccjerk-std()-y

21        tbodyaccjerk-std()-z

22          tbodygyro-mean()-x

23          tbodygyro-mean()-y

24          tbodygyro-mean()-z

25           tbodygyro-std()-x

26           tbodygyro-std()-y

27           tbodygyro-std()-z

28      tbodygyrojerk-mean()-x

29      tbodygyrojerk-mean()-y

30      tbodygyrojerk-mean()-z

31       tbodygyrojerk-std()-x

32       tbodygyrojerk-std()-y

33       tbodygyrojerk-std()-z

34          tbodyaccmag-mean()

35           tbodyaccmag-std()

36       tgravityaccmag-mean()

37        tgravityaccmag-std()

38      tbodyaccjerkmag-mean()

39       tbodyaccjerkmag-std()

40         tbodygyromag-mean()

41          tbodygyromag-std()

42     tbodygyrojerkmag-mean()

43      tbodygyrojerkmag-std()

44           fbodyacc-mean()-x

45           fbodyacc-mean()-y

46           fbodyacc-mean()-z

47            fbodyacc-std()-x

48            fbodyacc-std()-y

49            fbodyacc-std()-z

50       fbodyaccjerk-mean()-x

51       fbodyaccjerk-mean()-y

52       fbodyaccjerk-mean()-z

53        fbodyaccjerk-std()-x

54        fbodyaccjerk-std()-y

55        fbodyaccjerk-std()-z

56          fbodygyro-mean()-x

57          fbodygyro-mean()-y

58          fbodygyro-mean()-z

59           fbodygyro-std()-x

60           fbodygyro-std()-y

61           fbodygyro-std()-z

62          fbodyaccmag-mean()

63           fbodyaccmag-std()

64  fbodybodyaccjerkmag-mean()

65   fbodybodyaccjerkmag-std()

66     fbodybodygyromag-mean()

67      fbodybodygyromag-std()

68 fbodybodygyrojerkmag-mean()

69  fbodybodygyrojerkmag-std()
