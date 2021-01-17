
setwd("~/Documents/Github/zebrafishGutMicrobiome/mifaser")


sample1 <- read.csv("N2_mifaser.tsv", sep='t')
total = rbind(sample1, "N3_mifaser.tsv",sep='t')
total = rbind(total, "N4_mifaser.tsv",sep='t')
total = rbind(total, "E1_mifaser.tsv",sep='t')
total = rbind(total, "E3_mifaser.tsv",sep='t')
total = rbind(total, "E4_mifaser.tsv",sep='t')
total = rbind(total, "E5_mifaser.tsv",sep='t')

total
