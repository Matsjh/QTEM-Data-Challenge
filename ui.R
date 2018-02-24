# User interface
library(shiny)

ui <- fluidPage(sidebarLayout(sidebarPanel(titlePanel("QTEM Data Challenge"),
                                           
                              # Input Panel
                                           selectInput(inputId = "selection", label = "Select Brand",
                                                       choices = c("Budweiser","Stella Artois", "Hoegaarden")),
                                           
                                           actionButton("update","Change"),
                              hr(),
                              textInput(inputId = "auth", label =  "Facebook API Auth Token", value = "")),
                              
                              # Output Panel
                              mainPanel(textOutput("test"),
                                        plotOutput("plot.cloud"),
                                        plotOutput("plot.model")
                                        )
                              )
                )
