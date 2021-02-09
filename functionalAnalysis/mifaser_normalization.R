library(edgeR)
library(gplots)
library(ComplexHeatmap)
library("RColorBrewer")

setwd("~/Documents/Github/zebrafishGutMicrobiome/functionalAnalysis/")

#Open the file and read as table
raw_counts <- read.csv("mifaser_heatmap_data.csv", header=TRUE)

ECs <- raw_counts[,c(1)]

#Convert table to matrix
raw_counts <- as.matrix(raw_counts[,c(2,3,4,5,6,7,8)])

#Create group vector
group <- c('Normal','Normal','Normal','Experimental','Experimental','Experimental','Experimental')

#Create a DGElist object for edgeR
dge_list <- DGEList(counts = raw_counts, group = group, genes=ECs)

#Calculate the normalization factors using TMM
TMM <- calcNormFactors(dge_list, method = "TMM")

#Estimate the common dispersion for calculation of pesudo counts
TMM <- estimateCommonDisp(TMM)

#Preform an exact test on the gene counts
et <- exactTest(TMM)

#Get the most significantly different genes
tTags <- topTags(et)

tTags
diffGenes <- match(tTags$table$genes,ECs)

geneTable <- TMM$pseudo.counts[diffGenes,c(1,2,3,4,5,6,7)]

#Plot a multidimensional scaling plot
plotMDS(TMM, labels=c('N1','N2','N3','E1','E3','E4','E5'))

