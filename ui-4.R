# Stat 240 - Shiny APP
# Andy Wang 301329429
library(shiny)
library(shinythemes)
library(RColorBrewer)
library(ggplot2)
library(viridis)
library(viridisLite)

shinyUI(navbarPage(theme = shinytheme("superhero"),
                   titlePanel(strong("Discovery - Canadian Climate Change")),
                   navlistPanel(
                     # Tab 1: Temperature 
                     tabPanel("Analysis: Temperature in Canada",
                              titlePanel("Statistics of Temperature Change (Max/Min/Avg)"),
                              radioButtons("temp_choice", "", c("Max Temperature" = "Maximum_temp", 
                                                                "Min Temperature" = "Minimum_temp","Avg Temperature" = "Average_temp")),
                              sidebarLayout(sidebarPanel(sliderInput("slider_year3",animate = TRUE, "Years:", 1872, 2017, 2017)),
                                            mainPanel(
                                              h2("Temperature Distributed among Provinces"),
                                              helpText(HTML("<h5>Reference: Adjusted and Homogenized Canadian Climate Data (2019), Environment and Climate Change Canada Data.
                                              Data Path: http://data.ec.gc.ca/data/climate/scientificknowledge/adjusted-and-homogenized-canadian-climate-data-ahccd/
                                              </h5>")), plotOutput('circleurbar_plot')
                                            ))),
                     
                     # Tab 2: Rain and Snow 
                     tabPanel("Analysis: Precipitation and snowfall",
                              sidebarLayout(sidebarPanel(
                                # Provinces data is from: https://en.wikipedia.org/wiki/Provinces_and_territories_of_Canada
                                selectInput('Province','Please select a province:', choices = list("Ontario (ON)" = "ON","Quebec (QC)" = "QC","Nova Scotia (NS)" = "NS","New Brunswick (NB)" = "NB","Manitoba (MB)" = "MB","British Columbia (BC)" = "BC",
                                                                                                   "Prince Edward Island (PE)" = "PE","Saskatchewan (SK)" = "SK","Alberta (AB)" = "AB","Newfoundland and Labrador (NL)" = "NL",
                                                                                                   "Northwest Territories (NT)" = "NT","Yukon (YK)" = "YT","Nunavut (NU)" = "NU")
                                            ,selected ='ON'),
                                sliderInput("slider_year",animate = TRUE, "Please choose a year: ", 1840, 2017, 2017),
                                sliderInput("slider_month", animate = TRUE,"Please choose a month:", 1, 12, 12),
                                checkboxInput("DensityLogical", strong("Add a density plot"), FALSE),
                                conditionalPanel(
                                  condition = "input.DensityLogical == true",
                                  helpText(HTML("<h5>Adjust the boundary estimate</h5>")),
                                  checkboxInput("BoundaryCorrect", strong("Correct the density plot at zero"), FALSE) )
                              ),
                              
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Histogram of Precipitation",
                                           h2(textOutput("selected_year1")),
                                           plotOutput("Precplot"),
                                           helpText(HTML("<h5>Reference: Adjusted and Homogenized Canadian Climate Data (2019), Environment and Climate Change Canada Data.
                    Data Path: http://data.ec.gc.ca/data/climate/scientificknowledge/adjusted-and-homogenized-canadian-climate-data-ahccd/  </h5>")) 
                                  ),
                                  
                                  tabPanel("Histogram of Snowfall",
                                           h2(textOutput("selected_year2")),
                                           plotOutput("snowcplot"),
                                           helpText(HTML("<h5>Reference: Adjusted and Homogenized Canadian Climate Data (2019), Environment and Climate Change Canada Data.
                    Data Path: http://data.ec.gc.ca/data/climate/scientificknowledge/adjusted-and-homogenized-canadian-climate-data-ahccd/ </h5>"))
                                  ))))
                     ),
                     # Tab 3: Personal Information
                     tabPanel("Information on the author",source("about.R")$value())
                              ))
)
