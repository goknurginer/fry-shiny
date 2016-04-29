# server
options(shiny.maxRequestSize=100*1024^2) 
shinyServer(function(input,output,session) {
  updateSelectizeInput(session, "goSets", choices = goTerms, server = TRUE)
  
  applyGS <- eventReactive(input$run, {
    if(input$database == 'GO') {
      if(is.null(input$goSets) & !(input$allGeneSets)) return(NULL) 
      else if (!input$allGeneSets & !is.null(input$goSets)) input$goSets
      else goTerms
    }
    
    if (input$database == 'KEGG') {
      if(is.null(input$keggSets) & !(input$allGeneSets)) return(NULL) 
      else if (!input$allGeneSets & !is.null(input$keggSets)) input$keggSets
      else keggsets
    }
    
    if (input$database == 'MsigDB') {
      if(is.null(input$MsigSets) & !(input$allGeneSets)) return(NULL) 
      else if (!input$allGeneSets & !is.null(input$MsigSets)) input$MsigSets
      else msigsets
    }
  })

  output$fryTable <- renderDataTable({
    gene.sets <- as.list(GO)[applyGS()]
    gene.sets <- gene.sets[! sapply(gene.sets, is.null)]
    cnt <- read.table(input$counts$name)
    des <- read.table(input$design$name)
    idx <- ids2indices(gene.sets, rownames(cnt))
    fry <- fry(cnt, design =des, index = idx, sort="directional")
    format(fry, scientific = TRUE, digits = 3)
  }, 
    options = list(orderClasses = TRUE))
  
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
  
})
