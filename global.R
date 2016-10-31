library(limma)
library(DT)
#library(xlsx)

# GO DB
library(org.Hs.eg.db)
library(GO.db)
x <- Term(GOTERM)
# Swap names and values of x
gosets <- c(names(x))
names(gosets) <- x
GO <- org.Hs.egGO2EG

# MsigDB - Hs.H object
load("human_H_v5p2.rdata")
#load("human_c1_v5.rdata")
#load("human_c2_v5.rdata")
#load("human_c3_v5.rdata")
#load("human_c4_v5.rdata")
#load("human_c6_v5.rdata")
#load("human_c7_v5.rdata")
msigsets <- names(Hs.H)

# KEGG DB
definitions2pathways <- getKEGGPathwayNames(species.KEGG = "hsa", remove=TRUE)
keggsets <- definitions2pathways$PathwayID
names(keggsets) <- c(definitions2pathways$Description)
genes2pathways <- getGeneKEGGLinks(species.KEGG = "hsa", convert = FALSE)
ll <- split(genes2pathways, genes2pathways$PathwayID)
ll <- lapply(ll, function(x) x[names(x) == "GeneID"])
KEGG <- lapply(ll, function(x) as.character(unlist(x)))

# REACTOME DB
library("reactome.db")
file <- "ReactomePathways.gmt"
REACTOME <- readLines(file)
REACTOME <- strsplit(REACTOME, split = "\t")
pathways <- lapply(REACTOME, function(x) x[1])
REACTOME <- lapply(REACTOME, function(x) x[-c(1, 2)])
names(REACTOME) <- pathways
reactomesets <- unlist(pathways)
