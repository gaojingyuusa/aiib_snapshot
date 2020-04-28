

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
library(dplyr)

# import aiib identifiers
aiib <- read.csv("aiib_members.csv",stringsAsFactors = F)[,2:3]

# import wdi indicator list
wdi <- read.csv("wdi_list.csv",stringsAsFactors = F) %>% unique()
wdi_name <- wdi[,1]

# function to retrieve cleaned WDI series
WDI_clean <- function(country, indicator, start, end){
  temp <- WDI(country = country,indicator=indicator,start=start,end=end,extra = T)
  names(temp)[names(temp) == 'year'] <- 'time'
  names(temp)[names(temp) == indicator] <- 'value'
  temp <- temp[order(temp$time),]
  temp$ind <- indicator
  temp %>% select(country,value,time,iso3c)
}

# function to convert wdi indicator to code
WDI_rename <- function(name){
  wdi[wdi$indicator==name,"indicatorcode"]
}

#WDI_clean(country = aiib$iso, indicator = "SP.POP.65UP.TO.ZS", start=2015, end=2015)
