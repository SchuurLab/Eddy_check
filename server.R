library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(data.table)

shinyServer(function(input, output) {
  
  data1 <- reactive({
    isolate({ 
    setwd("./Data/EP_summary")
    #setwd("~/Documents/Post Doc/Schuur/github/Eddy_check/Data/EP_summary")
    # import all files in directory
    filenames <- list.files() 
    #filenames <- list.files(path="~/Documents/Post Doc/Schuur/R Apps/Eddy/Data") 
    dat <- do.call("rbind", lapply(filenames, fread, skip=2))
    dat.names <-  fread(filenames[1])
    names(dat) <- names(dat.names)
    for (i in seq_along(dat)) set(dat, i=which(dat[[i]]==-9999), j=i, value=NA)
    
    })
    dat[, timestamp := paste(date, time, sep=" ")]
    dat[, timestamp := ymd_hms(timestamp)]
    dat[, Date := as.Date(timestamp)]
    #dat <- as.data.frame(dat)
  })


  
  output$summary <- renderPrint({ 
    dataset <- data1()
    str(dataset)
  })

  output$daterange <- renderUI({
    #input$goButton
    #isolate({
    if (is.null(data1)) {
      return(NULL)}
    
    dateRangeInput("daterange", label = h3("Date range"),
                   start = min(data1()$timestamp), end = max(data1()$timestamp),
                   min = min(data1()$timestamp), max = max(data1()$timestamp))  
    #})
  })
  # CO2 flux graph
  output$plot_CO2 <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, co2_flux, colour=factor(qc_co2_flux)))+geom_ribbon(ymin=-15, ymax=15, fill="purple", colour="purple", alpha=0.05)+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  # H2O flux graph
  output$plot_H2O <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, h2o_flux, colour=factor(qc_h2o_flux)))+geom_ribbon(ymin=-15, ymax=15, fill="purple", colour="purple", alpha=0.05)+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  
  # Turbulance graph
  output$plot_turbulance <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, `u*`))+geom_ribbon(ymin=-0.18, ymax=0.18, fill="purple", colour="purple", alpha=0.05)+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })

  # Temperatures graph
  output$plot_temps <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, sonic_temperature - 273.15))+geom_point( aes(colour="Sonic"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, air_t_mean - 273.15, colour="Air"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, TA_1_1_1 - 273.15, colour="Vaisala"),size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  # Pressure graph
  output$plot_pressure <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, air_pressure))+geom_point(size=5, alpha=0.5, aes(colour = "Sonic"))+
      geom_point(aes(timestamp, air_p_mean, colour="LI-7700"),size=5, alpha=0.5)+theme_bw()
    #})
  })

  # Relative humidity
  output$plot_rh <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, RH_1_1_1))+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  # Footprint 70% graph
  output$plot_foot70 <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, `x_70%`))+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  # Footprint 90% graph
  output$plot_foot90 <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, `x_90%`))+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  # PAR graph
  output$plot_par <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, PPFD_1_1_1))+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })
  # Snow graph
  output$plot_snow <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, SNOWD_1_1_1))+geom_point(size=5, alpha=0.5)+theme_bw()
    #})
  })
  # Longwave graph
  output$plot_longwave <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, LWIN_1_1_1))+geom_point( aes(colour="longwave In"),size=5, alpha=0.5)+geom_point(aes(timestamp, LWOUT_1_1_1, colour="Longwave out"),size=5, alpha=0.5)+theme_bw()
    #})
  })
  # Shortwave graph
  output$plot_shortwave <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, SWIN_1_1_1))+geom_point( aes(colour="Shortwave In"),size=5, alpha=0.5)+geom_point(aes(timestamp, SWOUT_1_1_1, colour="Shortwave out"),size=5, alpha=0.5)+theme_bw()
    #})
  })
  # Netrad graph
  output$plot_netrad <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, RN_1_1_1))+geom_point( size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  # Soilmoisture graph
  output$plot_soilmoist <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, SWC_1_1_1))+geom_point( aes(colour="Sensor 1"),size=5, alpha=0.5)+geom_point(aes(timestamp, SWC_2_1_1, colour="Sensor 2"),size=5, alpha=0.5)+theme_bw()
    #})
  })
  # Soil Temperatures 1 graph
  output$plot_soil_temp1 <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, TS_1_1_1 - 273.15))+geom_point( aes(colour="TS_1_1_1"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, TS_2_1_1 - 273.15, colour="TS_2_1_1"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, TS_3_1_1 - 273.15, colour="TS_3_1_1"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, TS_4_1_1 - 273.15, colour="TS_4_1_1"),size=5, alpha=0.5)+theme_bw()
    #})
  })
  # Soil Temperatures 2 graph
  output$plot_soil_temp2 <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, TS_5_1_1 - 273.15))+geom_point( aes(colour="TS_5_1_1"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, TS_6_1_1 - 273.15, colour="TS_6_1_1"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, TS_7_1_1 - 273.15, colour="TS_7_1_1"),size=5, alpha=0.5)+
      geom_point(aes(timestamp, TS_8_1_1 - 273.15, colour="TS_8_1_1"),size=5, alpha=0.5)+theme_bw()
    #})
  })
  
  # CH4 flux graph
  output$plot_CH4 <-  renderPlot({
    
    c <- subset(data1(), Date >= input$daterange[[1]] & Date <= input$daterange[[2]])
    ggplot(c, aes(timestamp, ch4_flux, colour=factor(qc_ch4_flux)))+geom_point(size=5)+theme_bw()#+geom_ribbon(ymin=-10, ymax=10, fill="purple", colour="purple", alpha=0.2)
    #})
  })

})