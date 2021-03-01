
setwd("/Volumes/UUI/zebrafishGutMicrobiome/functionalAnalysis/")

#Import RColorBrewer so that we can change the heatmap colors
library(reshape2)
library(ggplot2)

#Input the data from the EC's identified by weka
inputData <- read.csv("mifaser_heatmap_data.csv")
inputData <- inputData[1:15,]

test <- melt(inputData, id = c("X"), measure.vars = c("N2", "N3", "N4", "E1", "E3", "E4","E5"))

head(test)

p <- ggplot(test, aes(x=variable, y=X, fill=value))
p + geom_tile() +  
  scale_fill_gradient(low="white", high="blue") + 
  theme_classic() + geom_vline(xintercept=c(3.5), 
                               linetype="dashed", color = "grey") +
  theme(axis.ticks = element_blank()) + xlab("Sample") + 
  ylab("Most Informative E.C.s")

ggsave("weka_heatmap.png", width = 10, height = 8, unit = "cm", dpi=300)
