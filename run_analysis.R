activity_labels = read.table("UCI HAR Dataset/activity_labels.txt")

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")


combined_dataset <- rbind(cbind(X_train, y_train, subject_train), cbind(X_test, Y_test, subject_test))

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- tolower(features[,2])
features <- rbind(features,  data.frame(V1=562, V2="activity"));
features <- rbind(features,  data.frame(V1=563, V2="subject"));
keep <- c(grep("*std*|*mean*", features[,2]), 562, 563)
features <- features[keep,];
combined_dataset <- combined_dataset[,keep]
colnames(combined_dataset) <- features[,2]

activity_id = 1
for (currentActivityLabel in activityLabels$V2) {
    combined_dataset$activity <- gsub(activity_id, currentActivityLabel, combined_dataset$activity)
    activity_id <- activity_id + 1
}

combined_dataset$activity <- as.factor(combined_dataset$activity)
combined_dataset$subject <- as.factor(combined_dataset$subject)

clean_dataset = aggregate(combined_dataset, by=list(activity = combined_dataset$activity, subject=combined_dataset$subject), mean)[,seq(1,88)]
write.table(clean_dataset, "clean_dataset.txt", sep=",", row.name=FALSE)