setwd("~/Documents/Github/zebrafishGutMicrobiome/functionalAnalysis/mifaser/")

N2 <- read.csv("N2_mifaser.tsv", sep="\t")
N3 <- read.csv("N3_mifaser.tsv", sep="\t")
N4 <- read.csv("N3_mifaser.tsv", sep="\t")
E1 <- read.csv("E1_mifaser.tsv", sep="\t")
E3 <- read.csv("E3_mifaser.tsv", sep="\t")
E4 <- read.csv("E4_mifaser.tsv", sep="\t")
E5 <- read.csv("E5_mifaser.tsv", sep="\t")

normal <- c(length(N2[,1]), length(N3[,1]), length(N4[,1]))
experimental <- c(length(E1[,1]), length(E3[,1]), length(E4[,1]), 
                  length(E5[,1]))

shapiro.test(normal)  #normal
median(normal)
IQR(normal)

shapiro.test(experimental)  #normal
median(experimental)
IQR(experimental)

wtest <- wilcox.test(normal, experimental, exact=FALSE)
wtest$p.value
