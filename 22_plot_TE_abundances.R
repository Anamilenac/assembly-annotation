# Purpose: Visualizes the abundance of Transposable Element (TE) clades 

# Inputs:
# - Gypsy_sequences.fa.rexdb-plant.cls.tsv:Gypsy TE 
# - Copia_sequences.fa.rexdb-plant.cls.tsv: Copia TE 
# - assembly.fasta.mod.EDTA.TEanno.sum: Clade abundance

# Outputs:
# - TE_clade_abundance_comparison.png: Bar plots showing the abundance of TE clades

###############################################################################

# Load Libraries
library(dplyr)   
library(ggplot2) 
library(tidyr)   

# /data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification/copia_sequences.fa.rexdb-plant.cls.tsv
# /data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification/gypsy_sequences.fa.rexdb-plant.cls.tsv
# /data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/assembly.fasta.mod.EDTA.TEanno.sum

# TE classification data and abundance summary
cls_file_gypsy <- "Gypsy_sequences.fa.rexdb-plant.cls.tsv"
cls_file_copia <- "Copia_sequences.fa.rexdb-plant.cls.tsv"
te_summary_file <- "assembly.fasta.mod.EDTA.TEanno.sum" 

# Load the TE classification data for Gypsy
cls_data_gypsy <- read.delim(cls_file_gypsy, header = TRUE)
print(colnames(cls_data_gypsy))  # Inspect the column names

# Calculate the abundance of Gypsy TE clades
te_abundance_gypsy <- cls_data_gypsy %>%
  group_by(Clade) %>%  # Group by the Clade column
  summarise(Abundance = n(), .groups = 'drop')  # Summarize to count occurrences
print(te_abundance_gypsy)

# Load the TE classification data for Copia
cls_data_copia <- read.delim(cls_file_copia, header = TRUE)
print(colnames(cls_data_copia))  # Inspect the column names

# Calculate the abundance of Copia TE clades
te_abundance_copia <- cls_data_copia %>%
  group_by(Clade) %>%  
  summarise(Abundance = n(), .groups = 'drop')  
print(te_abundance_copia)

# Load the summary data from the .sum file 
te_summary_data <- read.delim(te_summary_file, header = TRUE)
print(colnames(te_summary_data))  

# Create and save the Gypsy plot
te_clade_plot_gypsy <- ggplot(te_abundance_gypsy, aes(x = reorder(Clade, -Abundance), y = Abundance)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "Abundance of TE Clades - Gypsy",
       x = "TE Clade",
       y = "Abundance") +
  theme_bw() +  # Apply a clean theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  
        legend.title = element_blank()) 
ggsave("TE_clade_abundance_gypsy.png", plot = te_clade_plot_gypsy, width = 8, height = 6)

# Create and save the Copia plot
te_clade_plot_copia <- ggplot(te_abundance_copia, aes(x = reorder(Clade, -Abundance), y = Abundance)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Abundance of TE Clades - Copia",
       x = "TE Clade",
       y = "Abundance") +
  theme_bw() +  # Apply a clean theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  
        legend.title = element_blank())  
ggsave("TE_clade_abundance_copia.png", plot = te_clade_plot_copia, width = 8, height = 6)

