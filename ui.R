library(shiny)

shinyUI(fluidPage(
          titlePanel("Eddy Tower Field Check"),
          helpText("This program is designed to check raw data generated from Gradient Eddy tower using 
                   EddyPro software. Upload all 'csv' files from a specific sample period by clicking on 
                   buttons below. Once data has been uploaded click on tabs below to see specific graphs. 
                   You may also select a specific date range or specific soil depth. Errors on page should
                   disappear when all data is uploaded."),
          
          inputPanel(
            uiOutput("daterange")),
            
           mainPanel(
             tabsetPanel(
               tabPanel("Summary", verbatimTextOutput("summary")),
               tabPanel("CO2", plotOutput("plot_CO2", width="150%", height= "500px")),
               tabPanel("H2O", plotOutput("plot_H2O", width="150%", height= "500px")),
               tabPanel("CH4", plotOutput("plot_CH4", width="150%", height= "500px")),
               tabPanel("Turbulance", plotOutput("plot_turbulance", width="150%", height= "500px")),
               tabPanel("Temps", plotOutput("plot_temps", width="150%", height= "500px")),
               tabPanel("Pressure", plotOutput("plot_pressure", width="150%", height= "500px")),
               tabPanel("RH%", plotOutput("plot_rh", width="150%", height= "500px")),
               tabPanel("Footprint 70%", plotOutput("plot_foot70", width="150%", height= "500px")),
               tabPanel("Footprint 90%", plotOutput("plot_foot90", width="150%", height= "500px")),
               tabPanel("Rad Long", plotOutput("plot_longwave", width="150%", height= "500px")),
               tabPanel("Rad Short", plotOutput("plot_shortwave", width="150%", height= "500px")),
               tabPanel("Rad Net", plotOutput("plot_netrad", width="150%", height= "500px")),
               tabPanel("Soil Moist", plotOutput("plot_soilmoist", width="150%", height= "500px")),
               tabPanel("Soil Temps 1", plotOutput("plot_soil_temp1", width="150%", height= "500px")),
               tabPanel("Soil Temps 2", plotOutput("plot_soil_temp2", width="150%", height= "500px")),
               tabPanel("Snow", plotOutput("plot_snow", width="150%", height= "500px")),
               tabPanel("PAR", plotOutput("plot_par", width="150%", height= "500px"))
               
               )
               
    )
  )
)


