setwd("C:/Users/giner.g.WEHI/Dropbox/Rshiny/GST_Tool")
cnt <- read.table("expression_20.txt")
des <- read.table("design_expression_20.txt")
library("limma")
source("160414lmEffects.R")
source("160418-geneset-fry.R")
library(org.Hs.eg.db)
library(GO.db)
.matvec <- limma:::.matvec

# GO database (41790 gene sets)
x <- Term(GOTERM)
length(x)
goTerms <- c(names(x))
names(goTerms) <- x
goNames <- as.vector(goTerms)
length(goNames)
GO <- org.Hs.egGO2EG
gene.sets <- as.list(GO)[goTerms]
gene.sets <- gene.sets[! sapply(gene.sets, is.null)]
idx <- ids2indices(gene.sets, rownames(cnt))
length(idx)
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional"))
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional", standardize = "none"))
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional", standardize = "residual.sd"))
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional", standardize = "p2"))

# MsigDB ()
# download.file("http://bioinf.wehi.edu.au/software/MSigDB/human_c2_v5.rdata", 
#  "human_c1_v5.rdata", mode = "wb")

load("human_c2_v5.rdata")
idx <- ids2indices(Hs.c2, rownames(cnt))
length(idx)
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional"))
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional", standardize = "none"))
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional", standardize = "residual.sd"))
system.time(fry <- fry(cnt, design =des, index = idx, sort="directional", standardize = "p2"))

