rm(list=ls())
setwd("C:/_WORK/COURSERA/DataScience/ReproducibleResearch/Proj1/RepData_PeerAssessment1")
library("sqldf")
library("ggplot2")


activity<-read.csv("activity.csv", header = TRUE, na.strings = "NA")

activity$date <- as.Date(activity$date , "%Y-%m-%d")

activityDay<-sqldf("select date, sum(steps) as TotSteps from activity where steps<>'NA' group by date")

p<-ggplot(data=activityDay, aes(activityDay$TotSteps)) + geom_histogram()+labs(title="Histogram of Total steps by day") +
  labs(x="Total Steps", y="Count") 
print(p)