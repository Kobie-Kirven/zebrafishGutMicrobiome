setwd("/Volumes/UUI/zebrafishGutMicrobiome/taxonomicAnalysis/")

library(readr)
library(dplyr)
library(metacoder)

otu_data <- read_tsv("zebrafish_otu.tsv")
print(otu_data)

tax_data <- read_tsv("taxAssignments.tsv")
print(tax_data)

zeb_samples <- read_tsv("samples.tsv")
zeb_samples

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

obj$data$tax_data <- zero_low_counts(obj, dataset = "tax_data", min_count = 5)
no_reads <- rowSums(obj$data$tax_data[, zeb_samples$`Sample Id`]) == 0
sum(no_reads)
obj <- filter_obs(obj, target = "tax_data", ! no_reads, drop_taxa = TRUE)
obj
obj$data$tax_data <- calc_obs_props(obj, "tax_data")

obj$data$tax_abund <- calc_taxon_abund(obj, "tax_data",
                                       cols = zeb_samples$`Sample Id`)

print(obj)

obj$data$tax_occ <- calc_n_samples(obj, "tax_abund", groups = zeb_samples$Group, cols = zeb_samples$`Sample Id`)

set.seed(1) # This makes the plot appear the same each time it is run 
heat_tree(obj, 
          node_label = taxon_names,
          node_size = n_obs, 
          node_color = n_obs,
          node_size_axis_label = "OTU count",
          node_color_axis_label = "Samples with reads",
          layout = "davidson-harel", # The primary layout algorithm
          initial_layout = "reingold-tilford") # The layout algorithm that initializes node locations

obj %>% 
  filter_taxa(taxon_ranks == "o", supertaxa = TRUE) %>% # subset to the order rank
  heat_tree(node_label = gsub(pattern = "\\[|\\]", replacement = "", taxon_names),
            node_size = n_obs,
            node_color = n_obs,
            node_color_axis_label = "OTU count",
            layout = "davidson-harel", initial_layout = "reingold-tilford")
