#Project
library(plyr)

#putting all training files into one dataset
Train = read.csv("train/X_train.txt", sep="", header=FALSE)
Train[,562] = read.csv("train/Y_train.txt", sep="", header=FALSE)
Train[,563] = read.csv("train/subject_train.txt", sep="", header=FALSE)

#putting all testing files into one dataset
Test = read.csv("test/X_test.txt", sep="", header=FALSE)
Test[,562] = read.csv("test/Y_test.txt", sep="", header=FALSE)
Test[,563] = read.csv("test/subject_test.txt", sep="", header=FALSE)

#merge all datasets to create one dataset
Combined = rbind(Train, Test)

#read in features file
features = read.table("features.txt")

#find columns with "mean" or "std"
colno = grep(".*(mean|std)",features[,2])

#Subset the data with only "mean" and "std" columns
Combined_sub = Combined[,c(colno,562,563)]

#Label the dataset
colnames(Combined_sub) = c(as.character(features[colno,2]),"Activity","Subject")

#read in the label file for activities
lab = read.csv("activity_labels.txt", sep="", header=FALSE)

#rename activities
Combined_sub[,(length(colno)+1)] = lab[Combined_sub[,(length(colno)+1)],2]

#create the new tidy dataset
tidy = ddply(Combined_sub, .(Subject, Activity), function(x) colMeans(x[, 1:79])) 

write.table(tidy, "tidy.txt", row.name=FALSE) 
