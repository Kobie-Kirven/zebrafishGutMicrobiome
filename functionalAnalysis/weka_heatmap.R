
setwd("~/Documents/Github/zebrafishGutMicrobiome/functionalAnalysis/")

#Import RColorBrewer so that we can change the heatmap colors
library("RColorBrewer")
library(ComplexHeatmap)
library(grid)
library(circlize)

#Input the data from the EC's identified by weka
inputData <- read.csv("mifaser_output.csv")

#Turn the data table into a matrix
m <- as.matrix(inputData[, -1])

#Add in the EC's as rownames
rownames(m) <- inputData$X


#Create the heatmap
#heatmap(m, Colv = NA, Rowv = NA, col=brewer.pal(9,"Blues"))

col_fun = colorRamp2(c(0, 500, 2000), c("#FFFFFF","#A1DDFF", "#60C6FF"))
col_fun(seq(-50, 10))

ha = HeatmapAnnotation(df = data.frame(Group = c(rep("Normal Iron", 3), rep("High Iron", 4))),
                       col = list(type = c("Normal Iron" =  "Gray", "High Iron" = "#D8D8D8")) )

hmp = Heatmap(m, name = "Counts", col = col_fun, cluster_rows = FALSE,show_column_dend = FALSE, cluster_columns = FALSE, 
        row_names_side = "left", top_annotation = ha)

hmp 
decorate_heatmap_body("Counts", {
  i = which(colnames(m) == "N4")
  x = i/ncol(m)
  grid.lines(c(x, x), c(0, 1), gp = gpar(lwd = 2, lty = 2))
})
