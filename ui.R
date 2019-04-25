# Mary Tucker 
# April 24 2019 

library(shiny)
library(shinyAce)
library(supernova)
library(mosaic)
library(ggformula)
library(DT)
library(Lock5withR)
library(fivethirtyeight)
library(shinyjs)

# Define server logic to plot various variables in the spring 2018 data 

shinyServer(function(input, output, session) {
  
  # activate submit button only when students have typed in the console
  observe({
    shinyjs::toggleState("submit", !is.null(input$code) && input$code != "")
  })
  
  # capture output from students' code
  # note: right now this can only take one object at a time
  makeData <- reactive({
    eval(parse(text = input$code))
  })

  # render console output 
  output$output <- renderPrint({
    input$submit
    return(isolate(eval(parse(text = input$code))))
  })

  # render table output 
  output$table <- DT::renderDataTable({
    input$submit
    return(isolate(eval(parse(text = input$code))))
  })
  
  # render plots
  output$plot <- renderPlot({
    input$submit
    return(isolate(eval(parse(text = input$code))))
  })
  
  # download code from script window 
  output$downloadCode <- downloadHandler(
    filename = function() {
      paste("code-", Sys.Date(), ".txt", sep = "")
    },
    content = function(file) {
      writeLines(paste(input$code, collapse = " "), file)
    }
  )
  
  # download table as csv
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(makeData(), file, row.names = FALSE)
    }
  )
  
  # download plots as png
  output$downloadPlot<- downloadHandler(
    filename = function() {
      paste("plot-", Sys.Date(), ".png", sep = "")
    }, 
    content = function(file) {
      png(file)
      print(makeData())
      dev.off()
    })
  
})

