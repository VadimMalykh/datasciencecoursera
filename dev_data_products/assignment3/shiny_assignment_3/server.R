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
library(e1071)
source("lib.R")

shinyServer(function(input, output) {
  
  v <- reactiveValues(df = generateDF("linear", 300, 0), svmDF = NULL)
  
  observeEvent(input$regenerateBtn, {
    v$df <- generateDF(input$dataType, input$size, input$noise)
    v$svmDF <- NULL
    v$vector <- NULL
  })

  observeEvent(input$learnSVM, {
    res <- learnSVMModel(v$df)
    v$svmDF <- res[[1]]
    v$vector <- res[[2]]
  })
  
  output$distPlot <- renderPlot({

    g <- ggplot(v$df, aes(x=X1, y=X2, col=as.factor(Y))) + geom_point()

    if (!is.null(v$svmDF)) {
      g <- g + 
        geom_tile(data=v$svmDF, 
                  mapping=aes(width=0.037, height=0.037, fill=as.factor(Y)),
                  alpha=0.2,
                  show.legend=FALSE)
    }
    if (input$showVectors & !is.null(v$vector)) {
      g <- g +
        geom_point(data=v$df[v$vector,], size=2, color="red", aes(x=X1, y=X2),
                   inherit.aes=FALSE)
    }
    g
  })
})
