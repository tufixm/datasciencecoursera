# Steps for reproducing the data

## Loading the data

1. The training and test subject ids are loaded from their respective files into `subjectTrainData` and `subjectTestData`.
2. The entire training set is loaded into `xTrainData`.
3. The entire training labels are loaded into `yTrainData`.
4. The entire test set is loaded into `xTestData`.
5. The entire test labels are loaded into `yTestData`.
6. The features data is loaded into `featuresData`. This table's first column will contain the indices of the features (to be matched with the column indices in `xTrainData` and `xTestData`). Its second column will contain the name of each feature (used to rename the columns of the concatenated `xTrainData` and `xTestData`).
7. The activity labels are loaded into `activityLabels`. This table's first column will contain an index from 1-6 matching one of the activity labels. The labels will be used in the final data set.

## Checking for NAs

Sanity check is performed on the loaded training and test features and labels. Basically all it's done is to check whether there are any missing values.

## Binding the data

1. `rbind` is applied for the training and test data for the features. The concatenated data is stored in `xData`.
2. `rbind` is applied for the training and test labels. The concatenated data is stored in `yData`.
3. `rbind` is applied for the training and test subject ids. The concatenated data is stored in `subjectData`.

## Filtering the required columns in the features data

According to the requirements of this project, only those columns related to the mean and the standard deviation are needed for further processing.
I have chosen to keep only those features primarily related to the mean and standard deviation of the processed signals. This leaves out features such as "meanFreq()" which are defined as a "weighted average of the frequency components".
They were selected by using a regular expression which returned the id matching those features which contain either "mean()" or "std()" in their name.
A total of 66 features was selected.
The indices of these features were then use to select the corresponding columns from `xData`, while the names of these features were used to rename the columns of `xData`.

## Putting everything together

Finally, `cbind` was applied to `subjectData`, `xData` and `yData`, yielding the first clean data set required. It is stored in `data.full`.
Prior to that, the unique column in `subjectData` was renamed to `SubjectId`, while the unique column in `yData` was renamed to `Activity`.

## Updating the activity labels

In order to avoid unexpected effects of its application on the order of the entries, the `merge` function is called on the final data set. This is merged with the `activityLabels`, with the `by`-column being removed (the activity index) and the last one (corresponding to `activityLabels$V2`) being renamed to `Activity`.

## Aggregating averages by subjects and activities

The required aggregated data from step 5 is obtained by using the `aggregate` function, taking as parameters the features columns, applying the `mean` function and grouping them by `SubjectId` and `Activity`.
The aggregated data is stored in `agg.data.final`.


# The codebook

* SubjectId
** class: integer
** range: 1-30
** the id of the subject

* Activity
** class: factor
** values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
** the type of physical activity the subjects took part into

* Features
** class: numeric
** values: floats between [-1, 1]
** mean and standard deviation measurements obtained from different signals. t in the beginning of the name involves the usage of time domain, while f the frequency domain. The rest of these variables' names is self explanatory.
