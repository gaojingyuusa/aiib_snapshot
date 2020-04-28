# This script is used to store all reactive variables created for AIIB snapshot

# World summary: either average or total
world_total <- reactive({
  WDI_clean(country = "WLD", indicator = WDI_rename(input$ind), start=input$year, end=input$year)
})

# AIIB data: datapoints for AIIB members
aiib_table <- reactive({
  WDI_clean(country = aiib$iso, indicator = WDI_rename(input$ind),start=input$year, end=input$year) %>% merge(aiib,by.x="iso3c",by.y="iso")
})

aiib_metrics <- reactive({
  if(input$metrics=="Total"){
    aggregate(value ~ status, data = aiib_table(), sum)
  } else {
    aggregate(value ~ status, data = aiib_table(), mean)
  }
})