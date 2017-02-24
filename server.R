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

  
  observeEvent(input$goButton, {
  n<-isolate(input$n)
  dummy <- reactiveValues(
    generation=0,
    A_freq=1,
    simresults=data.frame(generation=0, a_freq=0),
    pop=rep("A", n),
    plot_labels=data.frame(gen=0, selection=input$s, mutation=input$u)
  )
  
  observeEvent(c(input$u,input$s), {
    isolate({generation<-dummy$generation})
    dummy$plot_labels <-rbind(dummy$plot_labels, data.frame(gen=generation, selection=input$s, mutation=input$u))
  })
    
 
  output$freqPlot <- renderPlot({
    plot(dummy$simresults$generation, dummy$simresults$a_freq, type="l", xlab="Generation", ylab="Frequency of a allele", main=paste("Population size of", n))
    abline(v=dummy$plot_labels$gen, col="red")
    text(dummy$plot_labels$gen, 0.9*max(dummy$simresults$a_freq), paste("s =", dummy$plot_labels$selection))
    text(dummy$plot_labels$gen, 0.8*max(dummy$simresults$a_freq), paste("u =", dummy$plot_labels$mutation))
    
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
        s<--s
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
  