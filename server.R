# server
options(shiny.maxRequestSize=100*1024^2) 
msigsets <- names(Hs.H)

shinyServer(function(input,output,session) {
  
  updateSelectizeInput(session, "goSets", choices = gosets, server = TRUE)

  applyGS <- eventReactive(input$run, {
    if(input$database == 'GO') {
      if (!input$allGeneSets & !is.null(input$goSets)) input$goSets
      else if (input$allGeneSets) gosets
    }
    
    else if (input$database == 'MsigDB') {
      if (!input$allGeneSets & !is.null(input$MsigSets)) input$MsigSets
      else if (input$allGeneSets) msigsets
    }
    
    else {
      if (!input$allGeneSets & !is.null(input$keggSets)) input$keggSets
      else if (input$allGeneSets) keggsets
    }
  })
  
  output$fryTable <- renderDataTable({
    # Take a dependency on input$run so the reactive object fryTable now 
    # depends on action button "Aply gene set test"
    input$run
    
    # We use isolate to avoid the dependency on database object. Because we 
    # do not want gene set test to be applied when we pick a different database
    # before we select the gene sets
    database <- isolate(input$database)
    
    if(database == 'GO') gene.sets <- as.list(GO)[applyGS()]
    else if(database == 'KEGG') gene.sets <- KEGG[applyGS()]
    else gene.sets <- Hs.H[applyGS()]
    cnt <- read.table(input$counts$name)
    des <- read.table(input$design$name)
    # is the following step necessary or null sets have already been discarded
    #PathwayName <- names(gosets[gosets %in% names(gene.sets)])
    #gene.sets <- gene.sets[!sapply(gene.sets, is.null)]
    idx <- ids2indices(gene.sets, rownames(cnt))
    idx <- idx[!sapply(idx, is.null)]
    fry <- fry(cnt, design =des, index = idx, sort="directional")
    PathwayID <- rownames(fry)

    if(database == 'GO') {
      m <- match(PathwayID, gosets)
      PathwayName <- names(gosets[m])
      fry.table <- data.frame(PathwayID = PathwayID, 
        PathwayName = PathwayName, fry) 
    }
    else if(database == 'KEGG') {
      m <- match(PathwayID, keggsets)
      PathwayName <- names(keggsets[m])
      fry.table <- data.frame(PathwayID = PathwayID, 
        PathwayName = PathwayName, fry) 
    }
    
    else fry.table <- data.frame(PathwayID = PathwayID, fry) 
    format(fry.table, scientific = TRUE, digits = 3)
  }, options = list(orderClasses = TRUE))
  
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
