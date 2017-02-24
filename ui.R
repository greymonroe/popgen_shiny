
library(shiny)
options("scipen"=100, "digits"=4)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Selection of novel allele"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
    
      numericInput("n", 
                 label = "Population size (n)",
                step=10,
                value = 1000),
      
      numericInput("s", 
                  label = "Selection coefficent on 'a' allele (s)",
                  max=1,
                  min=-1,
                  step=0.00001,
                  value = 0),
      
      numericInput("u", 
                  label = "Mutation rate of 'a' allele (u)",
                  step=0.00001,
                  value = 0.0001),
      
            actionButton("goButton", "start/restart")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("freqPlot")
    )
  )
))
