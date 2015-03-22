

run  <- function(base.folder="./UCI HAR Dataset"){
  ########################################################
  ##    CLEAN DATA AND CALCULATE MEAN ANS WRITE TO FILE
  ########################################################
  
  clean_data  <- uci_smartphone_data_wrangling(base.folder)
  write.table(x = clean_data,
              file = "clean_data.txt", 
              row.name=FALSE)
  
  clean_data_mean  <- average_subject.activity(clean_data)
  write.table(x = clean_data_mean,
              file = "clean_data_mean.txt", 
              row.name=FALSE)
  
  clean_data <<- clean_data
  clean_data_mean <<- clean_data_mean
  ########################################################
}

uci_smartphone_data_wrangling  <- function(base.folder){
  ######################################
  #   Initializing
  ######################################
  base_folder       <- base.folder
  data_file_folders <- c("test","train")
  features_file     <- paste(base_folder,"/features.txt",sep="")
  activity_labels_file  <- paste(base_folder,"/activity_labels.txt",sep="")
  
  ######################################
  #   Reading files
  ######################################
  activity_labels  <- read.table(activity_labels_file, col.names = c("act.code","act.label"))
  features <- read.table(features_file, sep = " ",
                         col.names  = c("col.num","feature"), 
                         colClasses = c("numeric","character"))
  dat_set  <- data.frame()
  dat_act  <- data.frame()
  dat_sub  <- data.frame()
  for (f in data_file_folders) {
    dat_set  <- rbind(dat_set,
                      read.table(paste(base_folder,"/",f,"/X_",f,".txt","",sep=""),
                                 colClasses="numeric"))
    dat_act  <- rbind(dat_act,
                      read.table(paste(base_folder,"/",f,"/y_",f,".txt","",sep=""),
                                 colClasses="integer"))
    dat_sub  <- rbind(dat_sub,
                      read.table(paste(base_folder,"/",f,"/subject_",f,".txt","",sep=""),
                                 colClasses="integer"))
  }
  
  ######################################
  #   Apply heading's name
  ######################################  
  names(dat_set)  <- features$feature
  names(dat_act)  <- c("act.code")
  names(dat_sub)  <- c("subject.code")
  
  ######################################
  #   keep only columns that 
  #   are mean or std
  ######################################
  pattern   <- "((mean)+)|((std)+)"
  col_names <- features$feature[
    grep(pattern = pattern, 
         x = features$feature,
         ignore.case = T)]
  dat_set   <- dat_set[,col_names]
  
  ######################################
  #   Add activity name column
  #   to the activity data.frame
  ######################################
  dat_act$id <- 1:nrow(dat_act)
  dat_act   <- merge(dat_act, activity_labels, by = "act.code")
  dat_act   <- dat_act[order(dat_act$id),c("act.code","act.label")]
  row.names(dat_act)  <-  NULL
  
  ######################################
  #   Combine activity data set and 
  #   measurements
  ######################################
  dat  <- cbind(dat_sub,dat_act,dat_set)
  
  return(dat)
}

average_subject.activity  <- function(clean_data){
  library(plyr)
  dat  <- clean_data[,]
  
  ######################################
  #   Extract activity code/name
  ######################################
  act_label  <- clean_data[,c("act.code","act.label")]
  act_label  <- unique(act_label)
  
  ######################################
  #   Calculate mean for each variable, 
  #   subject and activity
  ######################################
  dat$act.label  <- NULL # remove non-numeric columns
  dat       <- split(dat,list(dat$subject.code,dat$act.code))
  dat_mean  <- ldply(dat, colMeans)
  
  ######################################
  #   Add back the activity name
  ######################################
  dat_mean$id  <- 1:nrow(dat_mean)
  dat_mean     <- merge(act_label, dat_mean, by = "act.code")
  dat_mean     <- dat_mean[order(dat_mean$id),]
  dat_mean$id  <-  NULL
  dat_mean$.id <-  NULL
  row.names(dat_mean)  <-  NULL
  
  return (dat_mean)
}
