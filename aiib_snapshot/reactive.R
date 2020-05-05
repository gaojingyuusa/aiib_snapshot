# This script is used to store all reactive variables created for AIIB snapshot

## Chart styles

#font
font_t <- list(
  family = "arial",
  size = 12,
  color = "black")


## Texualize input items

year_select <- reactive({
  input$year
})

indicator_select <- reactive({
  input$ind
})

groups_select <- reactive({
  input$groups
})

## Data and Figures at One Time Point
# World summary: either average or total
world_total <- reactive({
  WDI_clean(country = "WLD", indicator = WDI_rename(input$ind), start=input$year, end=input$year)
})

# AIIB data: datapoints for AIIB members
aiib_table <- reactive({
  aiib_table_econ <- WDI_clean(country = aiib$iso, indicator = WDI_rename(input$ind),start=input$year, end=input$year) %>% merge(aiib,by.x="iso3c",by.y="iso") 
  colnames(aiib_table_econ)[2] <- "economy"
  aiib_table_econ
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
    aiib_metrics() %>% mutate(pie_label=CapStr(status)) %>% plot_ly(label =~status, values=~value, text=c("Non-regional","Regional","Rest of the World"),
                                                                    hovertemplate = "%{text}: <br>Value: %{value} </br>", 
                                                                    marker=list(colors=c("#CCAD37","#8F1305","grey"))) %>% 
    add_pie(hole=0.6) %>% 
    layout(
      margin=list(t=0,b=0,l=0,r=0),
      #title=paste0("Share of World Total in: ",input$year),showlegend = F, font=font_t, 
      showlegend = F,
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  } else {
    aiib_metrics() %>% mutate(bar_label=CapStr(status)) %>% plot_ly(
      x = ~status,
      y = ~value,
      marker=list(color=c("#CCAD37","#8F1305","grey")),
      type = "bar",
      text = ~value %>% as.numeric() %>% round(2),
      hovertemplate = "%{x} <br>Value: %{text} </br>"
    ) %>% 
      layout(
      margin=list(t=30,b=0,l=0,r=0),
      #title=paste0("Value in: ",input$year),showlegend = F, font=font_t, 
      xaxis = list(
        title = "", showticklabels=F
      ),
      yaxis = list(
        title = ""
      )
             )
  }
})


# Asia data: datapoints for AIIB members
asia_table <- reactive({
  asia_table_econ <- WDI_clean(country = asia$iso3c, indicator = WDI_rename(input$ind),start=input$year, end=input$year) %>% merge(asia,by="iso3c") 
#  colnames(aiib_table_econ)[2] <- "economy"
  asia_table_econ
})

# Asia data results: comparing the Asia - Asian Subregions vs Rest of the World
asia_metrics <- reactive({
  world <- WDI_clean(country = "WLD", indicator = WDI_rename(input$ind),start=input$year, end=input$year)[,1:2]
  colnames(world)[1] <- "subregion"
  if(input$metrics=="Total"){
    asia_sum <- aggregate(value ~ subregion, data = asia_table(), sum)
    non_asia <- data.frame(
      subregion = "Others",
      value = world[1,"value"]-sum(asia_sum$value),
      stringsAsFactors = F
    )
    rbind(asia_sum,non_asia)
  } else {
    rbind(aggregate(value ~ subregion, data = asia_table(), mean),world) 
  }
})

