# ui
# runApp("../GST_Tool/", display.mode = "showcase")
# setwd("C:/Users/giner.g.WEHI/Dropbox/Rshiny/GST_Tool")
msigAll_hall <- names(Hs.H)
shinyUI(fluidPage(
  
  titlePanel(h1("Fry: Fast Interactive Biological Pathway Miner")),
  
  sidebarLayout(position = "left",
    sidebarPanel(h3("Please set up your test"),
      
      checkboxInput("example", label = "Use example dataset and continue on step 3"),
      fileInput("counts", label = "1. Upload the expression data matrix"),
      
      fileInput("design", label = "2. Upload the design matrix"),
      
      selectInput("database", label = "3. Select a database",
        choices = list("GO", "KEGG", "MSig_HALLMARK", "REACTOME")),
      
      p(strong("4. Input one or more gene sets")),
      
      conditionalPanel(condition = "input.database == 'GO'",
        selectizeInput("goSelected", label = h5("Search for gene sets within GO"),
          choices = NULL, multiple = TRUE)),
      
      conditionalPanel(condition = "input.database == 'KEGG'",
        selectizeInput("keggSelected", label = h5("Search for gene sets within KEGG"),
          choices = keggAll, multiple = TRUE)),
      
      conditionalPanel(condition = "input.database == 'MSig_HALLMARK'",
        selectizeInput("MsigSets", label = h5("Search for gene sets within MSig_HALLMARK"),
          choices = msigAll_hall, multiple = TRUE)),
      
      conditionalPanel(condition = "input.database == 'REACTOME'",
        selectizeInput("reactomeSelected", label = h5("Search for gene sets within REACTOME"),
          choices = reactomeAll, multiple = TRUE)),
      
      checkboxInput("allGeneSets", label = "Select all gene sets"),
<<<<<<< HEAD

      # p("or"),
      # 
      # fileInput("geneList", label = h5("Upload the gene list of interest")),

=======
      
      # p("or"),
      
      # fileInput("geneList", label = h5("Upload the gene list of interest")),
      
>>>>>>> 2752a52ff3ec6909bb6005d7e96ec0ea08aff1b3
      actionButton("run", label = h4(strong("Apply gene set test"))),
      
      br(),
      br(),
      
      conditionalPanel(condition = "input.run",
        p(strong("5. Save the results")),
        fluidRow(
          column(5, wellPanel(
            radioButtons('saving_type', h5("Save pathways"), 
              choices = c("All", "Selected", "Filtered")),
            textInput('filename', label = h5("Name the file"))
            # p(downloadButton('pval_dl', 'Download'))
          )
          ),
          column(5, wellPanel(
            radioButtons("filetype", h5("Choose file type"),
              choices = c(".csv", ".txt", ".xlsx")),
            downloadButton('downloadData', 'Download table')
          )
            
          )) 
      )
      
    ),
    
    mainPanel(
      dataTableOutput('fryTable')
    )
  )
))
