library(lubridate)
library(astsa)
library(forecast)
source("Trends.R")

# sdSmooth divide by surrounding standard deviation
sdSmooth <- function(Residuals){
  
  result = 1:240
  i = 11
  result = 0
  while(i < 250){
    result[(i-10)] <- sd(Residuals[(i-10):(i+10)])
    i = i + 1
  }
  
  return(result)
}


## Calculate seasonal effect of 24 annual periods  
## approx. 2-week (15 day periods)
## fit polynomial to averages from periods
seasonality <- function(Residuals, dates){
  day = 0
  month = 0
  periods = 12 * 2
  seasonalData <- data.frame( Sum <- (1:periods), Elements <- (1:periods), 
                              Effect <- (1:periods))
  colnames(seasonalData) <- c("Sum", "Elements", "Effects")
  seasonalData$Sum = 0
  seasonalData$Elements = 0
  seasonalData$Effects = 0
  i = 1
  period = 0
  # Calculate seasonal effects
  while(i < length(Residuals) + 1){
    month = as.numeric(substr(as.character(dates[i]),6,7))
    day = as.numeric(substr(as.character(dates[i]),9,10))
    period = ( month - 1) * 2 
    if(day < 16){
      period = period + 1
    }
    else{
        period = period + 2
    }
    seasonalData$Sum[period] = seasonalData$Sum[period] + Residuals[i]
    seasonalData$Elements[period] = seasonalData$Elements[period] + 1
    i = i + 1
  }
  ## create array from seasonal effects
  seasonalData$Effects <- seasonalData$Sum / seasonalData$Elements
  seasonalData$Effects <- fitted(lm(seasonalData$Effects ~ poly( (1:periods), degree = 5, raw = T)))
  seasonalEffects <- array(dim = 260)
  i = 1
  
  ## create array same length as residuals with corresponding dates for seasonality
  ## effect
  while(i < length(Residuals) + 1){
    month = as.numeric(substr(as.character(dates[i]),6,7))
    day = as.numeric(substr(as.character(dates[i]),9,10))
    period = ( month - 1) * 2
    if(day < 16){
      period = period + 1
    }
    else{
      period = period + 2
    }
    seasonalEffects[i] <- seasonalData$Effects[period]
    i = i + 1
  }
  return(seasonalEffects)
}


# read in california data google trends: "Cold Symptoms", geo = "US-CA"
CA <- read.csv("CaColds.csv")
CA <- data.frame(CA$date, CA$US.CA)
colnames(CA) <- c("date", "hits")



# Fit drift term
CalHits <- ts(CA$hits, frequency = 365.25/7, start=decimal_date(ymd(CA$date[1])))
t <- 1:length(CalHits)
lsfit <- lm(CalHits~t)
trend <- lsfit$fitted.values
CalDrift <- ts(trend, frequency = 365.25/7,  start=decimal_date(ymd(CA$date[1])))

# Fit seasonal term (first try weekly then try bimonthly)
CalTrendRes <- ts( (CalHits - CalDrift), frequency = 365.25/7, 
                   start=decimal_date(ymd(CA$date[1])))

Seasons <- seasonality(CalTrendRes, CA$date)

CalSeasonality <- ts(Seasons, frequency = 365.25/7,
                     start = decimal_date(ymd(CA$date[1])))

CalSmooth <- CalDrift + CalSeasonality

## Begin fitting rough part
CalRough <- CalHits - CalSmooth

#/## try false seasonal
fit <- auto.arima(CalRough, max.p = 5, max.q = 4, seasonal = FALSE, approximation = FALSE)

forecastSeries <- forecast(fit)
newResiduals <- CalHits - (CalSmooth + forecastSeries$fitted)

averageSd <- sdSmooth(newResiduals)



