# A time series can be easily confused as a simple vector
lynx
# at a first glance, there is no visible time element

# this is where the ts class comes into play (timestamp for all time series calculations)
# time series require this class to work (models, graphs, functions and packages work with this class)
# if you have a multivariate time series (several columns for variable) you use "mts"
# when the time series is irregular, you use "xts" (suitable for financial data that have holydays in it
# on the other hand, the object "ts" equires the data to be regularely spaced 

mydata <- runif(50, 10, 45)
mydata

# now we transform this simple vector into a time series
mytimeseries <- ts(data = mydata, 
                   start = 1956, 
                   frequency = 4)
mytimeseries

# plotting a time series
plot(mytimeseries)

# checking the class
class(mytimeseries)

# checking the timestamp
time(mytimeseries)

# refining the start argument
# tweaking the timestamp; how do we modify it?
# start and c()
mytimeseries <- ts(data = mydata,
                   start = c(1956, 3),
                   frequency = 4)
mytimeseries

# hourly measurements with daily patterns, start at 8am on the first day
# start = c(1, 8), frequency(24)mytimeseries <- ts(data = mydata,
mytimeseries <- ts(data = mydata,
                   start = c(1,8),
                   frequency = 24)
mytimeseries

# measurements taken twice a day on workdays with weekly patterns, starts at the first week
mytimeseries <- ts(data = mydata,
                   start = 1,
                   frequency = 10)
mytimeseries

# monthly measurements with yearly cycles <- frequency = 12
# weekly measurements with yearly cycles <- frequency = 52

# this method also worls with the "mts" class too

############### EXercise, time series formatting
set.seed(123)
mydata <- cumsum(rnorm(450))

mytimeseries <- ts(data = mydata,
                   start = c(1914, 11),
                   frequency = 12)
mytimeseries
plot(mytimeseries)

# now use the lattice package

library(lattice)
xyplot.ts(mytimeseries)

# Time series chart and graphs, visualization is important
library(tidyverse)
# the latest version of the library "forecast" integrates "ggplot2" for plotting time series
# shiny is getting more and more attention (you can publish visualization online)
# users can interact with online shiny projects

nottem

# standard R base plot
plot(nottem)

# this is important: you can directly visualize the model (seasonal decomposition)
decompose(nottem)
plot(decompose(nottem))

library(forecast)
plot(forecast(auto.arima(nottem), h = 5))

# ggplot2 equivalent: the autoplot() function
autoplot(nottem)

autoplot(nottem) + 
  ggtitle("Autoplot of nottingham temperature")

# Time series specific plot
ggseasonplot(nottem)
ggmonthplot(nottem) # each month has its own line chart. the blue line is the mean for each line

################### Exercise

dataset <- AirPassengers
dataset
?par()
seasonplot(dataset, 
           main = "Seasonal Plot of dataset AirPassengers",
           xlab = "",
           col = c("red", "blue"),
           year.labels = T,
           labelgap = 0.35,
           type = "l",
           bty = "l", # boxlines
           cex = 0.75)


# no headers or row id and sorted correctly (continuous series of data)



######## working with irregular time series
# the interval between observations is not fixed
# in general you want to avoid it
# most model techniques require a regular time series!!! (arima, exponential smoothing etc...)
# we need to fix the dataset before using it for modeling and forecasting
# a possible solution would be to aggregate the data at a particular unit of time (and get the average)
# unfortunately, some information will be lost

# as you can see, the date here is character
class(irregular_sensor$V1)

# some days only have one observation, other days have multiple observations, and the hour fluctuates a lot
# this would lead to problems in the analysis
# we want to transform it into a daily dataset <- whenever there is more than one observation, we'll pick the mean

library(zoo)
library(tidyr)

# steps to be taken:
# 1. we convert the carachter into a date-time format (POSIX or date)
# 2. we regularize the dataset with an aggregate function
# 3. we convert the object into a time series

# the class "zoo" is perfect for irregular time series. date and time colums can be easily handled

# two alternative methods:
# 1. Separating the date and time components
# 2. keeping the date and time components as a unit

##### solution nr. 1

irregular_sensor

irreg.split <- separate(irregular_sensor,
         col = V1,
         into = c("date", "time"),
         sep = 8, # you separate after character numer eight
         remove = T) # you remove the original column
irreg.split

# converting text into time (POSIXlt)
sensor.date <- strptime(irreg.split$date, "%m/%d/%y")

irregts.df <- data.frame(date = sensor.date, 
                         measurement = irreg.split$V2)
# now we want to convert this dataframe into a zoo object
# we do that because we want to aggragate the data (mean) with the same date

irreg.dates <- zoo(irregts.df$measurement,
                   order.by = irregts.df$date)
irreg.dates

# aggregate by date
ag.irregtime<- aggregate(irreg.dates,
          as.Date, mean)


# 2nd solution, we keep the date AND time components as a unit (with no dataframe conversion)
sensor.date1 <- strptime(irregular_sensor$V1, "%m/%d/%y %I:%M %p")
sensor.date1

irreg.dates1 <- zoo(irregular_sensor$V2,
                    order.by = sensor.date1)
irreg.dates1

ag.irregtime1 <- aggregate(irreg.dates1,
                           as.Date, mean)
ag.irregtime1

plot(ag.irregtime1)


# convert it into a timeseries object

myts <- ts(ag.irregtime1)
plot(myts)

################ Working with missing data and outliers
# outliers can currupt the outcome of the analysis
# modeling techniques require the dataset to be complete

data <- ts_NAandOutliers
data

myts <- ts(data$mydata)
myts


# these two functions will help you spot some problems in the dataset
summary(myts)
plot(myts)

# extremely useful for outliers: tsoutlier()
tsoutliers(myts)
myts1 <- tsoutliers(myts)
plot(myts)

# missing values -> missing data imputation
# several available methods

# in the ZOO package
# Last Observation Carried Forward (very robust)
summary(na.locf(myts))
# or na.fill(data, value)
# na.trim()

# one interesting missing value in the package forecast (based on exponential smoothing)
na.interp(myts)

# the most convenient function is tsclean(), it combines na.interp() and tsoutliers()
# missing values are filled and outliers are replaced with locally smooth values

mytsclean <- tsclean(myts)
plot(mytsclean)
summary(mytsclean)
































