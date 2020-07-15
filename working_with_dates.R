# you must format date and time to work with time series and survival analysis
# date is a data type

# -------------------------------------------------------- STANDARD R BASE

# POSIXt is an encoding system that computers understand (windows, mac, linux)
# there aee two classes of posix format

# POSIXct
x <- as.POSIXct("2019-12-25 11:45:34") # number of seconds

# POSIXlt
y <- as.POSIXlt("2019-12-25 11:45:34")

# they look the same
x
y

# but they are actually different
?unclass()
unclass(x) # timestamp expressed in seconds, it's a number!!! (since 01-01-1970 00:00:00)
unclass(y) # list of elements!!!

is.list(y)

#a Date() calculates based on days, not seconds
x2 <- as.Date("2019-12-25")
x2
unclass(x2) # number of days, considering leap years

library(chron)
# Practical usage without time zones

class(x3)
x3 <- chron("12/25/2019", "23:34:09")
x3
typeof(x3)
class(x3)
unclass(x3) #??? similar to as.Date()


# -------------------------------------------------------- CONVERTING CHARACTERS TO DATE with strptime()

?strptime() # it works with vectors
# format os the most important element. check the abbreviations!!!

a <- as.character(c("1993-12-30 23:45",
                    "1994-11-05 11:43",
                    "1992-03-09 21:54"))
a
# the vector must me consistent!!!

typeof(a)

b <- strptime(a, format="%Y-%m-%d %H:%M")
b
class(b) # posix
unclass(b[1]) # POSIXlt, it is a list

# -------------------------------------------------------- LUBRIDATE (most convenient way for time series)

library(lubridate)

# Main Uses of the lubridate package:
# Date and time based calculations 
# Advanced format conversion
# Changing the time zone
# Checking for leap years

# the functions
x <- ymd(19931123)
dmy(23111993)
mdy(11231993)

typeof(x) # it's a double
unclass(x) # number of days since 1970

y <- ymd(19700101)
x - y 

mytimepoint <- ymd_hm("1993-11-23 11:23", 
                      tz="Europe/Rome")
mytimepoint
class(mytimepoint) # posixct date-time class. As we saw before, this can be used to do calculations (so it is double)

minute(mytimepoint)
hour(mytimepoint)
second(mytimepoint)
day(mytimepoint)
month(mytimepoint)
year(mytimepoint)

OlsonNames()
# calculate the weekday of a given date
wday(mytimepoint) # 1 is sunday!!!!
wday(mytimepoint, label=T, abbr = F)
?wday()

with_tz(mytimepoint, tz = "Europe/London") # changing the time zone, from rome to london

# interval() calculates the interval between two points in time. the class of data is "interval"
# the "interval" class is unique to the lubridate package
?interval()

# -------------------------------------------------------- LUBRIDATE EXERCISES

# exercise 1: using lubridate on a dataframe
# create a dataframe with separate date and time columns

measurement <- round(rnorm(10, mean=10, sd=2),2)

date <- c("11-05-1995",
          "12-05-1995",
          "13-05-1995",
          "14-05-1995",
          "15/05/1995",
          "16-05-1995",
          "17-05-1995",
          18051995,
          "19-05-1995",
          "10-05-1995")

date <- dmy(date, tz="CET") # it is an intelliget fucntion
date

b <- c("22 05 05",
       "22 06 05",
       "22 07 05",
       "22 08 05",
       "22 09 05",
       "22 10 05",
       "22 11 05",
       "22 12 05",
       "22 13 05",
       "22 14 05")
b <- hms(b)

df <- data.frame(Date=date, Time=b, Measurement=measurement)
df


# date and time calculations
minutes(7) # PERIOD CLASS
minutes(7.5) # error

dminutes(7) # translation from minutes to seconds (DURATION CLASS)
dminutes(7.5)

minutes(7) + seconds(5)
minutes(7) + seconds(75)

# class duration to perform additions
as.duration(minutes(7) + seconds(75))
leap_year(2009:2014)

ymd(20160101) +  years(1) # years adds a unit to year of the data output
dyears(1)
ymd(20160101) +  dyears(1) # + 365, not 366!!! be careful with leap years when using the duration class


# be careful: year and dyear are different (the latter is cumulative)


# date manipulation with lubridate

x <- ymd_hm(201411050929, tz="CET")
x

# change the minuto of x to 7 in the same line of code

?minute()

# change the minute to 7
minute(x) <- 7
x

# see what time would be in london
with_tz(x, tzone = "Europe/London")

# create a time point in 2015 and get the difference

y <- ymd_hms("20151205050030", tz="CET")

diff <- y - x
class(diff)















