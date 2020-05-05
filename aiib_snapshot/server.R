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
    
    output$year_select <- renderText({
        year_select()
    })
    
    output$indicator_select <- renderText({
        indicator_select()
    })
    
    output$groups_select <- renderText({
        groups_select()
    })
    
    
    
    
    
    
    
    
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
  
      
    output$asia_table <- renderTable({
        asia_table()
    })
#    output$asia_result_fig <- renderPlotly({
#        asia_result_fig()
#    })
    output$asia_metrics_ts <- renderTable({
        asia_metrics_ts()
    })
 #   output$fig_asia_region <- renderPlotly({
 #       fig_asia_region()
 #   })
    
    
    output$WBG_income_table <- renderTable({
        WBG_income_table()
    })
 #   output$wbg_income_result_fig <- renderPlotly({
 #       wbg_income_result_fig()
  #  })
    output$wbg_income_table_ts <-renderTable({
        wbg_income_table_ts()
    })
 #   output$fg_wbg_income <- renderPlotly({
  #      fg_wbg_income()
  #  })
    
    
    output$WBG_region_table <-renderTable({
        WBG_region_table()
    })
  #  output$wbg_region_result_fig <-renderPlotly({
   #     wbg_region_result_fig()
   # })
    output$wbg_region_table_ts <-renderTable({
        wbg_region_table_ts()
    })
#    output$fg_wbg_region <- renderPlotly({
#        fg_wbg_region()
#    })
    
    
    output$fig_other_groups_result <- renderPlotly({
        fig_other_groups_result()
    })
    
    output$fig_other_groups_ts <- renderPlotly({
        fig_other_groups_ts()
    })
    
    
    output$tb_other_groups_result <- renderTable({
        tb_other_groups_result()
    })
    
    output$tb_other_groups_ts <- renderTable({
        tb_other_groups_ts()
    })
    
    
    
    
    
    output$dl_share<- downloadHandler(
        filename = function() { 
            paste("aiib_world_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(aiib_metrics(), file)
        })
    
    output$dl_historical<- downloadHandler(
        filename = function() { 
            paste("aiib_historical_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(aiib_metrics(), file)
        })
    
    output$dl_table<- downloadHandler(
        filename = function() { 
            paste("aiib_economies_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            
            
            shiny::withProgress(
                message = paste0("Downloading"),
                value = 0,
                {
                    shiny::incProgress(1/10)
                    Sys.sleep(1)
                    shiny::incProgress(5/10)
                    write.csv(aiib_table_ts(), file)
                }
            )
        })
    
    
    output$dl_share_groups <- downloadHandler(
        filename = function() { 
            paste("groups_world_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(tb_other_groups_result(), file)
        })
    
    output$dl_share_groups_ts <- downloadHandler(
        filename = function() { 
            paste("groups_historical_", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(tb_other_groups_ts(), file)
        })
    
    
    
    output$aiib_map <- renderPlotly({
        
        LAND_ISO <- aiib_map$iso
        name <- aiib_map$country
        value <- ifelse(aiib_map$status=="regional",1,0)
        infor <- aiib_map$status
        
        data <- data.frame(LAND_ISO, value, name, infor, stringsAsFactors = F) 
   #     data[nrow(data) + 1,] = list(iso_code(input$TARGET),0, input$TARGET)
        #   data$name <- name_code(data$LAND_ISO)
        
        # Run your code:
        g <- list(
            showframe = FALSE,
            showland = TRUE,
            landcolor = "grey",
            showcoastlines = FALSE,
            projection = list(type = 'orthographic'),
            resolution = '100',
            showcountries = TRUE,
            countrycolor = "white",
            showocean = TRUE,
            oceancolor = '#F2F2F2',
            showlakes = TRUE,
            lakecolor = '#DBDBDB'
        )
        
        plot_geo(data) %>%
            add_trace(
                z = ~value, locations = ~LAND_ISO,
                color = ~value, colors = c('#CCAD37','#8F1305'),
                showscale=FALSE, text=~paste(data$name,"\n","Membership Status: ",CapStr(data$infor)),hoverinfo="text", hoverlabel=list(bgcolor="white")
            ) %>% 
            layout(geo = g, showlegend = T, hovermode = 'closest',margin=list(t=0,b=0,l=0,r=0,pad=0),plot_bgcolor="#8F1305")
    })
    
    
    
    
    
    
    
    
    
    
    
})
