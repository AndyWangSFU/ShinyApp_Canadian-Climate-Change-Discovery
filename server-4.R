# Stat 240 - Shiny APP
# Andy Wang 301329429
library(shiny)
library(shinythemes)
library(RColorBrewer)
library(ggplot2)
library(viridis)
library(viridisLite)
load("CanadianPrecip.Rdata")
load("CanadianAvgSnow.Rdata")
load("CanadianMaxTemp.Rdata")
load("CanadianMeanTemp.Rdata")
load("CanadianMinTemp.Rdata")

# This was taught by TA Gabe
AllPrecip[AllPrecip==-9999.9] = NA
AllSnow[AllSnow==-9999.9] = NA
MaxTemp[MaxTemp==-9999.9] = NA
MeanTemp[MeanTemp==-9999.9] = NA
MinTemp[MinTemp==-9999.9] = NA

shinyServer(function(input, output) {
  output$snowcplot = renderPlot({
      # Plot on the snowfall
      
    temp = AllSnow[AllSnow$`InfoTemp[3]`==input$Province & AllSnow$Year==input$slider_year,]
    temp_month = temp[,as.numeric(input$slider_month)+1]
  
    temp_month = temp_month[is.na(temp_month)==0]
    check = AllSnow[AllSnow$`InfoTemp[3]`==input$Province,]
    if(min(check$Year)>input$slider_year || length(temp_month)==0){
      output$selected_year2 = renderText({
        "Sorry, there is no data available in this year"
      })
      return()
    }
    else{
      output$selected_year2 = renderText({
        ""
      })

      hist(temp_month, col = 'lightgreen', border = 'brown',
           probability = TRUE,breaks = 20,xlab = "Snowfall (mm)" ,
           main = paste("Amount of Snowfall in", input$Province,"(",names(temp)[as.numeric(input$slider_month)+1],input$slider_year, ")"))

           # Density line
      if(input$DensityLogical){
        temp1 = temp_month
        if(input$BoundaryCorrect ){  #input$BoundaryCorrect comes from the conditional panel
          xuse = c(-temp1,temp1)
          Dens = density(xuse,from = 0)
          Dens$y = Dens$y*2
        }else{
          Dens = density(temp1)
        }
        lines(Dens,col = 'blue')
      }}
  })
  
  # Plot on the Raining
  output$Precplot = renderPlot({
    temp = AllPrecip[AllPrecip$`InfoTemp[3]`== input$Province & AllPrecip$Year==input$slider_year,]
    temp_month = temp[,as.numeric(input$slider_month) + 1]
    #if out of range
    temp_month = temp_month[is.na(temp_month)==0]
    check = AllPrecip[AllPrecip$`InfoTemp[3]`==input$Province,]
    if(length(temp_month)==0){
      output$selected_year1 = renderText({
        "Sorry, there is no data available in this year"
      })
      return()
    }
    else{
      output$selected_year1 = renderText({
        ""
      })
      hist(temp_month, col = 'lightgreen', border = 'brown',
           probability = TRUE,breaks = 20,xlab = "Precipitation (mm)" ,
           main = paste("Amount of Raining in", input$Province,"(",names(temp)[as.numeric(input$slider_month)+1],input$slider_year, ")"))

      if(input$DensityLogical){
        temp1 = temp_month
        if(input$BoundaryCorrect ){  #input$BoundaryCorrect comes from the conditional panel
          xuse = c(-temp1,temp1)
          Dens = density(xuse,from = 0)
          Dens$y = Dens$y*2
        }else{
          Dens = density(temp1)
        }
        lines(Dens,col = 'red')
      }}
  })
  
  # Information on the temperature
  output$circleurbar_plot = renderPlot({
    MaxTemp[MaxTemp==-9999.9] = NA
    MeanTemp[MeanTemp==-9999.9] = NA
    MinTemp[MinTemp==-9999.9] = NA
    if(input$temp_choice == 'Maximum_temp'){
      
      temp1 = MaxTemp[MaxTemp$Year== input$slider_year3,]
      temp1 = na.omit(temp1)
      data1 = aggregate(temp1[,2:13],by =list(temp1$`InfoTemp[3]`),FUN = max)
      avg_data = data.frame(province=data1[,1], Temperature=apply((data1[,-1]),1,max))
      ggplot(data = avg_data, aes(x =province, y=Temperature))+ geom_bar(stat="identity")+ coord_cartesian(ylim = c(0,35))+ geom_col(aes(fill = Temperature)) +
        scale_fill_distiller(breaks = c(-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35),palette = "GnBu",limits=c(-40,40)) +  labs(temp = "Province") +
        xlab("Provinces") + ylab("Temperature (°C)")
      
    }
    else if (input$temp_choice == 'Minimum_temp'){
      temp1 = MinTemp[MinTemp$Year== input$slider_year3,]
      temp1 = na.omit(temp1)
      data1= aggregate(temp1[,2:13],by =list(temp1$`InfoTemp[3]`),FUN = min)
      avg_data = data.frame(province=data1[,1], Temperature=apply((data1[,-1]),1,min))
      ggplot(data = avg_data, aes(x=province, y=Temperature))+ geom_bar(stat="identity")+
        coord_cartesian(ylim = c(-50.1,0))+ geom_col(aes(fill = Temperature)) +
        scale_fill_distiller(breaks = c(-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35), palette = "GnBu",limits=c(-40,40)) +  labs(temp = "Province") +
        xlab("Provinces") + ylab("Temperature (°C)")
    }
    else{
      temp1 = MeanTemp[MeanTemp$Year== input$slider_year3,]
      temp1 = na.omit(temp1)
      data1= aggregate(temp1[,2:13],by =list(temp1$`InfoTemp[3]`),FUN = mean)
      avg_data = data.frame(province=data1[,1], Temperature=rowMeans(data1[,-1]))
      ggplot(data = avg_data, aes(x =province, y=Temperature))+ geom_bar(stat="identity")+
        coord_cartesian(ylim = c(-15, 15))+geom_col(aes(fill = Temperature)) +
        scale_fill_distiller(breaks = c(-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35), palette = "GnBu",limits=c(-40,40)) +  labs(temp = "Province") +
        xlab("Provinces") + ylab("Temperature (°C)")
    }
  })
})
