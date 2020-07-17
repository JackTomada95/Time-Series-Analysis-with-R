library(seasonal)


# there is a variety of quantitative models to use for time series. Some of them are 100 years old
# there ar both linear and non-linear models
# linear models are the most used ones.


# LINEAR MODELS
########### 1. simple linear models
# naive, mean and drift method...
#... if there is a pattern (seasonality, trends) they are not good
# but they do a good job in modeling random data (they can be used as benchmark for other complex models)

############ 2. exponential smoothing
# they put more weight on recent observations and they work well on seasonal data.


############ 3. arima
# explains patterns in the data based on autoregression. It can be used for seasonal data as well.


############ 4. seasonal decomposition
# they require the dataset to be of a seasonal nature
# there must be a minimim number of seasonal cycles. Not as popular as arima and exponential smoothing


# NON-LINEAR MODELS:


############ 5. Neural Networks (very important)

############ 6. SVM (limited)

############ 7. Clustering (kml package)


# Exponential Smoothing and ARIMA are very flexible and work well with univariate time series

###############################################################################
# seasonal decomposition intro
# if there is a seasonal component, there are many models you can choose.
# Seasonal Decomposition makes sense only if there is a seasonal component

# Seasonal Decomposition decomposes seasonal time series data to its components: trend, seasonality and remainders
# additive method (adds components up, constant seasonal components) and multiplicative method (multiplies components)

# drawbacks of seasonal decomposition:
# 1. NA values
# 2. Slow to catch sudden changes (fast raises in the dataset)
# 3. constant seasonality ( strong assumption)
# but there are many alternative methods


### example: decomposing a time series
plot(nottem)
# the nottem dataset has stable seasonality and no trend, so it can be perfectly described with an additive model.
# whenever you use the decompose function, make sure the dataset has a predetermined frequency
frequency(nottem) # 12 months (units for each month)
length(nottem) / 12 #??? 20 years

decompose(nottem, type = "additive")
# x is the original dataset
# then we have trends, seasonality and noise except for beginning and end

plot(decompose(nottem, type = "additive"))
# interpretation:
# no trend (the mean is constant) and clear seasonality (constant over the whole time series)

library(ggplot2)
library(forecast)
autoplot(decompose(nottem, type = "additive"))

plot(stl(nottem, s.window = "periodic"))
dec <- stl(nottem, s.window = "periodic") # same, but they are on the columns

# seasonal adjustement
# extract the seasonal adjusted dataset
mynottem <- decompose(nottem, "additive")

class(mynottem)

nottemadjusted <- nottem - mynottem$seasonal

plot(nottemadjusted) # no more seasonality, it looks like a random time series, exaclty what we want
# there is no trend with it
plot(mynottem$seasonal)

# with the stl function, you can forecast a decomposed time series
plot(stlf(nottem, method = "arima"))

# Decomposition exercise
myts <- AirPassengers
autoplot(myts)
frequency(myts)

# there is a trend AND seasonality

mymodel1 <- decompose(myts, type = "additive")
mymodel2 <- decompose(myts, type = "multiplicative")

plot(mymodel1) # there is some pattern left in the remainder (that is not a good sign)
plot(mymodel2) # this part is different, it looks more random, but there are still some patterns. But more information is extracted


adjusted.ap <- myts - mymodel1$seasonal
autoplot(adjusted.ap) # plot(mymodel1$trend - mymodel1$random) is the same
# there is still a pattern. exponential smoothing could work better
autoplot(myts)

################## simple moving average
# if you have a time series it is helpful to smooth the data:
# it means you get the dataset to be closer to the average and reduce the highs and lows
# in other words, you decrease the impat of extreme values
# classic smoother: simple moving average (used in science, trading etc)
# if you have an SME of 3, it means you take the average of three successive time periods and take the average
# periods = successive values in a time series

library(TTR)

x <- c(1,2,3,4,5,6,7)
SMA(x, n = 3)


lynx.smooth <- SMA(lynx, n = 9)

plot(lynx)
plot(lynx.smooth)
#Y this method is only useful if you have a non-seasonal dataset
# this method is very useful to get the general trend and removing white noise

################## exponential smoothing with ETS
# very popular system that does a great job in modeling time series data
# the goal of exponential smoothing is to describe the time series with three parameters:
# Error - additive, multiplicative (multiplicative is only possible if all x > 0)
# Trend - non-present, additive, multiplicative
# Seasonality - non-present, additive, multiplicative

# parameters can be mixed (e.g. additive trend with multiplicative seasonality)

# with exponential smoothing, you put more weight on recent observations.
# for most scenarios, it makes perfect sense
# ses() simple exponential smoothing (data without trends and seasonality)
# holt() for datasets with a trend but without seasonality
# argument "dumped" to damp down (estinguere) the trend over time
# holt-winters exponential smoothing hw() for data with trend and seasonal component + a damping parameter

# AUTOMATED MODEL SELECTION: ets() from the forecast library
# model selection based on informatio criterion
# models can be customized

# for the three parameters (errors, seasonality and trend) there are smoothing coefficients
# these coefficients tell you iif the model relies more on recent data or not (high coefficient ~ 1)
# smooth coefficient ~ 0 (it means all the data are important, not only the recent ones)
# these smoothing coefficients are:
# 1. alpha Initial level
# 2. beta Trend
# 3. gamma Seasonality
# 4. phi Damped parameter

library(forecast)

# nottem is seasonal with no trend
plot(nottem)

etsmodel <- ets(nottem)
etsmodel
# note: ETS(A,N,A), exactly what we expect (no trend)
# this is a smooth model

plot(nottem, lwd = 2)
lines(etsmodel$fitted, col = "red")
# the fitted value are close to the original one.

autoplot(forecast(etsmodel, h = 12))
autoplot(forecast(etsmodel, h = 12, level = 95))

# manually setting the ets model (multiplicative, automatic, multiplicative)

etsmodel.man <- ets(nottem, model = "MZM")
etsmodel.man
# the aic is higher, hence the model is worse than the previous one
plot(nottem, lwd = 2)
lines(etsmodel$fitted, col = "red")
lines(etsmodel.man$fitted, col = "green")























