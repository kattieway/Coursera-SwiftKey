
library(shiny)
library(data.table)
library(quanteda)

source("getNextWords.R",local = TRUE)

server <- shinyServer(function(input, output) {
     output$predict <- renderText({
          if(input$str=="")
               return("OOPS! I don`t see any words here")
          predictions <- predict_word(input$str, input$n)
          paste0(1:input$n,".",predictions,"\n")
     })
})

