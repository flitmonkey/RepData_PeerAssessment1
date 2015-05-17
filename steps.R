rm(list=ls())
setwd("C:/_WORK/COURSERA/DataScience/ReproducibleResearch/Proj1/RepData_PeerAssessment1")
#library("plyr")
library("sqldf")
library("ggplot2")
library("dplyr")
library("plyr")

activity<-read.csv("activity.csv", header = TRUE, na.strings = "NA")

activity$date <- as.Date(activity$date , "%Y-%m-%d")

#activityDay<-sqldf("select date, sum(steps) as TotSteps from activity where steps<>'NA' group by date")

#p<-ggplot(data=activityDay, aes(activityDay$TotSteps)) + geom_histogram()+labs(title="Histogram of Total steps by day") +
#  labs(x="Total Steps", y="Count") 
#print(p)


activityInterval<-group_by(activity, interval)
activitybyInterval<-summarise(activityInterval,meanSteps=mean(steps, na.rm=TRUE))
  
#q<-ggplot(data=activitybyInterval, aes(x=interval,y=meanSteps)) + geom_line()+labs(title="Time series of Average steps by 5 min interval") +
#  labs(x="Interval", y="Average steps") 
#print(q)


activityFixed<-activity%>% group_by(interval) %>% mutate(steps=ifelse(is.na(steps),median(steps,na.rm=TRUE),steps))
activityFixed<-mutate(activityFixed,weekdayweekend=ifelse(weekdays(date)=="Saturday"|weekdays(date)=="Sunday","weekend","weekday"))
activityFInterval<-group_by(activityFixed, interval,weekdayweekend ,add=FALSE)



