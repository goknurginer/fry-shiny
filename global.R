library(limma)
library(org.Hs.eg.db)
library(GO.db)
# library(DT)
.matvec <- limma:::.matvec
x <- Term(GOTERM)
goTerms <- c(names(x))
names(goTerms) <- x
goNames <- as.vector(goTerms)
GO <- org.Hs.egGO2EG
