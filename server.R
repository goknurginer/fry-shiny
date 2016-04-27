# server
source("160418-geneset-fry.R")
source("160414lmEffects.R")
library(limma)
library(org.Hs.eg.db)
library(GO.db)
.matvec <- limma:::.matvec
shinyServer(function(input,output,session) {
  
  updateSelectizeInput(session, "goSets", choices = goTerms, server = TRUE)
  
  output$nameOfChoice = renderText({
    names(goTerms[goTerms==input$goSets])
    print(input$goSets)
    })
  
  output$countMatrix <- renderTable({
    inFile <- input$counts
    if (is.null(inFile)) return(NULL)
    read.table(inFile$name)
  })
  
  output$designMatrix <- renderTable({
    inFile <- input$design
    if (is.null(inFile)) return(NULL)
    read.table(inFile$name)
  })
  
  output$geneSetInput <- renderText({
    if (is.null(input$goSets)) return(NULL)
    print(paste(input$goSets))
  })
  
  output$fryTable <- renderTable({
    if (input$run == TRUE) {
      print(input$counts)
      cnt <- read.table(input$counts$name)
      dta <- read.table(input$design$name)
      fry( cnt, design =dta, index = 1:5)
    }
  })
  
})
