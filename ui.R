# ui
# runApp("../GST_Tool/", display.mode = "showcase")
keggsets <- paste("s", 1:100)
msigsets <- names(Hs.H)
shinyUI(fluidPage(
  
  titlePanel(h1("Fry: Fast Interactive Biological Pathway Miner")),
  
  sidebarLayout(position = "left",
    sidebarPanel(h3("Please set up your test"),
      
      fileInput("counts", label = "1. Upload the expression data matrix"),
      
      fileInput("design", label = "2. Upload the design matrix"),
      
      radioButtons("database", label = "3. Select a database",
        choices = list("GO", "KEGG", "MsigDB")),
      
      p(strong("4. Input one or more gene sets")),
      
      conditionalPanel(condition = "input.database == 'GO' || input.sets.length >1", 
        selectizeInput("goSets", label = "Search for gene sets within GO", 
          choices = NULL, multiple = TRUE)),
      
      conditionalPanel(condition = "input.database == 'KEGG'",
        selectizeInput("keggSets", label = "Search for gene sets within KEGG",
          choices = keggsets, multiple = TRUE)),
      
      conditionalPanel(condition = "input.database == 'MsigDB'",
        selectizeInput("MsigSets", label = "Search for gene sets within MsigDB",
          choices = msigsets, multiple = TRUE)),

      checkboxInput("allGeneSets", label = "Select all gene sets"),
      checkboxInput("allGeneSets1", label = "Select all gene sets1"),
      p("or"),
      
      fileInput("geneList", label = "Upload the gene list of interest"),
      
      actionButton("run", label = strong("Apply gene set test")),
    
      p(strong("5. Decide default cutoffs")),
      
      sliderInput("pvalue", label = h5("P-value cutoff"),
        min = 0, max = 0.1, value = "0.", step = 0.01),
      
      conditionalPanel(
        condition = "input.allGeneSets",
        sliderInput("fdr", label = h5("FDR cutoff"),
          min = 0, max = 0.1, value = "0.", step = 0.01))
      # selectInput("fdr", label = h5("FDR cutoff"), choices = list("0.01", "0.05", "0.1"), selected = "0.1")
    ),
    
    mainPanel(
      #tableOutput('countMatrix'),
      #tableOutput('designMatrix'),
      #tableOutput('fry'),
      verbatimTextOutput("geneSetInput"),
      dataTableOutput('fryTable')
    )
  )
))
