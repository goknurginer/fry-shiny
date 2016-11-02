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
    
    else if (input$database == 'REACTOME') {
      if (!input$allGeneSets & !is.null(input$reactomeSets)) input$reactomeSets
      else if (input$allGeneSets) reactomesets
    }
    
    else {
      if (!input$allGeneSets & !is.null(input$keggSets)) input$keggSets
      else if (input$allGeneSets) keggsets
    }
  })
  
  databaseInput <- reactive({
    
    # Take a dependency on input$run so the reactive object fryTable now
    # depends on action button "Apply gene set test"
    input$run
    
    # We use isolate to avoid the dependency on database object. Because we
    # do not want gene set test to be applied when we pick a different database
    # before we select the gene sets
    database <- isolate(input$database)
    
    if(database == 'GO') gene.sets <- as.list(GO)[applyGS()]
    
    else if(database == 'KEGG') gene.sets <- KEGG[applyGS()]
    
    else if(database == 'REACTOME') gene.sets <- REACTOME[applyGS()]
    
    else gene.sets <- Hs.H[applyGS()]
    
    if (input$example) {
      cnt <- read.table("dgelist.txt")
      des <- read.table("design.txt")
    }
    else{
      cnt <- read.table(input$counts$name)
      des <- read.table(input$design$name) 
    }
    
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
    
    else if(database == 'KEGG') { m <- match(PathwayID, keggsets)
    PathwayName <- names(keggsets[m])
    fry.table <- data.frame(PathwayID = PathwayID,
      PathwayName = PathwayName, fry)
    }
    
    else if(database == 'REACTOME') 
      fry.table <- data.frame(PathwayID = PathwayID, fry)
    
    else fry.table <- data.frame(PathwayID = PathwayID, fry)
  })
  
  output$fryTable <- DT::renderDataTable({
    format(databaseInput(), scientific = TRUE, digits = 3)
  }, options = list(orderClasses = TRUE), filter = 'top'
  )
  
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste0(Sys.Date(), "-", input$database, "-", input$saving_type, input$filetype)
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, ".csv" = ",", ".txt" = "\t")
     
      if (input$saving_type == "Filtered")
        s = input$fryTable_rows_all
      else if (input$saving_type == "Selected") 
        s = input$fryTable_rows_selected
      
      # Write to a file specified by the 'file' argument
      if (input$saving_type == "All") 
      write.table(format(databaseInput(), scientific = TRUE, digits = 3),
        file, sep = sep, row.names = FALSE)
      else  write.table(format(databaseInput()[s, , drop = FALSE], scientific = TRUE, digits = 3),
        file, sep = sep, row.names = FALSE)
    }
  )
})
