# server
options(shiny.maxRequestSize=100*1024^2) 
shinyServer(function(input,output,session) {
  
  updateSelectizeInput(session, "goSets", choices = goTerms, server = TRUE)
  
  applyGS <- eventReactive(input$run, {
    input$goSets
  })
  
  output$fryTable <- renderTable({
    gene.sets <- as.list(GO)[applyGS()]
    gene.sets <- gene.sets[! sapply(gene.sets, is.null)]
    cnt <- read.table(input$counts$name)
    des <- read.table(input$design$name)
    idx <- ids2indices(gene.sets, rownames(cnt))
    format(fry( cnt, design =des, index = idx, sort="directional"), scientific = TRUE, digits = 3)
  })
  
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
