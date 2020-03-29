library(shiny)

shinyUI(fluidPage(
  titlePanel("Prediction of Next Gen height", "Prediction of Next Gen height"),
  sidebarLayout(
    sidebarPanel(
      helpText("Prediction of the child's height considering gender and parent's height"),
      helpText("Parameters:"),
      sliderInput(inputId = "intFh",
                  label = "Select Father's height (cm):",
                  value = 155,
                  min = 150,
                  max = 250,
                  step = 1),
      sliderInput(inputId = "intMh",
                  label = "Select Mother's height (cm):",
                  value = 145,
                  min = 140,
                  max = 200,
                  step = 1),
      numericInput(inputId = "intcN", label = "Select Child Number", value = 1, min = 1, max = 5, step = NA,
                   width = NULL),
      radioButtons(inputId = "intGen",
                   label = "Select Child's gender: ",
                   choices = c("Female"="female", "Male"="male"),
                   inline = TRUE)
    ),
    
    mainPanel(
      htmlOutput("pText"),
      htmlOutput("pred"),
      plotOutput("Plot", width = "40%")
    )
  )
))