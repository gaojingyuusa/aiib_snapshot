#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    source("reactive.R", local=T)
    source("functions.R",local=T)
    output$world_total <- renderTable({
        world_total()
    })
    output$aiib_table <- renderTable({
        aiib_table()
    })
    output$aiib_metrics <- renderTable({
        aiib_metrics()
    })
})
