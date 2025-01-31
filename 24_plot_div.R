# This script was provided in the course. 
# Some additional adjustments and comments have been made to the script in order to inspect data and adjust plots.

# Purpose: Generate a Transposable Element (TE) Landscape Plot to visualize the divergence 
# and abundance of TEs across the genome for each superfamily

# Tool:
# R Software

# Inputs:
# - assembly.fasta.mod.out.landscape.Div.Rname.tab: TE annotation data from RepeatMasker

# Outputs:
# - TEdistribution_by_distance.pdf: Bar plot showing the distribution of TEs by distance
# - TE_violin_plots_by_superfamily.pdf: Violin plots showing the distribution of distances by TE superfamily
# - LTR_RT_counts.pdf: Bar plot showing counts of LTR-RT clades

###############################################################################

install.packages("hrbrthemes")
install.packages("remotes")

library(reshape2)
library(hrbrthemes)
library(tidyverse)
library(data.table)

# /data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/assembly.fasta.mod.EDTA.anno/assembly.fasta.mod.out.landscape.Div.Rfam.tab

# get data from parameter
data="assembly.fasta.mod.out.landscape.Div.Rname.tab"

rep_table <- fread(data, header = FALSE, sep = "\t")
rep_table %>% head()
# How does the data look like?

colnames(rep_table) <- c("Rname", "Rclass", "Rfam", 1:50)
rep_table <- rep_table%>%filter(Rfam!="unknown")
rep_table$fam <- paste(rep_table$Rclass, rep_table$Rfam, sep = "/")

table(rep_table$fam)
# How many elements are there in each Superfamily?

rep_table.m <- melt(rep_table)

rep_table.m <- rep_table.m[-c(which(rep_table.m$variable == 1)), ] # remove the peak at 1, as the library sequences are copies in the genome, they inflate this low divergence peak
# divergence peak

# Arrange the data so that they are in the following order:
# LTR/Copia, LTR/Gypsy, all types of DNA transposons (TIR transposons), DNA/Helitron, all types of MITES
rep_table.m$fam <- factor(rep_table.m$fam, levels = c(
  "LTR/Copia", "LTR/Gypsy", "DNA/DTA", "DNA/DTC", "DNA/DTH", "DNA/DTM", "DNA/DTT", "DNA/Helitron",
  "MITE/DTA", "MITE/DTC", "MITE/DTH", "MITE/DTM"
))

# NOTE: Check that all the superfamilies in your dataset are included above

rep_table.m$distance <- as.numeric(rep_table.m$variable)  / 100 # as it is percent divergence

# Question:
# rep_table.m$age <- ??? # Calculate using the substitution rate and the formula provided in the tutorial
substitution_rate <- 8.22e-9  # substitutions per site per year
rep_table.m$age <- rep_table.m$distance / (2 * substitution_rate)

options(scipen = 999)

# remove helitrons as EDTA is not able to annotate them properly (https://github.com/oushujun/EDTA/wiki/Making-sense-of-EDTA-usage-and-outputs---Q&A)
rep_table.m <- rep_table.m %>% filter(fam != "DNA/Helitron")

# Plot transposable element distribution by distance
ggplot(rep_table.m, aes(fill = fam, x = distance, weight = value / 1000000)) +
  geom_bar() +
  cowplot::theme_cowplot() +
  scale_fill_brewer(palette = "Paired") +
  xlab("Distance") +
  ylab("Sequence (Mbp)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, size = 9, hjust = 1),
        plot.title = element_text(hjust = 0.5)) +
  ggtitle("Transposable Element Distribution by Distance")

# Save the plot as a PDF
ggsave(filename = "TEdistribution_by_distance.pdf", width = 10, height = 5, useDingbats = FALSE)


# Question: Now can you get separate plots for each superfamily? Use violin plots for this
# Question: Do you have other clades of LTR-RTs not present in the full length elements? 

ggplot(rep_table.m, aes(x = distance)) +
  geom_histogram(bins = 30) +
  theme_minimal() +
  ggtitle("Distribution of Distance Values")

# Check unique distances by family
rep_table.m %>%
  group_by(fam) %>%
  summarise(unique_distances = n_distinct(distance),
            total_count = n())

# Separate violin plots for each superfamily
ggplot(rep_table.m, aes(x = fam, y = distance, fill = fam)) +
  geom_violin(scale = "area", trim = TRUE, bw = 0.5) + 
  geom_jitter(width = 0.2, size = 0.5, alpha = 0.6, color = "black") + 
  scale_fill_brewer(palette = "Paired") +
  xlab("Superfamily") +
  ylab("Distance") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, size = 9, hjust = 1),
        plot.title = element_text(hjust = 0.5)) +
  ggtitle("Violin Plots of Distance by Transposable Element Superfamily")

ggsave(filename = "TE_violin_plots_by_superfamily.pdf", width = 10, height = 5, useDingbats = FALSE)


clades_ltr <- rep_table %>% filter(Rclass %in% c("LTR")) %>%
  group_by(Rfam) %>%
  summarise(count = n())
# View clades of LTR-RTs
print(clades_ltr)
# Create a bar plot for LTR-RT counts
ggplot(clades_ltr, aes(x = Rfam, y = count, fill = Rfam)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set2") +
  xlab("LTR-RT Clade") +
  ylab("Count") +
  theme_minimal() +
  ggtitle("Counts of LTR-RT Clades")
ggsave(filename = "LTR_RT_counts.pdf", width = 6, height = 4, useDingbats = FALSE)

