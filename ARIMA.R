# AutoRegressive Integrated Moving Average
# used to model any univeriate time series

########################## THEORY
# can capture any univariate time series dataset

# here, we will focus on UNIVARIATE, NON SEASONAL ARIMA MODELS
# generally, the ARIMA model has three parameters

# ARIMA (p, d, q): 
# 1. the Autoregressive part, p
# 2. the Integration part, degree of differencing, d
# 3. the moving average part, q
# these three parameters are integers denoting the grade or order of the three parts

# ARIMA models require stationary time series, so the model will make stationary for you with differencing
# so, if you use a non-stationary model, it will, differencing will be applied until you get a stationary model
# you let the arima function do the differencing during the modeling

# auto.arima() is great for beginners <- it automatically calculates the parameters and chooses a suitable model
library(forecast)
?auto.arima()
# Remember: ARIMA is very flexible, but exponential smoothing is better with seasonal datasets

# How to read an arima model??
# Summation of lags = autoregressive part
# Summation of forecasting errors = moving average part
# Coefficient: determines the importance of a specific lag

############################ Practice
plot(lynx)
tsdisplay(lynx)
# it is an autoregressive dataset: the variable influence itself
# we do not need differencing, the dataset is stationary

auto.arima(lynx)
# we get an arima (2, 0, 2), which is in line with the initial plot, which looks autoregressive
# we also get AIC and the values for the parameter coefficients

 
auto.arima(lynx, trace = T) # list of alternative models, really helpful

# recommended settings (ARIMA 4,0,0 is the best one)
auto.arima(lynx, trace = T, stepwise = F, approximation = F)

plot(forecast(auto.arima(lynx)))

# ARIMA model calculations
# we will manually reproduce an ARIMA model
# lynx dataset and arima(2, 0, 0)
# arima(2, 0, 0) = ARMA(2, 0) = AR(2)

# we basically have a simple autoregressive model, which explains the future by regressing the past
# it goes back in time, checks its own results and does a forecast
# the forecasted variable is also the source of the forecast


## arima calculations
myarima <- arima(lynx, order = c(2,0,0))
myarima
# how do we write down the model?

tail(lynx)
residuals(myarima) # difference between the fitted value and the actual one
# when you do forecasting, you don't have this value availabe, that's why kalman filter exists

# check the equation
# be careful!!! the intercept is not the constant you are looking for, it is the mean!!!!
# still, we can use the mean in the equation, that changes a bit (check the slides)

x <- (2657 - 1545.45) * 1.1474 - (1590 - 1545.45) * 0.6 + 601.84
y <- 3396 - 1545.45

round(x, 0) == round(y, 0) # they are the same, we predicted the last value (3396)

##################### how it works if it is a moving average model?
myarima <- arima(lynx, order = c(0,0,2))
myarima
residuals(myarima)
# the formula changes, you use the errors

x <- 1.1407 * 844.7172211 + 0.4697 * 255.911 + 766.8305
y <- 3396 - 1545.3670

round(x, 0) == round(y, 0)

# the differencing step consists in subtracting the consecutive observations from each other to get a stationary dataset
# when you have forecasts, error terms and autoregressive terms need to be probabilistically estimated prior to modeling

################### Simulating ARIMA
# why are simulations important?
# they are an important toolset in research. They are useful to find out how new procedures and tests perform on different datasets
# you use simulations to LEARN about new topics by trial and error and test how something reacts on a given dataset

# now we want to simulate ARIMA time series models with R
# arima.sim()

set.seed(123)

asim <- arima.sim(model = list(order = c(1,0,1),
                               ar = c(0.4),
                               ma = c(0.3)),
                  n = 1000) + 10 # 10 is the constant

plot(asim) # no trend, no seasonality

library(zoo)
plot(rollmean(asim, 50)) # 50 days moving average
plot(rollmean(asim, 25))
# there is no trend/seasonality

library(tseries)
adf.test(asim) # it is stationary
tsdisplay(asim)

auto.arima(asim,
           trace = T,
           stepwise = F,
           approximation = F) # confirmed by auto.arima (almost exactly the same things we entered in the simulation)


###################### MANUAL ARIMA PARAMETER SELECTION
# auto.arima automatically selects the pdq for you
# the functions arima() and Arima() allow you to manually select the parameters

