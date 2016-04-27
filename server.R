# server
options(shiny.maxRequestSize=100*1024^2) 
source("160418-geneset-fry.R")
source("160414lmEffects.R")
library(limma)
library(org.Hs.eg.db)
library(GO.db)
.matvec <- limma:::.matvec
shinyServer(function(input,output,session) {
  
  updateSelectizeInput(session, "goSets", choices = goTerms, server = TRUE)
  
  output$geneSetInput = renderText({
    if (is.null(input$goSets)) return(NULL)
    # names(goTerms[goTerms==input$goSets])
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
  
  output$fryTable <- renderTable({
    if (input$run == TRUE) {
      gene.sets <- as.list(GO)[input$goSets]
      gene.sets <- gene.sets[! sapply(gene.sets, is.null)]
      # print(gene.sets)
      # idx <- ids2indices(gene.sets, exprs.filt$genes$Entrez_Gene_ID)
      cnt <- read.table(input$counts$name)
      des <- read.table(input$design$name)
      idx <- ids2indices(gene.sets, rownames(cnt))
      fry( cnt, design =des, index = idx)
    }
  })
  
})
