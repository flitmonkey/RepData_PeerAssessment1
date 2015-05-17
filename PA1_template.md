# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
First clear out R and set the working directory

```r
rm(list=ls())
setwd("C:/_WORK/COURSERA/DataScience/ReproducibleResearch/Proj1/RepData_PeerAssessment1")
library("sqldf")
library("ggplot2")
library("dplyr")
```
Then read in the csv and change the type of the `date` column

```r
activity<-read.csv("activity.csv", header = TRUE, na.strings = "NA")

activity$date <- as.Date(activity$date , "%Y-%m-%d")
head(activity)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```


## What is mean total number of steps taken per day?
First subset the data

```r
activityDay<-sqldf("select date, sum(steps) as TotSteps from activity where steps<>'NA' group by date")
```
This is a histogram of the total steps

```r
p<-ggplot(data=activityDay, aes(activityDay$TotSteps)) + geom_histogram()+labs(title="Histogram of Total steps by day") +
  labs(x="Total Steps", y="Count") 
print(p)
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 

The mean number of steps, rounded to 1 decimal place, is calculated using `format(round(mean(activityDay$TotSteps), digits=1),nsmall=1)` and has the value 10766.2 and the median is calculated using `median(activityDay$TotSteps)` and has a value 10765

## What is the average daily activity pattern?
First summarise the data by interval.

```r
activityInterval<-group_by(activity, interval)
activitybyInterval<-summarise(activityInterval,meanSteps=mean(steps, na.rm=TRUE))
```
then plot the average number of steps by 5 minute interval

```r
q<-ggplot(data=activitybyInterval, aes(x=interval,y=meanSteps)) + geom_line()+labs(title="Time series of Average steps by 5 min interval") +
  labs(x="Interval", y="Average steps") 
print(q)
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 

On average the highest number of steps occurs when `interval=`835 - which was calculatewd using `activitybyInterval$interval[which.max( activitybyInterval$meanSteps )]`.


## Imputing missing values
the total number of `Na`'s is calucated using `sum(is.na(activity$steps))` which gives 2304.

We need to create a new data set that replaces the missing values with the median by interval.

```r
activityFixed<-activity%>% group_by(interval) %>% mutate(steps=ifelse(is.na(steps),median(steps,na.rm=TRUE),steps))
```

The number of `NA`'s is now 0 as required.

we then recalculate the mean and median and plot a histogram to compare to the uncorrected data set.

```r
activityFDay<-sqldf("select date, sum(steps) as TotSteps from activityFixed where steps<>'NA' group by date")
```
This is a histogram of the total steps

```r
p<-ggplot(data=activityFDay, aes(activityFDay$TotSteps)) + geom_histogram()+labs(title="Histogram of Total steps by day") +
  labs(x="Total Steps", y="Count") 
print(p)
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png) 

This plot differs from that that corresponds to the original data by having a spike for low numbers of steps.

The mean number of steps, rounded to 1 decimal place, is 9503.9 and the median is 10395.

The difference between the medians is -370 and between means is -1262.3 showing that the fixed data set has much lower mean and median results - as you would expect based on the comparison of histograms.



## Are there differences in activity patterns between weekdays and weekends?
First we create a factor variable called `weekdayweekend`

```r
activityFixed<-mutate(activityFixed,weekdayweekend=ifelse(weekdays(date)=="Saturday"|weekdays(date)=="Sunday","weekend","weekday"))
activityFixed$weekdayweekend<-as.factor(activityFixed$weekdayweekend)
```

Then we create a summarised data frame to compare the profile of steps between weekdays and weekends.


```r
activityFInterval<-group_by(activityFixed, interval,weekdayweekend ,add=FALSE)
activityFbyInterval<-summarise(activityFInterval,meanSteps=mean(steps, na.rm=TRUE))
```
then plot the average number of steps by 5 minute interval

```r
qq<-ggplot(data=activityFbyInterval, aes(x=interval,y=meanSteps)) + geom_line()+labs(title="Time series of mean steps by 5 min interval and by weekday/weekend") +
  labs(x="Interval", y="Average steps") +facet_wrap(~weekdayweekend, ncol=1)
print(qq)
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png) 

