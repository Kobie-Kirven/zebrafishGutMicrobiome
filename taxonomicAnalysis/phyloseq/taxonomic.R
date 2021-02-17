setwd("/Volumes/UUI/zebrafishGutMicrobiome/taxonomicAnalysis/")

library(phyloseq)
library(ape)

#Read in the combined brac
#otumat <- read.csv("bracken_combined.tsv", sep='\t', header=TRUE)

#lineages <- matrix(read.csv("lineages.tsv", sep='\t', header=FALSE), ncol=2)

otumat <- read.csv("bracken_with_lineage.tsv", sep='\t', header=TRUE)

#lineages
otu <- c(otumat$N2_frac, otumat$N3_frac, otumat$N4_frac, 
                   otumat$E1_frac, otumat$E3_frac, otumat$E4_frac, 
                   otumat$E5_frac)

otu <- c(otumat$N2_num, otumat$N3_num, otumat$N4_num, 
         otumat$E1_num, otumat$E3_num, otumat$E4_num, 
         otumat$E5_num)

otu <- matrix(otu, ncol=7)
otu

rownames(otu) <- paste0("OTU", 1:nrow(otu))
colnames(otu) <- paste0("Sample", 1:ncol(otu))

taxmat <- matrix(c(otumat$Pyhlum, otumat$Class, otumat$Order,otumat$Family, otumat$Genus,otumat$Species), ncol=6)
rownames(taxmat) <- rownames(otu)
colnames(taxmat) <- c("Phylum", "Class", "Order","Family","Genus","Species")

samNames <- matrix(c("N2", "N3", 
                     "N4","E1","E3","E4","E5"), nrow = 7, ncol = 1)

samNames

colnames(samNames) <- c("SampleClass")
rownames(samNames) <- c("Sample1" ,"Sample2" ,"Sample3" ,"Sample4" ,
                        "Sample5" ,"Sample6","Sample7")
samNames <- as.data.frame(samNames)
samNames

taxmat

OTU = otu_table(otu, taxa_are_rows = TRUE)
TAX = tax_table(taxmat)
SAM <- sample_data(samNames, errorIfNULL = TRUE)
SAM
OTU

physeq = phyloseq(OTU, TAX, SAM)
physeq

zf <-  filter_taxa(physeq, function(x) sum(x > 3) > (0.2*length(x)), TRUE)
zf <- transform_sample_counts(zf, function(x) x+1)

plot_bar(GP, fill = "Phylum")

otumat <- read.csv("bracken_with_line_lineage.tsv", sep='\t', header=TRUE)

otumat

names <- matrix(1:length(otumat$N2_num), ncol=1)
names
colnames(names) <- c("OTUs")

new <- cbind(names, otumat$N2_num, otumat$N3_num, otumat$N4_num,
         otumat$E1_num, otumat$E3_num, otumat$E4_num, otumat$E5_num)

colnames(new) <- c("OTUs", "N2","N3","N4","E1","E3","E4","E5")
new

write.table(new, file = "zebrafish_otu.tsv", row.names = FALSE, col.names = TRUE, sep = "\t")

taxAssignments <- cbind(names, otumat$lineage)
colnames(taxAssignments) <- c("OTUs", "Lineage")
write.table(taxAssignments, file = "taxAssignments.tsv", row.names = FALSE, col.names = TRUE, sep = "\t")


