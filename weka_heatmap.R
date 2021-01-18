
setwd("~/Documents/Github/zebrafishGutMicrobiome/")

#Input the data from the EC's identified by weka
inputData <- read.csv("mifaser_heatmap_data.csv")

#Turn the data table into a matrix
m <- as.matrix(inputData[, -1])

#Add in the EC's as rownames
rownames(m) <- inputData$X

#Import RColorBrewer so that we can change the heatmap colors
library("RColorBrewer")

#Create the heatmap
heatmap(m, Colv = NA, Rowv = NA, col=brewer.pal(9,"Blues"))