# arima() does not calculate the constant if you have a differencing step in your model
# therefore, we will use Arima() from the forecast package

plot(lynx)
# we know there is autoregression in it

# we test for stationarity
adf.test(lynx) # it is stationary
# stationarity means we can set the mid parameter to zero -> arima(p, 0, q)
# we are left with p and q

tsdisplay(lynx)
# there is autocorrelation
# generally, the acf plot tells you the lags for MA parameter q
# and pacf tells you the lags for AR, hence parameter p
# however, they communicate with each other, it means if you select one parameter they are both affected

myarima <- Arima(lynx, order = c(2, 0, 0)) # autoregressive model of second order
myarima$aicc
# checkresiduals() is very important:
# the most important thing is the acf plot, which shows significance at lag 7, 9 and 19
# we need to adjust the model: we could increase the ma part or the ar part
checkresiduals(myarima)


myarima <- Arima(lynx, order = c(3, 0, 0)) # autoregressive model of third order
myarima$aicc # a bit higher, it disqualifies the new model alone

myarima <- Arima(lynx, order = c(4, 0, 0)) # autoregressive model of fourth order
myarima$aicc # better
checkresiduals(myarima) # lags are within the threshold, vut the residuals don't look normal, but they are close
# with this fourth order model, there is no more autoregression in the acf plot

# an example with moving average:
set.seed(123)

myts <- arima.sim(model = list(order = c(0,0,2),
                               ma = c(0.3, 0.7)),
                  n = 1000) + 10
plot(myts)

adf.test(myts) # it is stationary
tsdisplay(myts) # pacf has many bars outside the threshold
# in general you start modeling from the parameter that shows less bars outside the threshold

myarima <- Arima(myts, order = c(0,0,2))
checkresiduals(myarima)
# residuals are normally distributed and there is only one aotocorrelated lag, which is reasonable
myarima$aicc

myarima <- Arima(myts, order = c(0,0,3))
checkresiduals(myarima)
myarima$aicc # no, it's higher

myarima <- Arima(myts, order = c(2,0,3))
checkresiduals(myarima)
myarima$aicc 

auto.arima(myts, trace = T, stepwise = T, approximation = F)

# how to identify ARIMA model parameters
# some rules that help you identify the right model
# three categories

### 1. parameter d
# if you see significant lag in the pacf plot, add +1 step to d
# you do it because you want to avoid a high number (8 or higher) for the p parameter (autoregression)
# no further differencing is required if: non-significant 1st lag in a pacf plot or autocorrelation in pacf appears random

# as we already discussed, the value of d tells you a lot about the data
# d = 0 stationary (constant)
# d = 1 there is a trend
# d = 2 varying trend (no constant)

### 2. parameters p and q (which interact quite a bit)
# add +1 step to p if the pacf plot shows positive significance at lag 1 or sharp cutoff between sig and non sig lags
# add +1 step to q if the acf plot shows negative significance at lag 1 or sharp cutoff between sig and non sig lags

# AR and MA are correlated, so test them separately
# furthermore, if the summation of p and q COEFFICIENTS is close to 1, add +1 in d

### 3. seasonal parameters P D Q
# set D to 1 if you see a strong seasonal pattern
# add +1 to P if a positive significant lag is present in ALL seasonal cycles
# add +1 to Q if a negative significant lag is present in ALL seasonal cycles
# positive autocorrelation likely occurs in datasets with non-constant seasonal effect and no seasonal differencing

# ALWAYS test and compare different models with the AICc and residual diagnostics

############################## ARIMA forecasting
# once you have decided the model, you forecast
library(forecast)
myarima <- auto.arima(lynx,
                      stepwise = F,
                      approximation = F)
myarima # 4th order autoregression

arima.for <- forecast(myarima, h = 10)
plot(arima.for)

# see the forecasted value
arima.for$mean

# zooming
plot(arima.for, xlim = c(1930,1944))

library(ggplot2)
myets <- ets(lynx)
ets.for <- forecast(myets, h = 10)

autoplot(lynx) +
  autolayer(ets.for$mean,
            series = "ETS model") +
  autolayer(arima.for$mean,
            series = "ARIMA model") +
  xlab("year") + 
  ylab("Lynx Trappings") +
  guides(colour = guide_legend(title = "Forecast Method")) +
  theme(legend.position = c(0.8, 0.8))

myets$aicc  
myarima$aicc #much better





