asia_result_fig <- reactive({
  if(input$metrics=="Total"){
    asia_metrics() %>% plot_ly(label =~subregion, values=~value, text=asia_metrics()$subregion,
                                                                    hovertemplate = "%{text}: <br>Value: %{value} </br>", 
                                                                    marker=list(colors=c("#174752","#47DDFF","#39B1CC","#477680","black"))) %>% 
      add_pie(hole=0.6) %>% 
      layout(
        margin=list(t=0,b=0,l=0,r=0),
        #title=paste0("Share of World Total in: ",input$year),showlegend = F, font=font_t, 
        showlegend = F,
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  } else {
    asia_metrics() %>% plot_ly(
      x = ~subregion,
      y = ~value,
      marker=list(color=c("#174752","#47DDFF","#39B1CC","#477680","black")),
      type = "bar",
      text = ~value %>% as.numeric() %>% round(2),
      hovertemplate = "%{x} <br>Value: %{text} </br>"
    ) %>% 
      layout(
        margin=list(t=30,b=0,l=0,r=0),
        #title=paste0("Value in: ",input$year),showlegend = F, font=font_t, 
        xaxis = list(
          title = "", showticklabels=F
        ),
        yaxis = list(
          title = ""
        )
      )
  }
})

# "#174752","#47DDFF","#39B1CC","#477680","black","#3BFFFA","Grey"


## WBG Income Data and Figures

# WBG Income data: datapoints for WBG Income Levels
WBG_income_table <- reactive({
  wbg_income_table_econ <- WDI_clean(country = c("LIC","LMC","UMC","HIC"), indicator = WDI_rename(input$ind),start=input$year, end=input$year)  
  colnames(wbg_income_table_econ)[4] <- "groups"
  wbg_income_table_econ$groups <- as.character(wbg_income_table_econ$groups)
  wbg_income_table_econ
})

# WBG Income Figures:
wbg_income_result_fig <- reactive({
  if(input$metrics=="Total"){
    WBG_income_table() %>% plot_ly(label =~groups, values=~value, text=c("High","Low","Low Middle","Upper Middle"),
                                                                    hovertemplate = "%{text}: <br>Value: %{value} </br>", 
                                                                    marker=list(colors=c("#174752","#47DDFF","#39B1CC","#477680"))) %>% 
      add_pie(hole=0.6) %>% 
      layout(
        margin=list(t=0,b=0,l=0,r=0),
        #title=paste0("Share of World Total in: ",input$year),showlegend = F, font=font_t, 
        showlegend = F,
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  } else {
    WBG_income_table() %>% plot_ly(
      x = ~country,
      y = ~value,
      marker=list(color=c("#174752","#47DDFF","#39B1CC","#477680")),
      type = "bar",
      text = ~value %>% as.numeric() %>% round(2),
      hovertemplate = "%{x} <br>Value: %{text} </br>"
    ) %>% 
      layout(
        margin=list(t=30,b=0,l=0,r=0),
        #title=paste0("Value in: ",input$year),showlegend = F, font=font_t, 
        xaxis = list(
          title = "", showticklabels=F
        ),
        yaxis = list(
          title = ""
        )
      )
  }
})


## WBG Regional Data and Figures

# WBG Regional data: datapoints for WBG Income Levels
WBG_region_table <- reactive({
  wbg_region_table_econ <- WDI_clean(country = c("EAS","ECS","LCN","MEA","NAC","SAS","SSF"), indicator = WDI_rename(input$ind),start=input$year, end=input$year)  
  colnames(wbg_region_table_econ)[4] <- "groups"
  wbg_region_table_econ$groups <- as.character(wbg_region_table_econ$groups)
  sum_other <- world_total()$value-sum(wbg_region_table_econ$value)
  
  if(input$metrics == "Total"){
    wbg_region_table_econ %>% rbind(data.frame(country="Rest of the World", value = sum_other, time=input$year, groups="ROW", stringsAsFactors = F))
  } else{
    wbg_region_table_econ
  }
  
})

# WBG Regional Figures:
wbg_region_result_fig <- reactive({
  if(input$metrics=="Total"){
    WBG_region_table() %>% plot_ly(label =~country, values=~value, text=WBG_region_table()$country,
                                   hovertemplate = "%{text}: <br>Value: %{value} </br>", 
                                   marker=list(colors=c("#174752","#47DDFF","#39B1CC","#477680","black","#3BFFFA","Grey"))) %>% 
      add_pie(hole=0.6) %>% 
      layout(
        margin=list(t=0,b=0,l=0,r=0),
        #title=paste0("Share of World Total in: ",input$year),showlegend = F, font=font_t, 
        showlegend = F,
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  } else {
    WBG_region_table() %>% plot_ly(
      x = ~country,
      y = ~value,
      marker=list(color=c("#174752","#47DDFF","#39B1CC","#477680","black","pink")),
      type = "bar",
      text = ~value %>% as.numeric() %>% round(2),
      hovertemplate = "%{x} <br>Value: %{text} </br>"
    ) %>% 
      layout(
        margin=list(t=30,b=0,l=0,r=0),
        #title=paste0("Value in: ",input$year),showlegend = F, font=font_t, 
        xaxis = list(
          title = "", showticklabels=F
        ),
        yaxis = list(
          title = ""
        )
      )
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

fg <- reactive({
  fig <- plot_ly(aiib_metrics_ts(), x = ~time) %>% 
    add_trace(y = aiib_metrics_ts()[,2] , type = 'scatter', mode = 'lines', line = list(color = '#CCAD37', width = 2), name="Non-Regional") %>%
    add_trace(y = ~regional, type = 'scatter', mode = 'lines', line = list(color = '#8F1305', width = 4), name="Regional") %>%
    add_trace(y = ~World, type = 'scatter', mode = 'lines', line = list(color = 'grey', width = 2), name="World")
  
  fig <- fig %>% layout(
    margin=list(t=30,b=0,l=0,r=0),
 #   title = "Historical Values",font=font_t,
    showlegend = F,
    xaxis = list(
      title = ""
    ),
    yaxis = list(
      title = ""
    )
    
  )
  fig
})


# WBG Income Time Series
wbg_income_table_ts <- reactive({
  WDI_clean(country = c("LIC","LMC","UMC","HIC"), indicator = WDI_rename(input$ind),start=NULL, end=NULL) %>% select(-country) %>% spread(iso3c, value)
})

fg_wbg_income <- reactive({
  fig_wbg_income <- plot_ly(wbg_income_table_ts(), x = ~time) %>% 
    add_trace(y = wbg_income_table_ts()[,2] , type = 'scatter', mode = 'lines', line = list(color = '#174752', width = 2), name="High Income") %>%
    add_trace(y = wbg_income_table_ts()[,3], type = 'scatter', mode = 'lines', line = list(color = '#47DDFF', width = 2), name="Low Income") %>%
    add_trace(y = wbg_income_table_ts()[,4], type = 'scatter', mode = 'lines', line = list(color = '#39B1CC', width = 2), name="Lower Middle Income") %>%
    add_trace(y = wbg_income_table_ts()[,5], type = 'scatter', mode = 'lines', line = list(color = '#477680', width = 2), name="Upper Middle Income")
  
  fig_wbg_income <- fig_wbg_income %>% layout(
    margin=list(t=30,b=0,l=0,r=0),
    #   title = "Historical Values",font=font_t,
    showlegend = F,
    xaxis = list(
      title = ""
    ),
    yaxis = list(
      title = ""
    )
    
  )
  fig_wbg_income
})


# WBG Region Time Series
wbg_region_table_ts <- reactive({
  WDI_clean(country = c("EAS","ECS","LCN","MEA","NAC","SAS","SSF"), indicator = WDI_rename(input$ind),start=NULL, end=NULL) %>% select(-iso3c) %>% spread(country, value)
})

fg_wbg_region <- reactive({
  fig_wbg_region <- plot_ly(wbg_income_table_ts(), x = ~time) %>% 
    add_trace(y = wbg_region_table_ts()[,2] , type = 'scatter', mode = 'lines', line = list(color = '#174752', width = 2), name="East Asia & Pacific") %>%
    add_trace(y = wbg_region_table_ts()[,3], type = 'scatter', mode = 'lines', line = list(color = '#47DDFF', width = 2), name="Europe & Central Asia") %>%
    add_trace(y = wbg_region_table_ts()[,4], type = 'scatter', mode = 'lines', line = list(color = '#39B1CC', width = 2), name="Latin America & Caribbean") %>%
    add_trace(y = wbg_region_table_ts()[,5], type = 'scatter', mode = 'lines', line = list(color = '#477680', width = 2), name="Middle East & North Africa") %>%
    add_trace(y = wbg_region_table_ts()[,6], type = 'scatter', mode = 'lines', line = list(color = 'black', width = 2), name="South Asia") %>%
    add_trace(y = wbg_region_table_ts()[,6], type = 'scatter', mode = 'lines', line = list(color = '#3BFFFA', width = 2), name="Sub-Saharan Africa")

  fig_wbg_region <- fig_wbg_region %>% layout(
    margin=list(t=30,b=0,l=0,r=0),
    #   title = "Historical Values",font=font_t,
    showlegend = F,
    xaxis = list(
      title = ""
    ),
    yaxis = list(
      title = ""
    )
    
  )
  fig_wbg_region
})



# "#174752","#47DDFF","#39B1CC","#477680"
# Asia Time Series
asia_table_ts <- reactive({
  WDI_clean(country = asia$iso3c, indicator = WDI_rename(input$ind),start=NULL, end=NULL) %>% merge(asia,by.x="iso3c")
})

# Asia By Membership Summary
asia_metrics_ts <- reactive({
  world_ts <- WDI_clean(country = "WLD", indicator = WDI_rename(input$ind), NULL, NULL)[,1:3]
  colnames(world_ts)[1] <- "subregion"
  
  if(input$metrics=="Total"){
    aggregate(value ~ subregion + time,data=asia_table_ts(),sum) %>% rbind(world_ts) %>% spread(subregion,value)
  } else {
    aggregate(value ~ subregion + time,data=asia_table_ts(),mean) %>% rbind(world_ts) %>% spread(subregion,value)
  }
})

# "#174752","#47DDFF","#39B1CC","#477680","black"
fig_asia_region <- reactive({
  fg_asia_region <- plot_ly(asia_metrics_ts(), x = ~time) %>% 
    add_trace(y = asia_metrics_ts()[,2] , type = 'scatter', mode = 'lines', line = list(color = '#174752', width = 2), name="Central Asia") %>%
    add_trace(y = asia_metrics_ts()[,3], type = 'scatter', mode = 'lines', line = list(color = '#47DDFF', width = 4), name="Eastern Asia") %>%
    add_trace(y = asia_metrics_ts()[,4], type = 'scatter', mode = 'lines', line = list(color = '#39B1CC', width = 2), name="South-eastern Asia") %>% 
    add_trace(y = asia_metrics_ts()[,5], type = 'scatter', mode = 'lines', line = list(color = '#477680', width = 2), name="Southern Asia") %>% 
    add_trace(y = asia_metrics_ts()[,6], type = 'scatter', mode = 'lines', line = list(color = 'black', width = 2), name="Western Asia") %>%
    add_trace(y = asia_metrics_ts()[,7], type = 'scatter', mode = 'lines', line = list(color = 'grey', width = 2), name="World") 
    fg_asia_region <- fg_asia_region %>% layout(
    margin=list(t=30,b=0,l=0,r=0),
    #   title = "Historical Values",font=font_t,
    showlegend = F,
    xaxis = list(
      title = ""
    ),
    yaxis = list(
      title = ""
    )
    
  )
 fg_asia_region
})


# Tables dependent on user selection of other groups
tb_other_groups_result <- reactive({
  # "Asian Regions","WBG Income Levels","WBG Regions"
  if(input$groups=="Asian Regions"){
    asia_result_fig()
  } else if (input$groups=="WBG Income Levels"){
    WBG_income_table()
  } else{
    WBG_region_table()
  }
})

tb_other_groups_ts <- reactive({
  # "Asian Regions","WBG Income Levels","WBG Regions"
  if(input$groups=="Asian Regions"){
    asia_metrics_ts()
  } else if (input$groups=="WBG Income Levels"){
    wbg_income_table_ts()
  } else{
    wbg_region_table_ts()
  }
})


# Figures dependent on user selection of other groups
fig_other_groups_result <- reactive({
  # "Asian Regions","WBG Income Levels","WBG Regions"
  if(input$groups=="Asian Regions"){
    asia_result_fig()
  } else if (input$groups=="WBG Income Levels"){
    wbg_income_result_fig()
  } else{
    wbg_region_result_fig()
  }
})

fig_other_groups_ts <- reactive({
  # "Asian Regions","WBG Income Levels","WBG Regions"
  if(input$groups=="Asian Regions"){
    fig_asia_region()
  } else if (input$groups=="WBG Income Levels"){
    fg_wbg_income()
  } else{
    fg_wbg_region()
  }
})