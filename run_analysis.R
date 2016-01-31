                       ** Getting and cleaning Data Project**

```{r eval = FALSE}
if (!getwd() == "./data") {
     dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
```

Getting the names of the files
```{r}
path_rf <- file.path("C:/Users/anvithakatragadda/Documents/data","UCI HAR Dataset")
files <- list.files(path_rf, recursive = TRUE)
files
```

 The files that will be used to load data are listed as follows:

test/subject_test.txt
test/X_test.txt
test/y_test.txt
train/subject_train.txt
train/X_train.txt
train/y_train.txt

Values of Varible Activity consist of data from "Y_train.txt" and "Y_test.txt"
values of Varible Subject consist of data from "subject_train.txt" and subject_test.txt"
Values of Varibles Features consist of data from "X_train.txt" and "X_test.txt"
Names of Varibles Features come from "features.txt"
levels of Varible Activity come from "activity_labels.txt"
So we will use Activity, Subject and Features as part of descriptive variable names for data in data frame.

2.Read data from the files into the variables

Read the Activity files
```{r}
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
```
Read the Subject files
```{r}
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
```
Read Feature files
```{r}
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
```
Look at the property variable
```{r}
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)
```

Merging the train and test data sets

-- Concatenate the sets
```{r}
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

```
--set names to variables
```{r}
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
```
--Merge columns to get the data frame Data for all data
```{r}
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)
```
Subset Name of Features by measurements on the mean and standard deviation
```{r}
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
```
Subset the data frame Data by seleted names of Features
```{r}
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
```
Check the structures of the data frame Data

```{r}
str(Data)
```
Read descriptive activity names from "activity_labels.txt"
```{r}
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
```
Facorize Variable activity in the data frame Data using descriptive activity names

check
```{r}
head(Data$activity,30)
```
prefix t is replaced by time
Acc is replaced by Accelerometer
Gyro is replaced by Gyroscope
prefix f is replaced by frequency
Mag is replaced by Magnitude
BodyBody is replaced by Body

```{r}
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)

```


 ```{r}
 library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
```



