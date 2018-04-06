#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(maps)
library(RColorBrewer)

source("Trends.R")

StateCodeData <- readStateCodeData()
StateColdData <- readStateColdData()
  

# Define UI for application that draws a histogram
ui <- fluidPage(
    
   # Application title
     sidebarPanel( fill = "100%",
            h1("Cold Spread in the United States", width = "100%", align = 'center'),
            h1("Select Date Index:", width = "100%", align = 'center'),
            h6("*only Sundays after 11-25-2012 are valid", align = 'center'),
            h1(dateInput(inputId = "date", label = "", value = StateColdData$date[1]), 
               align = 'center', width = "66%"),
            position = "left"),
     ##sliderInput( inputId = "date", label = "",min = 1, 
       ##  max = length(StateColdData$date), value = 90, width = "100%")
     

   # Show a plot of the generated distribution
  mainPanel(leafletOutput("mapPlot", width = "100%"), width = 8)
   
)
  

# Define server logic required to draw a histogram
server <- function(input, output) {

  monthString <- function(month)({
    monthNames <- c("January", "February", "March", "April", "May",
                    "June", "July", "August", "September", "October",
                    "November", "December")
    return (monthNames[month])
  })
  
  checkDate <- reactive({
    index <- which(StateColdData$date == input$date)
    if(index == 0)
    ({
      input$date <- StateColdData$date[1]
    })
  })
  
  output$Date <- renderText(toString(input$date))
  

  
  
   output$mapPlot <- renderLeaflet({
      # generate map based on input$date from ui.R
     checkDate()
     inputDate <- input$date
     df <- constructDataForDate(inputDate, StateCodeData, StateColdData)
     bins <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
     pal <- colorBin("YlOrRd", domain = df$hits, bins = bins)
     mapStates = map("state", region = df$region, fill = TRUE, plot = FALSE)
     leaflet(data = mapStates) %>% addTiles() %>%
       addPolygons(fillColor = ~pal(df$hits), weight = 2,  
          smoothFactor = 0.2, fillOpacity = 0.7) %>% 
          addLegend("bottomright", pal = pal, values = ~df$hits, opacity = 1,
          title = "'Cold Symptoms'")
   })
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)

