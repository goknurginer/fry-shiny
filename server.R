# server
options(shiny.maxRequestSize=100*1024^2) 
msigsets <- names(Hs.H)
shinyServer(function(input,output,session) {
  updateSelectizeInput(session, "goSets", choices = gosets, server = TRUE)

  applyGS <- eventReactive(input$run, {
    
    if(input$database == 'GO') {
      if(is.null(input$goSets) & !(input$allGeneSets)) return(NULL) 
      else if (!input$allGeneSets & !is.null(input$goSets)) input$goSets
      else gosets
    }
    
    else if (input$database == 'MsigDB') {
      if(is.null(input$MsigSets) & !(input$allGeneSets)) return(NULL) 
      else if (!input$allGeneSets & !is.null(input$MsigSets)) input$MsigSets
      else msigsets
    }
    
    else {
      if(is.null(input$keggSets) & !(input$allGeneSets)) return(NULL) 
      else if (!input$allGeneSets & !is.null(input$keggSets)) input$keggSets
      else keggsets
    }
    
  })
  
  output$fryTable <- renderDataTable({
    if(input$database == 'GO') {
      gene.sets <- as.list(GO)[applyGS()]
      gene.sets <- gene.sets[! sapply(gene.sets, is.null)]
      print(gene.sets)
      PathwayName <- names(gosets[gosets %in% names(gene.sets)])
    }
    if(input$database == 'MsigDB') gene.sets <- Hs.H[applyGS()]
    if(input$database == 'KEGG') gene.sets <- KEGG[applyGS()]
    cnt <- read.table(input$counts$name)
    des <- read.table(input$design$name)
    idx <- ids2indices(gene.sets, rownames(cnt))
    fry <- fry(cnt, design =des, index = idx, sort="directional")
    fry.table <- data.frame(PathwayID = rownames(fry), PathwayName = PathwayName, fry) 
    format(fry.table, scientific = TRUE, digits = 3)
  }, 
    options = list(orderClasses = TRUE))
  output$geneSetInput = renderText({
    if (is.null(input$goSets)) return(NULL)
    # names(gosets[gosets==input$goSets])
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
