#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      numericInput("n", label = h3("Population size"), value=1000),
      numericInput("s", label = h3("Selection coefficent (s)"), value=0),
      numericInput("u", label = h3("Mutation rate"), value=0.0001),
      actionButton("goButton", "start/restart")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("freqPlot")
    )
  )
))
