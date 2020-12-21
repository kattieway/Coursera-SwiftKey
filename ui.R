
  library(shiny)
  library(shinyWidgets)
  
  
ui <- shinyUI(fluidPage(
     titlePanel("Application which predicts the next word you will use"),

     sidebarLayout(
          sidebarPanel(
               textInput("str",label = h3("Please write some text here:"),value = ""),
               sliderInput("n",label = h3("Add a number of words you want to be predicted:"),
                            min = 1,max = 5,value = 3,step = 1)
               
          )
          ,
          mainPanel(
               tabsetPanel(type = "tabs",
                           tabPanel("Main",
                                    h2("The next word is:"),
                                    h4(textOutput("predict",container = pre))
                                    )
                           
               )
          )
     )
))






