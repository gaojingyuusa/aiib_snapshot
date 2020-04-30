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
library(formattable)
source("functions.R",local=F)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Style options
    tags$style(HTML("
    .tabbable > .nav > li > a[data-value='Charts'] {background-color: #8f1305;  color:white}
    .tabbable > .nav > li > a[data-value='Table'] {background-color: #ccad37;   color:white}
    ")),
    
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
            
        ),
        h1(" ")
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
                        choices=seq(1990, 2018,1),selected=2015),
            
            # Groups not responsive to any of above indicator selections
    #        selectInput("group",
     #                   shiny::HTML("<p><span style='color: white;font-size:20px'>Group</span></p>"),
      #                  choices=c("AIIB Members","AIIB Regional Members","AIIB Non-Regional Members")),
            
            selectInput("metrics",
                        shiny::HTML("<p><span style='color: white;font-size:16px'>Metrics</span></p>"),
                        choices=c("Total","Average"), selected="Total"),
            
            h1(" "),
            h4("Developed by the Economics Unit of the Asian Infrastructure Investment Bank.",style="color:white"),
            width = 3
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
          
          tabsetPanel(type="tabs",
                        
          tabPanel("Charts",
            
            h1(" "),
            h2(strong("Welcome to AIIBasics!"),style="color:#8F1305"),
   
            fluidRow(
              column(3,
                     h4(strong("Share by AIIB and World"))
                     ),
              column(4,
                     h4(strong("Historical Values"))
                     ),
              column(5,
                     h4(strong("Values by AIIB Members"))
                    )
              
            ),
            
            fluidRow(
              column(3,
                    downloadButton("dl_share","Download Data Sources", class="butt1",
                                   tags$head(tags$style(".butt1{background-color:#8f1305;color:white;}")))
              ),
              column(4,
                     downloadButton("dl_table","Download Data Sources", class="butt1",
                                    tags$head(tags$style(".butt1{background-color:#8f1305;color:white;}")))
              ),
              column(5,
                     downloadButton("dl_historical","Download Data Sources", class="butt1",
                                    tags$head(tags$style(".butt1{background-color:#8f1305;color:white;}")))
              )
              
            ),
            
            
            fluidRow(
                column(3,
                       withLoader(plotlyOutput("aiib_result_fig"), type="image",loader="aiib_spinner.gif")
                       ),
                column(4,
                       withLoader(plotlyOutput("fg"), type="image", loader="aiib_spinner.gif")
                       ),
                column(5,
                       formattableOutput("aiib_table")
                       )
                
                     )
                  ),
          
          
          tabPanel("Table",
            tableOutput("world_total"),
            tableOutput("aiib_metrics"),
     #       plotlyOutput("aiib_result_fig"),
            tableOutput("aiib_metrics_ts"),
            
          )
                     )
           
        )
    )
))
