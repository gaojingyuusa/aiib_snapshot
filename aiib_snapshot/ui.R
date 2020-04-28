#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(flexdashboard)
library(readr)
library(leaflet)
library(DT)
library(tidyverse)
library(lubridate)
library(plotly)
library(zoo)
library(plyr)
library(WDI)
library(tidyr)
source("functions.R",local=F)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel(
        fluidRow(
            
            column(6,
                   h1(" "),
                   img(src="aiib_logo.png", height="100")
                   
            ),
            column(3,
                   h4(" ")
            )
            
        )
              ),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("database","Database",choices=c("WDI","IMF IFS"), multiple=F),
            
            # Indicator responsive to database selection
            selectInput("ind","Indicator",
                        choices=wdi_name,"GDP (current US$)", multiple = T),
            # Year responsive to indicator selection
            selectInput("year","Year",choices=seq(1990, 2019,1)),
            
            # Groups not responsive to any of above indicator selections
            selectInput("group","Groups",choices=c("AIIB Members","AIIB Regional Members","AIIB Non-Regional Members"))
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
