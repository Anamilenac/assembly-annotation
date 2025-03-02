# This script was provided in the course

# Purpose: Visualizes overlaps in orthogroups using upset plots 

# Inputs:
# - Statistics_PerSpecies.tsv: Comparative genomic statistics for different species
# - Orthogroups.GeneCount.tsv: Gene counts per orthogroup across species
# 
# Outputs:
# - orthogroup_plot.pdf: Bar plot visualizing the count of genes in orthogroups
# - orthogroup_percent_plot.pdf: Bar plot showing the percentage of genes in orthogroups
# - one-to-one_orthogroups_plot.complexupset.pdf: UpSet plot displaying the presence/absence of orthogroups across species

###############################################################################

library(tidyverse)
library(data.table)

dat <- fread("/data/users/acastro/genome_assembly_annotation/analysis/final_maker/genespace/orthofinder/Results_Nov15/Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv", header = T, fill = TRUE)
genomes <- names(dat)[names(dat) != "V1"]

dat <- dat %>% pivot_longer(cols = -V1, names_to = "species", values_to = "perc")
ortho_ratio <- dat %>%
  filter(V1 %in% c(
    "Number of genes", "Number of genes in orthogroups", "Number of unassigned genes",
    "Number of orthogroups containing species", "Number of species-specific orthogroups", "Number of genes in species-specific orthogroups"
  ))

ortho_percent <- dat %>%
  filter(V1 %in% c(
    "Percentage of genes in orthogroups", "Percentage of unassigned genes", "Percentage of orthogroups containing species",
    "Percentage of genes in species-specific orthogroups"
  ))

p <- ggplot(ortho_ratio, aes(x = V1, y = perc, fill = species)) +
  geom_col(position = "dodge") +
  cowplot::theme_cowplot() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), 
    plot.margin = margin(t = 5, r = 5, b = 20, l = 5, unit = "pt") 
    ) +
  labs(y = "Count")
ggsave("Plots/orthogroup_plot.pdf")

p <- ggplot(ortho_percent, aes(x = V1, y = as.numeric(perc), fill = species)) +
  geom_col(position = "dodge") +
  ylim(c(0, 100)) +
  cowplot::theme_cowplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
    plot.margin = margin(t = 5, r = 5, b = 20, l = 5, unit = "pt") 
  ) +
  labs(y = "Count")

ggsave("Plots/orthogroup_percent_plot.pdf", plot = p, width = 12, height = 6)


library(UpSetR)


orthogroups <- fread("/data/users/acastro/genome_assembly_annotation/analysis/final_maker/genespace/orthofinder/Results_Nov15/Orthogroups/Orthogroups.GeneCount.tsv")
orthogroups <- orthogroups %>%
  select(-Total)
ogroups_presence_absence <- orthogroups
rownames(ogroups_presence_absence) <- ogroups_presence_absence$Orthogroup

# convert the gene counts to presence/absence
ogroups_presence_absence[ogroups_presence_absence > 0] <- 1
ogroups_presence_absence$Orthogroup <- rownames(ogroups_presence_absence)

str(ogroups_presence_absence)

ogroups_presence_absence <- ogroups_presence_absence %>%
  rowwise() %>%
  mutate(SUM = sum(c_across(!ends_with("Orthogroup"))))



ogroups_presence_absence <- data.frame(ogroups_presence_absence)
ogroups_presence_absence[genomes] <- ogroups_presence_absence[genomes] == 1


# use ComplexUpset package to make an upset plot with a subset of the data
library(ComplexUpset)

pdf("Plots/one-to-one_orthogroups_plot.complexupset.pdf", height = 5, width = 10, useDingbats = FALSE)

upset(ogroups_presence_absence, genomes, name = "genre", width_ratio = 0.1, wrap = TRUE, set_sizes = FALSE)
dev.off()