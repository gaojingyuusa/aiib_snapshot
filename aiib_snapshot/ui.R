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
library(lazyeval)
library(plotly)
library(shinycustomloader)
source("functions.R",local=F)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Style options
    
    
    # Application title
    titlePanel(
        fluidRow(
            
            column(6,
#                   h1(" "),
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
            tags$style(".well {background-color:#8f1305;}"),
       #     selectInput("database",
        #                shiny::HTML("<p><span style='color: white;font-size:20px'>Database</span></p>"),
         #               choices=c("WDI","IMF IFS"), multiple=F),
            
            # Indicator responsive to database selection
            selectInput("ind",
                        shiny::HTML("<p><span style='color: white;font-size:16px'>Indicator</span></p>"),
                        choices=wdi_name,"GDP (current US$)", multiple = F),
            # Year responsive to indicator selection
            selectInput("year",
                        shiny::HTML("<p><span style='color: white;font-size:16px'>Year</span></p>"),
                        choices=seq(1990, 2019,1),selected=2015),
            
            # Groups not responsive to any of above indicator selections
    #        selectInput("group",
     #                   shiny::HTML("<p><span style='color: white;font-size:20px'>Group</span></p>"),
      #                  choices=c("AIIB Members","AIIB Regional Members","AIIB Non-Regional Members")),
            
            selectInput("metrics",
                        shiny::HTML("<p><span style='color: white;font-size:16px'>Group</span></p>"),
                        choices=c("Total","Average"), selected="Total"),
            width = 3
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
                column(4,
                       withLoader(plotlyOutput("aiib_result_fig"), type="image", loader="aiib_spinner.gif")
                       ),
                column(8,
                       plotlyOutput("test_fig")
                       )
                
            ),
            
            tableOutput("world_total"),
            tableOutput("aiib_metrics"),
     #       plotlyOutput("aiib_result_fig"),
            tableOutput("aiib_metrics_ts"),
            tableOutput("aiib_table")
           
        )
    )
))
