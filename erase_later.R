# number of pathways related to Hs within KEGG
length(unique(genes2pathways[,2]))
# number of genes that were included in a kegg pathway
length(unique(genes2pathways[,1]))

m <- match(g, genes2pathways[,1])

keggTerms <- names(keggList("pathway"))
length(unique(keggTerms))
g <- keggLink("genes", c("hsa04151","hsa04150"))
names(g) <- NULL
g <- sub("hsa:", "", g)
m <- match(g,rownames(d$counts))
sum(!is.na(m))
m <- m[!is.na(m)]
dd <- d[m, ]
sum(idx <- dd$genes$Symbol %in% toptable$Symbol[toptable$adj.P.Val <= 0.1])


## Retrieves the image file of a pathway map
# png <- keggGet("hsa05130", "image")
# t <- tempfile()
# library(png)
# writePNG(png, t)
# keggGet("hsa05130", "kgml")









cnt <- read.table("expression_20.txt")
des <- read.table("design_expression_20.txt")

# KEGG DB
definitions2pathways <- getKEGGPathwayNames(species.KEGG = "hsa", remove=TRUE)
genes2pathways <- getGeneKEGGLinks(species.KEGG = "hsa", convert = FALSE)

ll <- split(genes2pathways, genes2pathways$PathwayID)
ll <- lapply(ll, function(x) x[names(x) == "GeneID"])
keggGeneSets <- lapply(ll, function(x) as.character(unlist(x)))


gene.sets <- keggGeneSets
gene.sets <- gene.sets[! sapply(gene.sets, is.null)]
idx <- ids2indices(gene.sets, rownames(cnt))
fry <- fry(cnt, design =des, index = idx, sort="directional")
format(fry, scientific = TRUE, digits = 3)

#### .matvec <- limma:::.matvec
library(limma)


# GO DB
library(org.Hs.eg.db)
library(GO.db)
x <- Term(GOTERM)
go.pathway <- data.frame(PathwayID = names(x), PathwayName = as.vector(x))
goID <- as.character(go.pathway$PathwayID)
goName <- as.character(go.pathway$PathwayName)
GO <- org.Hs.egGO2EG
gosets <- as.list(GO)[goID]


# as.vector(go.pathway$PathwayID[as.vector(go.pathway$PathwayName) %in% input$goSets])

# MsigDB
load("human_H_v5.rdata")
#load("human_c1_v5.rdata")
#load("human_c2_v5.rdata")
#load("human_c3_v5.rdata")
#load("human_c4_v5.rdata")
#load("human_c6_v5.rdata")
#load("human_c7_v5.rdata")
msigsets <- names(Hs.H)

# KEGG DB
definitions2pathways <- getKEGGPathwayNames(species.KEGG = "hsa", remove=TRUE)


genes2pathways <- getGeneKEGGLinks(species.KEGG = "hsa", convert = FALSE)
ll <- split(genes2pathways, genes2pathways$PathwayID)
ll <- lapply(ll, function(x) x[names(x) == "GeneID"])
KEGG <- lapply(ll, function(x) as.character(unlist(x)))
keggsets <- names(KEGG)




















