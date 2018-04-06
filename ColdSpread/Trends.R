library(gtrendsR)

## using gtrendsR to return merged data frame( 2 columns: date, region's hits) for the region(s)
Trends <- function( keyword, regionStrings, numberOfRegions) {
  
  if(numberOfRegions == 1){
    result <- gtrends(keyword, geo = regionStrings)$interest_over_time
    result <- data.frame(result["date"], result["hits"])
    colnames(result)<-c("date", regionStrings)
  }
  else{
    result <- gtrends(keyword, geo = regionStrings[1])$interest_over_time
    result <- data.frame(result["date"], result["hits"])
    colnames(result)<-c("date", regionStrings[1])
    for (i in 2:numberOfRegions) {
          newRegion <- gtrends(keyword, geo = regionStrings[i])$interest_over_time
          newRegion <- data.frame(newRegion["date"], newRegion["hits"])
          colnames(newRegion)<-c("date", regionStrings[i])
          result <- merge(result, newRegion, by.x = "date", by.y = "date")
    }
  }
  return(result)
  
}

## first column dates and each following column should be a hits column 
PlotTrends <- function( TrendsFrame, PlotTitle) {
  colorz = heat.colors(length(colnames(TrendsFrame)))
  yVect = TrendsFrame[2]
  result <- plot(x = TrendsFrame[,1], 
                 y = TrendsFrame[,2], 
                 col = colorz[1], main = PlotTitle, type = "l",
                 xlab = "Date", ylab = "Hits")
  if(length(colnames(TrendsFrame)) > 2){
    par(new=TRUE)
    for(i in 3:length(colnames(TrendsFrame))){
      result <- plot(x = TrendsFrame[,1], 
                     y = TrendsFrame[,i], 
                     col = colorz[i], type = "l", 
                     xlab = " ",ylab = "")
    }
  }
  return(result)
}

#Read in data
readStateColdData <- function(){
  StateColdData <- read.csv("StateColdTrends.csv", header = TRUE)
  StateColdData$date <- as.Date(StateColdData$date)
  return(StateColdData)
}

readStateCodeData <- function(){
  StateCodeData <- read.csv("stateCodes.csv", header = TRUE)
  return (StateCodeData)
}

stringToStateCode <- function(stateString, StateCodeData){
  stateIndex = which(StateCodeData$stateName == stateString)
  result = toString(StateCodeData$Code[stateIndex])
  return(result)
}

stateHits <- function(selectDate, stateCode, StateColdData){
  dateIndex = which(StateColdData$date == selectDate)
  stateIndex = which(colnames(StateColdData) == stateCode)
  selectState <- StateColdData[,stateIndex]
  result = selectState[dateIndex]
  return(result)
}

constructDataForDate <- function(selectDate, StateCodeData, StateColdData){
  numberOfStatePolygons <- length(StateCodeData$stateName)
  region <- StateCodeData$stateName
  stateHits <- 1:numberOfStatePolygons
  for (i in 1:numberOfStatePolygons){
    stateCode <- stringToStateCode(region[i], StateCodeData)
    stateHits[i] <- stateHits(selectDate, stateCode, StateColdData)
  }
  result <- data.frame(region, as.numeric(stateHits))
  colnames(result) <- c('region', "hits")
  return(result)
}
  