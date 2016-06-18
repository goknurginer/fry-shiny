# ui
# runApp("../GST_Tool/", display.mode = "showcase")
# setwd("C:/Users/giner.g.WEHI/Dropbox/Rshiny/GST_Tool")
msigsets <- names(Hs.H)
shinyUI(fluidPage(

  titlePanel(h1("Fry: Fast Interactive Biological Pathway Miner")),

  sidebarLayout(position = "left",
    sidebarPanel(h3("Please set up your test"),

      fileInput("counts", label = "1. Upload the expression data matrix"),

      fileInput("design", label = "2. Upload the design matrix"),

      selectInput("database", label = "3. Select a database",
        choices = list("GO", "KEGG", "MsigDB")),

      p(strong("4. Input one or more gene sets")),

      conditionalPanel(condition = "input.database == 'GO'",
        selectizeInput("goSets", label = h5("Search for gene sets within GO"),
          choices = NULL, multiple = TRUE)),

      conditionalPanel(condition = "input.database == 'KEGG'",
        selectizeInput("keggSets", label = h5("Search for gene sets within KEGG"),
          choices = keggsets, multiple = TRUE)),

      conditionalPanel(condition = "input.database == 'MsigDB'",
        selectizeInput("MsigSets", label = h5("Search for gene sets within MsigDB"),
          choices = msigsets, multiple = TRUE)),

      checkboxInput("allGeneSets", label = "Select all gene sets"),

      p("or"),

      fileInput("geneList", label = h5("Upload the gene list of interest")),

      actionButton("run", label = h4(strong("Apply gene set test"))),

      br(),
      br(),

      conditionalPanel(condition = "input.run",
        p(strong("5. Save the results")),
        fluidRow(
          column(6, wellPanel(
            radioButtons('saving_type', h5("Select"), 
              choices = c("All", "Filtered", "Selected")),
            textInput('filename', label = h5("Name the file"))
            # p(downloadButton('pval_dl', 'Download'))
          )
          ),
          column(6, wellPanel(
            radioButtons("filetype", h5("Choose file type"),
              choices = c("csv", "txt", "xlsx")),
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
