.matvec <- limma:::.matvec
library(limma)

# GO DB
library(org.Hs.eg.db)
library(GO.db)
x <- Term(GOTERM)
goTerms <- c(names(x))
names(goTerms) <- x
goNames <- as.vector(goTerms)
GO <- org.Hs.egGO2EG

# MsigDB
load("human_H_v5.rdata")
load("human_c1_v5.rdata")
load("human_c2_v5.rdata")
load("human_c3_v5.rdata")
load("human_c4_v5.rdata")
load("human_c6_v5.rdata")
load("human_c7_v5.rdata")

# KEGG DB
definitions2pathways <- getKEGGPathwayNames(species.KEGG = "hsa", remove=TRUE)
genes2pathways <- getGeneKEGGLinks(species.KEGG = "hsa", convert = FALSE)
ll <- split(genes2pathways, genes2pathways$PathwayID)
ll <- lapply(ll, function(x) x[names(x) == "GeneID"])
KEGG <- lapply(ll, function(x) as.character(unlist(x)))


