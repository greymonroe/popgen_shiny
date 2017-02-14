#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  n<-1000
  
  observeEvent(input$goButton, {
  
  dummy <- reactiveValues(
    generation=0,
    A_freq=1,
    simresults=data.frame(generation=0, a_freq=0),
    pop=rep("A", n)
  )
    
 
  output$freqPlot <- renderPlot({
    plot(dummy$simresults$generation, dummy$simresults$a_freq, type="l", xlab="Generation", ylab="Frequency of a allele")
    })
    
  observe({ 
    s<-input$s
    u<-input$u
    isolate({
      A_alleles<-which(dummy$pop=="A")
      mutation<-sample(c(0,1), size=length(A_alleles), replace=TRUE, prob=c(1-u,u))
      if (1 %in% mutation){
        mutations<-which(mutation==1)
        dummy$pop[A_alleles[mutations]]<-"a"
      }
      
      A_alleles2<-which(dummy$pop=="A")
      a_alleles<-which(dummy$pop=="a")
      
      if (s>=0) {
      dummy$pop<-c(rep(dummy$pop[A_alleles2], 9), 
                 rep(dummy$pop[a_alleles], 9+sample(c(0,1), size=length(a_alleles), prob=c(1-s,s), replace=T)))
      dummy$pop<-dummy$pop[sample(1:length(dummy$pop), n)]
      }
      
      if (s<0) {
        s<--s0
        dummy$pop<-c(rep(dummy$pop[a_alleles], 9), 
               rep(dummy$pop[A_alleles2], 9+sample(c(0,1), size=length(A_alleles2), prob=c(1-s,s), replace=T)))
        dummy$pop<-dummy$pop[sample(1:length(dummy$pop), n)]
      }
      
      dummy$generation<-dummy$generation+1
      outrow<-list(generation=dummy$generation, a_freq=sum(dummy$pop=="a")/n)
      dummy$simresults<-rbind(dummy$simresults, outrow)
      dummy$A_freq<-sum(dummy$pop=="A")/n
  })
    
    if (isolate(dummy$A_freq)!=0) {
      invalidateLater(0, session)
    }
  
})
  })
})
  