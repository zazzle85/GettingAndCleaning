
library(dplyr)
##load data
link<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(link,destfile="./UCIdata.zip", mode="wb")
unzip("./UCIdata.zip")
trainingset<-read.table("./UCI HAR Dataset/train/x_train.txt")
traininglabel<-read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")
testset<-read.table("./UCI HAR Dataset/test/x_test.txt")
testlabel<-read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest<-read.table("./UCI HAR Dataset/test/subject_test.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
activity<-read.table("./UCI HAR Dataset/activity_labels.txt")

#Appropriately labels the data set with descriptive variable names.
names(testset)<-features[,2]
names(trainingset)<-features[,2]

##Merge Data (first combine the columns and then name all the columns the same name to combine the rows)

test<-cbind(testlabel,subjecttest,testset)
train<-cbind(traininglabel,subjecttrain,trainingset)

colnames(test)[c(1,2)]<-c("label","subject")
colnames(train)[c(1,2)]<-c("label","subject")
output<-rbind(test,train)


#Extracts only the measurements on the mean and standard deviation for each measurement with the label and subject.
x<-c("mean","std","label","subject")
df<-output[,grepl(paste(x,collapse = "|"),names(output))]

#assign descriptive activity names to name the activities in the data set
post<-merge(df,activity,by.x = "label",by.y = "V1")
colnames(post)[colnames(post)=="V2"] <- "activities"
TidyData<-post[,c(2:ncol(post))]

#Create a second, independent tidy data set with the average of each variable for each activity and each subject
Tidy2<-TidyData %>%
      group_by(subject, activities) %>%
            summarise_each(list(mean=mean))
