#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(shinycustomloader)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    source("reactive.R", local=T)
    source("functions.R",local=T)
    output$world_total <- renderTable({
        world_total()
    })
    output$aiib_table <- renderFormattable({
        aiib_table() %>% select(-iso3c,-time) %>% arrange(desc(value)) %>% formattable(align = c("l","r","l"),
            list(value=color_bar("#FF8C78"),
                 status = formatter("span",
                                        style = x ~ style(color = ifelse(x=="regional",  "#8F1305", "#CCAD37")),
                                        x ~ icontext(ifelse(x=="regional", "", ""), ifelse(x=="regional", "Regional", "Non-regional")))
                 )
        )
    })
    output$aiib_metrics <- renderTable({
        aiib_metrics()
    })
    output$aiib_result_fig <- renderPlotly({
        aiib_result_fig()
    })
    output$aiib_metrics_ts <- renderTable({
        aiib_metrics_ts()
    })
    output$fg <- renderPlotly({
        fg()
    })
})
