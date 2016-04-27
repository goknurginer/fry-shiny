# ui
# gosets <- as.vector(Term(GOTERM))
keggsets <- paste("s", 1:100)
shinyUI(fluidPage(
  
  titlePanel(h1("Fry: Fast Interactive Biological Pathway Miner")),
  
  sidebarLayout(position = "left",
    sidebarPanel(h3("Please set up your test"),
      fileInput("counts", label = "1. Upload the expression data matrix"),
      fileInput("design", label = "2. Upload the design matrix"),
      radioButtons("database", label = "3. Select a database",
        choices = list("GO", "KEGG")),
      p(strong("4. Input one or more gene sets")),
      conditionalPanel(condition = "input.database == 'GO'", selectizeInput("foo", label = "Search for gene sets within GO", choices = NULL, multiple = TRUE)),
      conditionalPanel(condition = "input.database == 'KEGG'",selectizeInput("keggSets", label = "Search for gene sets within KEGG", choices = keggsets, multiple = TRUE)),
      p("or"),
      fileInput("geneList", label = "Upload the gene list of interest"),
      p(strong("5. Decide default thresholds")),
      selectInput("fdr", label = h5("FDR threshold"),
        choices = list("0.01", "0.05", "0.1")),
      selectInput("pvalue", label = h5("P-value threshold"),
        choices = list("0.01", "0.05", "0.1")),
      actionButton("run", label = strong("Apply gene set test"))
    ),
    mainPanel(
      #tableOutput('countMatrix'),
      #tableOutput('designMatrix'),
      #tableOutput('fry'),
      tableOutput("fryTable"),
      tableOutput("nameOfChoice")
    )
  )
))
