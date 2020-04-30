# This script is used to store all reactive variables created for AIIB snapshot


## Data and Figures at One Time Point
# World summary: either average or total
world_total <- reactive({
  WDI_clean(country = "WLD", indicator = WDI_rename(input$ind), start=input$year, end=input$year)
})

# AIIB data: datapoints for AIIB members
aiib_table <- reactive({
  WDI_clean(country = aiib$iso, indicator = WDI_rename(input$ind),start=input$year, end=input$year) %>% merge(aiib,by.x="iso3c",by.y="iso")
})

# AIIB data results: comparing the AIIB - Regional vs Non-Regional vs Rest of the World
aiib_metrics <- reactive({
  world <- WDI_clean(country = "WLD", indicator = WDI_rename(input$ind),start=input$year, end=input$year)[,1:2]
  colnames(world)[1] <- "status"
  if(input$metrics=="Total"){
    aiib_sum <- aggregate(value ~ status, data = aiib_table(), sum)
    non_aiib <- data.frame(
      status = "Others",
      value = world[1,"value"]-sum(aiib_sum$value),
      stringsAsFactors = F
    )
    rbind(aiib_sum,non_aiib)
  } else {
    rbind(aggregate(value ~ status, data = aiib_table(), mean),world) 
  }
})

aiib_result_fig <- reactive({
  if(input$metrics=="Total"){
    aiib_metrics() %>% plot_ly(label =~status, values=~value, marker=list(colors=c("#CCAD37","#8F1305","grey"))) %>% add_pie(hole=0.6) %>% 
    layout(title=paste0("Value in: ",input$year),showlegend = F, 
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  } else {
    aiib_metrics() %>% plot_ly(
      x = ~status,
      y = ~value,
      marker=list(colors=c("#CCAD37","#8F1305","grey")),
      name = "AIIB VS Rest of the World",
      type = "bar",
      text = ~value %>% as.numeric() %>% round(2)
    ) %>% 
      layout(title=paste0("Value in: ",input$year),showlegend = F)
  }
})

## Data and Figures for All Historical Time Series
# World Time Series
world_ts <- reactive({
  WDI_clean(country = "WLD", indicator = WDI_rename(input$ind), NULL, NULL)[,1:3]
})

# AIIB Time Series
aiib_table_ts <- reactive({
  WDI_clean(country = aiib$iso, indicator = WDI_rename(input$ind),start=NULL, end=NULL) %>% merge(aiib,by.x="iso3c",by.y="iso")
})

# AIIB By Membership Summary
aiib_metrics_ts <- reactive({
  world_ts <- WDI_clean(country = "WLD", indicator = WDI_rename(input$ind), NULL, NULL)[,1:3]
  colnames(world_ts)[1] <- "status"
  
  if(input$metrics=="Total"){
    aggregate(value ~ status + time,data=aiib_table_ts(),sum) %>% rbind(world_ts) %>% spread(status,value)
  } else {
    aggregate(value ~ status + time,data=aiib_table_ts(),mean) %>% rbind(world_ts) %>% spread(status,value)
  }
})

test_fg <- reactive({
  
  fig <- plot_ly(aiib_metrics_ts(), x = ~time) %>% 
    add_trace(y = aiib_metrics_ts()[,2] , type = 'scatter', mode = 'lines', line = list(color = '#CCAD37', width = 2, name="Non-Regional")) %>%
    add_trace(y = ~regional, type = 'scatter', mode = 'lines', line = list(color = '#8F1305', width = 4), name="Regional") %>%
    add_trace(y = ~World, type = 'scatter', mode = 'lines', line = list(color = 'grey', width = 2), name="World")
  
  fig <- fig %>% layout(
    title = "Historical Values", 
    showlegend = F,
    xaxis = list(
      title = ""
    ),
    yaxis = list(
      title = ""
    )
    
  )
  
  fig
#  fig <- fig %>% add_trace(x = ~c(x[1], x[12]), y = ~c(y_television[1], y_television[12]), type = 'scatter', mode = 'markers', marker = list(color = 'rgba(67,67,67,1)', size = 8)) 
 # fig <- fig %>% add_trace(x = ~c(x[1], x[12]), y = ~c(y_internet[1], y_internet[12]), type = 'scatter', mode = 'markers', marker = list(color = 'rgba(49,130,189, 1)', size = 12)) 
#  fig <- fig %>% layout(annotations = internet_1) 
 # fig <- fig %>% layout(annotations = television_2) 
  #fig <- fig %>% layout(annotations = internet_2)
})