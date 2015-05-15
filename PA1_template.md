# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
First clear out R and set the working directory

```r
rm(list=ls())
setwd("C:/_WORK/COURSERA/DataScience/ReproducibleResearch/Proj1/RepData_PeerAssessment1")
library("sqldf")
```

```
## Warning: package 'sqldf' was built under R version 3.1.3
```

```
## Loading required package: gsubfn
```

```
## Warning: package 'gsubfn' was built under R version 3.1.3
```

```
## Loading required package: proto
```

```
## Warning: package 'proto' was built under R version 3.1.3
```

```
## Loading required package: RSQLite
```

```
## Warning: package 'RSQLite' was built under R version 3.1.3
```

```
## Loading required package: DBI
```

```
## Warning: package 'DBI' was built under R version 3.1.3
```

```r
library("ggplot2")
```

```
## Warning: package 'ggplot2' was built under R version 3.1.3
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

```
## Loading required package: tcltk
```
This is a histogram of the total steps

```r
p<-ggplot(data=activityDay, aes(activityDay$TotSteps)) + geom_histogram()+labs(title="Histogram of Total steps by day") +
  labs(x="Total Steps", y="Count") 
print(p)
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 

The mean number of steps, rounded to 1 decimal place, is 10766.2 and the median is 10765

## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
