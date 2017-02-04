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
  titlePanel("Example Shiny App (assignment 3)"),
  h4("This is the example Shiny application created in the scope of assigment for Data Product course on Coursera."),
  span("To show some features of Shiny app we'll create out test dataset for classification. 
       We can choose the method of creating dataset when classes are linearely separeted, separated by quadratic or sinusoidal function."),
  span("Then we train classification task by SVM (support vector machine) and show some results."),br(),
  strong("To begin with - select dataset generation method (you can regenerate given dataset if you want), then click Learn SVM model."),
  br(),br(),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("dataType", "Select type of dataset", c("linear", "quadratic", "sinusoidal"),
                  selected="linear"),
      sliderInput("size", "Number of observations", min=50, max=1000, step=10, value=300),
      sliderInput("noise", "Noise", min=0, max=0.5, step=0.01, value=0),
      actionButton("regenerateBtn", label="Regenerate dataset"),
      br(), br(),
      actionButton("learnSVM", label="Learn SVM model"),
      checkboxInput("showVectors", "Show support vectors")
    ),

    mainPanel(
       plotOutput("distPlot")
    )
  )
))
