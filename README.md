This repository consists of the source codes for FRY gene set test RShiny application which can be found on http://shiny.bioinf.wehi.edu.au/giner.g/FRY_GeneSetExplorerApp/

>>>>>>>>>>>>>>>>>>>>>>
Gene set test FRY
>>>>>>>>>>>>>>>>>>>>>>

Gene set tests are often used in differential expression analyses to explore the behaviour of a group of related genes. This is useful for identifying large-scale co-regulation of genes belonging to the same biological process or molecular pathway. 

One of the most flexible and powerful gene set tests is the ROAST method in the limma R package. ROAST uses residual space rotation as a sort of continuous version of sample permutation. Like permutation tests, it protects against false positives caused by correlations between genes in the set. Unlike permutation tests, it can be used with complex experimental design and with small numbers of replicates. It is the only gene set test method that is able to analyse complex "gene expression signatures" that incorporate information about both up and down regulated genes simultaneously.

ROAST works well for individual expression signatures, but has limitations when applied to large collections of gene sets, such as the Broad Institute's Molecular Signature Database with over 8000 gene sets. In particular, the p-value resolution is limited by the number of rotations that are done for each set. This makes it impossible to obtain very small p-values and hence to distinguish the top ranking pathways from a large collection. As with permutation tests, the p-values for each set may vary from run to run.

Fry is a very fast approximation to the complete ROAST method. Fry approximates the limiting p-value that would be obtained from performing a very large number of rotations with ROAST. Fry preserves most of the advantages of ROAST, but also provides high resolution exact p-values very quickly. In particular, it is able to distinguish the most significant sets in large collections and to yield statistically significant results after adjustment for multiple testing. This makes it an ideal tool for large-scale pathway analysis.

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Instructions for using the Fry app:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Step 1. To set up your test, you can either upload the count matrix (samples in the column and features in the rows) and the matrix of design of the experiment(which can be constructed using model.matrix() function from stats R package), or you can upload the sample dataset by clicking "Use example dataset and continue on step 3" at the top left corner. 

Step 2. Select the annotation databases in which you are interested in searching for gene sets (pathways).

Step 3. Select the gene sets within the annotation database. At this step, you might either make partial selections or select all of the gene sets in this annotation database by clicking "Select all gene sets."

Step 4. You can now sort the produced table by clicking on up and down arrows next to the column names or you can filter the table by using the search box at the top right and save only the filtered table. Another saving option is "Selected" saves the rows you selected by clicking on the rows you are interested in. Tables can be saved as comma-delimited(csv), tab-delimited(txt) and excel sheet(xlsx).

>>>>>>>>>>>>>>>>>>>>>>
Annotation update info
>>>>>>>>>>>>>>>>>>>>>>
Keeping annotation databases up-to-date for a gene set testing tool is very crucial for the quality of research. Check the paper "Impact of outdated gene annotations on pathway enrichment analysis" (Aug 2016, Nature Methods) on http://www.nature.com/nmeth/journal/v13/n9/full/nmeth.3963.html to see the impact of outdated annotations used in these tools.

Therefore, Fry updates the databases provided in the application regularly!

MsigDB 
human_c5_v5p2.rdata and human_H_v5p2.rdata are downloaded from http://bioinf.wehi.edu.au/software/MSigDB/ which was last modified on 11 October 2016

KEGG is obtained useing library(limma) functions. limma is regulary updated. 

Reactome is last modified on 31 October 2016. ReactomePathways.gmt file was downloaded from http://software.broadinstitute.org/gsea/msigdb/collections.jsp CP:REACTOME: Reactome gene sets entrez gene ids

org.Hs.eg.db and GO.db are last updated on 27 October 2016. Current version is 3.4.0
