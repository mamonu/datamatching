library(shiny)

shinyUI(fluidPage(
  titlePanel("Neo4j Data Linkage App"),
  sidebarLayout(
    sidebarPanel(
     
      img(src = "ons.gif", height = 47, width = 239),
      "This is a product of the ", 
      span("Big Data team", style = "color:blue"),
      br(),
      
      
      
      br(),
      
      sliderInput("opacity", "Opacity", 0.6, min = 0.1,
                  max = 1, step = .1)
      
      
    ),
    mainPanel(
      tabsetPanel(
        
        tabPanel("Force Network", forceNetworkOutput("force")),
        tabPanel("NodeTable",     DT::dataTableOutput("mytable"))
        
        
        
        
        
        
      )
      
    )
  )
))
