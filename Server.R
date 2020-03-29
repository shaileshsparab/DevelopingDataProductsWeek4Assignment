
library(shiny)
library(HistData)
data(GaltonFamilies)
library(dplyr)
library(ggplot2)

# 1st step: pass inches to cm
mainData <- GaltonFamilies
mainData <- mainData %>% mutate(father=father*2.54,
                    mother=mother*2.54,
                    childHeight=childHeight*2.54)

# linear model
model1 <- lm(childHeight ~ father + mother + gender + childNum, data=mainData)

shinyServer(function(input, output) {
  output$pText <- renderText({
    paste("Father's height is",
          strong(round(input$intFh, 1)),
          "cm, and mother's height is",
          strong(round(input$intMh, 1)),
          "cm, then:")
  })
  output$pred <- renderText({
    df <- data.frame(father=input$intFh,
                     mother=input$intMh,
                     childNum = input$intcN,
                     gender=factor(input$intGen, levels=levels(mainData$gender)))
    ch <- predict(model1, newdata=df)
    NoOfCh <- ifelse(input$intcN == 1, "st", ifelse(input$intcN == 2,"nd",ifelse(input$intcN == 3 , "rd","th")))
    kid <- ifelse(
      input$intGen=="female",
      "Daugther",
      "Son"
    )
    paste0(strong(input$intcN),strong(NoOfCh)," ", em(strong(kid)),
           "'s predicted height is going to be around ",
           em(strong(round(ch))),
           " cm"
    )
  })
  output$Plot <- renderPlot({
    kid <- ifelse(
      input$intGen=="female",
      "Daugther",
      "Son"
    )
    df <- data.frame(father=input$intFh,
                     mother=input$intMh,
                     childNum = input$intcN,
                     gender=factor(input$intGen, levels=levels(mainData$gender))
                     )
    ch <- predict(model1, newdata=df)
    yvals <- c("Father", kid, "Mother")
    df <- data.frame(
      x = factor(yvals, levels = yvals, ordered = TRUE),
      y = c(input$intFh, ch, input$intMh))
     ggplot(df, aes(x=x, y=y)) +
      geom_bar(color=c("yellow4", "seagreen4", "violetred"), fill=c("yellow", "seagreen", "violet"), stat="identity", width=0.5) +
      xlab("") +
      ylab("Height (cm)") +
      theme_minimal() +
      theme(legend.position="none")
  })
})