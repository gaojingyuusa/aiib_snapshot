

# import libraries
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

# import aiib identifiers
aiib <- read.csv("aiib_members.csv",stringsAsFactors = F)

# import wdi indicator list
wdi <- read.csv("wdi_list.csv",stringsAsFactors = F) %>% unique()
wdi_name <- wdi[,1]

# function to retrieve cleaned WDI series
WDI_clean <- function(country, indicator, start, end){
  temp <- WDI(country = country,indicator=indicator,start=start,end=end)
  names(temp)[names(temp) == 'year'] <- 'time'
  names(temp)[names(temp) == indicator] <- 'value'
  temp <- temp[order(temp$time),]
  temp$ind <- indicator
  return(temp)
}

# function to convert wdi indicator to code
WDI_rename <- function(name){
  wdi[wdi$indicator==name,"indicatorcode"]
}

#WDI_clean(country = aiib$iso, indicator = "SP.POP.65UP.TO.ZS", start=2015, end=2015)
