###############################################################################
################################## SETTINGS ###################################
###############################################################################

## Take nothing but pictures
OLDpath <- getwd()                             # save current working directory
save.image(file = "./WS.RData")                        # save current workspace
savehistory(file = "./History.Rhistory")             # save the history command

## Move working directory and clear work space
NEWpath <- file.path("~","MOOC","Datascience","Project")  # set desired wd path
if(!file.exists(NEWpath)) dir.create(NEWpath)         # if not exist, create it
setwd(NEWpath)                                 # enter to the working directory
# getwd()                                                                # path
rm(list=ls())                                             # clear the workspace


## Loading package(s)
library(plyr)                    # package for split-apply-combine pattern in R


###############################################################################
################################### START #####################################
###############################################################################

## Link (http and not https for compatibility)
path <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                                                                  # set the url
download.file(path, "./dataset.zip", method="auto")         # download the data
unzip("./dataset.zip")                                         # unzip the data
# dir()                                                     # watch the results
setwd(file.path(getwd(),"UCI HAR Dataset"))     # enter into the main directory

## Set the (sub)paths
TRAINpath <- file.path(getwd(), "train")      # set platform-friendly shortcuts
TESTpath <- file.path(getwd(),"test")           # for the finded subdirectories

## Read data: TRAINING SET (rows: single train, cols: values detected)
settrain <- read.table(file.path(TRAINpath,"X_train.txt"))  # detected features
                                                           # for the activities
# str(settrain)   # data.frame with 7352 train and 561 (nums) values named V<n>
# head(settrain, 3)                                # just an idea of the values
subjecttrain <- read.table(file.path(TRAINpath,"subject_train.txt"))   # IDs of
                                     # subjects who have performed the activity
# str(subjecttrain)                                 # data.frame of int (1--30)
labeltrain<-read.table(file.path(TRAINpath,"y_train.txt")) # IDs of the kind of
                                                       # the activity performed 
# str(labeltrain)                                    # data.frame of int (1--6)

## Read data: TEST SET (exactly the same as training set)
settest<-read.table(file.path(TESTpath,"X_test.txt"))
subjecttest<-read.table(file.path(TESTpath,"subject_test.txt"))
labeltest<-read.table(file.path(TESTpath,"y_test.txt"))

## Read data: FEATURES map (id-label)
featurelabels<-read.table("features.txt", colClasses = c("character"))
                                       # setted as char for use as "real" label
# str(featurelabels)                                # the 561 names of features

## Read data: ACTIVITY map (id-label)
activitylabels<-read.table("activity_labels.txt",
                           col.names = c("Id", "Activity"))  # will be used for
                                                                     # grouping
# str(activitylabels)                  # the 6 pairs int-levels of the activity 


###############################################################################
################################### EX 1: #####################################
######## Merges the training and the test sets to create one data set. ########
###############################################################################

traindata<-cbind(cbind(settrain, subjecttrain), labeltrain) # column bind train
testdata<-cbind(cbind(settest, subjecttest), labeltest)      # column bind test
sensordata<-rbind(traindata, testdata)                # row bind train and test

sensorlabels<-rbind(rbind(featurelabels, c(562, "Subject")), c(563, "Id"))[,2]
                                         # add missing labels: "who" and "what"
names(sensordata)<-sensorlabels             # set the names into the data frame
# str(sensordata)                                           # watch the results
# head(sensordata, 3)


###############################################################################
################################### EX 2: #####################################
############ Extracts only the measurements on the mean and standard  #########
############ deviation for each measurement.                          #########
###############################################################################

sensordatameanstd <- sensordata[,grepl("mean\\(\\)|std\\(\\)|Subject|Id",
                                       names(sensordata))]
             # filter data frame with a logic regular expr for desired variable
                                          # (as explained in features_info.txt)
# str(sensordatameanstd)                                    # watch the results
# head(sensordatameanstd,3)


###############################################################################
################################### EX 3: #####################################
### Uses descriptive activity names to name the activities in the data set. ###
###############################################################################

sensordatameanstd <- join(sensordatameanstd, activitylabels,        # what join
                          by = "Id",                          # by which labels
                          match = "first")                      # faster option
sensordatameanstd <- sensordatameanstd[,-1]                   # remove Id field
# head(sensordatameanstd, 3)                                # watch the results


###############################################################################
################################### EX 4: #####################################
########## Appropriately labels the data set with descriptive names. ##########
###############################################################################

names(sensordatameanstd) <- gsub("([()])","",names(sensordatameanstd))
                                 # delete al kind of combination of "(" and ")"
names(sensordatameanstd) <- make.names(names(sensordatameanstd))
                                           # create a syntactically valid names 
# head(sensordatameanstd, 3)                                # watch the results


###############################################################################
################################### EX 5: #####################################
######## From the data set in step 4, creates a second, independent    ########
######## tidy data set with the average of each variable for each      ########
######## activity and each subject.                                    ########
###############################################################################

avaragedata <- ddply(sensordatameanstd,                                 # where
                     c("Subject","Activity"),                  # by which label
                     numcolwise(mean))                             # what: mean 
# head(avaragedata, 3)                                      # watch the results
nameavarage <- names(avaragedata)                                   # load name
nameavarage <- sapply(nameavarage, function(x) paste(x,".avarage", sep=""))
                                      # add ".avarage" description to each name
nameavarage[c("Subject", "Activity")] <- c("Subject", "Activity")
                          # delete ".avarage" description for non-feature names
names(avaragedata) <- nameavarage                  # store name into data frame
# head(avaragedata, 3)

###############################################################################
################################## SAVE WORK ##################################
###############################################################################

write.table(avaragedata, file = "avaragedata_by_subject.txt", row.name=FALSE)


###############################################################################
################################## RESTORE  ###################################
###############################################################################

## leave nothing but footprints
detach(package:plyr)                                        # unload package(s)
setwd(OLDpath)                          # return into the old working directory
load("./WS.RData")                                      # reload old work space
unlink("./WS.RData")                             # delete saved work space file
load("./History.Rhistory")                         # reload old command history
unlink("./History.Rhistory")                     # delete command histrory file
