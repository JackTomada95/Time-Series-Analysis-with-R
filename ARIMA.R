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





















