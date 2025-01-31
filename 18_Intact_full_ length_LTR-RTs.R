# This script was provided in the course
# Some additional comments have been made to the script in order to inspect data and adjust plots

# Purpose: Create plots showing the distribution of transposable element (TE) identities by superfamily and by clade

# Input:
# - `assembly.fasta.mod.LTR.intact.gff3`: Annotation data in GFF3 format
# - `assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv`: Classification for intact LTR retrotransposons

# Output:
# - `01_full-length-LTR-RT-superfamily.jpg`: Histogram of TE identity distribution by Superfamily
# - `01_full-length-LTR-RT-clades.jpg`: Histogram of TE identity distribution by Clade

###############################################################################

# Load libraries
install.packages("dplyr")
library(tidyverse)
library(data.table)
library(dplyr)

# Load the data
anno_data=read.table("/data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/assembly.fasta.mod.EDTA.raw/assembly.fasta.mod.LTR.intact.gff3",header=F,sep="\t")
head(anno_data)
# Get the classification table
classification <- fread("/data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/assembly.fasta.mod.EDTA.raw/LTR/classification/assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv")
head(classification)
# Separate first column into two columns at "#", name the columns "Name" and "Classification"
names(classification)[1]="TE"
classification=classification%>%separate(TE,into=c("Name","Classification"),sep="#")

# Check the superfamilies present in the GFF3 file, and their counts
anno_data$V3 %>% table()

# Filter the data to select only TE superfamilies, (long_terminal_repeat, repeat_region and target_site_duplication are features of TE)
anno_data_filtered <- anno_data[!anno_data$V3 %in% c("long_terminal_repeat","repeat_region","target_site_duplication"), ]
nrow(anno_data_filtered)
# QUESTION: How Many TEs are there in the annotation file?

# Check the Clades present in the GFF3 file, and their counts
# select the feature column V9 and get the Name and Identity of the TE
anno_data_filtered$named_lists <- lapply(anno_data_filtered$V9, function(line) {
  setNames(
    sapply(strsplit(strsplit(line, ";")[[1]], "="), `[`, 2),
    sapply(strsplit(strsplit(line, ";")[[1]], "="), `[`, 1)
  )
})

anno_data_filtered$Name <- unlist(lapply(anno_data_filtered$named_lists, function(x) {
  x["Name"]
}))

anno_data_filtered$Identity <-unlist(lapply(anno_data_filtered$named_lists, function(x) {
  x["ltr_identity"]
}) )

anno_data_filtered$length <- anno_data_filtered$V5 - anno_data_filtered$V4

anno_data_filtered =anno_data_filtered %>%select(V1,V4,V5,V3,Name,Identity,length) 
head(anno_data_filtered)

# Merge the classification table with the annotation data
anno_data_filtered_classified=merge(anno_data_filtered,classification,by="Name",all.x=T)

table(anno_data_filtered_classified$Superfamily)
# QUESTION: Most abundant superfamilies are?

table(anno_data_filtered_classified$Clade)
# QUESTION: Most abundant clades are?

# summary table
summary_table <- anno_data_filtered_classified %>%
  group_by(Clade, Superfamily) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  arrange(Clade, Superfamily)
print(summary_table)

# Now plot the distribution of TE percent identity per clade 

anno_data_filtered_classified$Identity=as.numeric(as.character(anno_data_filtered_classified$Identity))

anno_data_filtered_classified$Clade=as.factor(anno_data_filtered_classified$Clade)

# Create a f plots for each Superfamily
plot_sf = ggplot(anno_data_filtered_classified, aes(x = Identity)) +
  geom_histogram(color = "black", fill = "grey") +
  facet_grid(Superfamily ~ .) +  
  cowplot::theme_cowplot() 

jpeg("01_full-length-LTR-RT-superfamily.jpg", width = 8, height = 10, units = "in", res = 300)
print(plot_sf)
dev.off()

# Create plots for each clade
plot_cl = ggplot(anno_data_filtered_classified[anno_data_filtered_classified$Superfamily != "unknown",], aes(x = Identity)) +
  geom_histogram(color = "black", fill = "grey") +
  facet_grid(Clade ~ Superfamily) +  
  cowplot::theme_cowplot()

jpeg("01_full-length-LTR-RT-clades.jpg", width = 10, height = 20, units = "in", res = 300)
print(plot_cl)
dev.off()

