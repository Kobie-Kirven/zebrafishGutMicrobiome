setwd("/Volumes/UUI/zebrafishGutMicrobiome/taxonomicAnalysis/metacodr/")

library(readr)
library(dplyr)
library(metacoder)
library(vegan)
library(ggplot2)
library(agricolae)
library(phyloseq)
library(plotly)

otu_data <- read_tsv("zebrafish_otu.tsv")

tax_data <- read_tsv("taxAssignments.tsv")

zeb_samples <- read_tsv("sample_data.tsv", col_types = "cc")


tax_data$`OTUs` <- as.character(tax_data$`OTUs`) # Must be same type for join to work

otu_data$OTUs <- as.character(otu_data$OTUs) # Must be same type for join to work

otu_data <- left_join(otu_data, tax_data,
                      by = c("OTUs" = "OTUs")) # identifies cols with shared IDs

obj <- parse_tax_data(otu_data,
                      class_cols = "Lineage", # the column that contains taxonomic information
                      class_sep = ";", # The character used to separate taxa in the classification
                      class_regex = "^(.+)_(.+)$", # Regex identifying where the data for each taxon is
                      class_key = c(tax_rank = "info", # A key describing each regex capture group
                                    tax_name = "taxon_name"))

ps_obj <- as_phyloseq(obj,
                      otu_table = "tax_data",
                      otu_id_col = "OTUs",
                      sample_data = zeb_samples,
                      sample_id_col = "Sample_Id")


sample_variables(ps_obj)

#Filter Out Low Abundances
obj$data$tax_data <- zero_low_counts(obj, "tax_data", min_count = 2,
                                       other_cols = TRUE)


no_reads <- rowSums(obj$data$tax_data[, zeb_samples$Sample_Id]) == 0
sum(no_reads)

obj <- filter_obs(obj, "tax_data", ! no_reads, drop_taxa = TRUE)

obj$data$tax_data <- calc_obs_props(obj, "tax_data")
print(obj)

obj$data$tax_abund <- calc_taxon_abund(obj, "tax_data",
                                       cols = zeb_samples$Sample_Id)


obj$data$tax_occ <- calc_n_samples(obj, "tax_abund", groups = zeb_samples$Group,
                                   cols = zeb_samples$Sample_Id)

obj$data$tax_occ
###### Alpha Diversity #######

#Compute the shannon diversity index
zeb_samples$alpha <- diversity(obj$data$tax_data[, zeb_samples$Sample_Id],
                               MARGIN = 2,
                               index = "invsimpson")

wilcox.test(alpha ~ Group, zeb_samples, alternative = "two.sided")

zeb_samples
ggplot(zeb_samples, aes(x = Group, y = alpha)) + theme_classic()+ 
  geom_boxplot(width=0.5, fill="lightgrey", outlier.shape = 1) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab("Dietary Iron Level") +
  ylab("Inverse Simpson Index")

ggsave("invsimpson.png",dpi=400)
####################################
# Beta Diversity

# Define new object with relative abundance
mpra = transform_sample_counts(ps_obj, function(x) x / sum(x))


DistBC = distance(mpra, method = "bray")

ordBC = ordinate(mpra, method = "PCoA", distance = DistBC)

plot_ordination(mpra, ordBC) + 
  geom_point(aes(shape=factor(sample_data(mpra)$Group), 
                 color=factor(sample_data(mpra)$Group)),
             size=4) + theme_classic() + theme(legend.title = element_blank())

ggsave("bray_curtis_pcoa.png", dpi=400)
##############

