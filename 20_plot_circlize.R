
# Purpose: Visualize TE densities across genomic scaffolds 

# Inputs:
# - *.fasta.mod.LTR.intact.gff3: GFF3 file listing genomic feature locations
# - *.fasta.faiFASTA index: file with scaffold information
# - *.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv: file with TE classifications

# Outputs:
# - TE_circlize_plot.pdf: PDF circular visualization of TE densities

###############################################################################

# load libraries
library(circlize)
library(ape)
library(tidyr)
library(dbplyr)
library(RColorBrewer)

# Input file names
gff_file <- "/data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/assembly.fasta.mod.EDTA.raw/LTR/assembly.fasta.mod.LTR.intact.gff3"  
fai_file <- "/data/users/acastro/genome_assembly_annotation/analysis/flyeEdi-0/assembly.fasta.fai"                  
te_classification_file <- "/data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/assembly.fasta.mod.EDTA.raw/LTR/classification/assembly.fasta.mod.LTR.intact.fa.rexdb-plant.dom.tsv" 

# Load GFF3 data and select the top 6 TE features
te_data <- read.gff(gff_file, GFF3 = TRUE) 
type_occurrences <- sort(table(te_data$type), decreasing = TRUE) 
top_te_types <- names(type_occurrences[1:6]) 
print(top_te_types)

# Exclude specific TE types from analysis
excluded_te_types <- c("LTR_retrotransposon", "repeat_region", "target_site_duplication", "long_terminal_repeat") 
filtered_te_types <- setdiff(top_te_types, excluded_te_types) 
print(filtered_te_types) 

# Filter the TE data frame for relevant types
filtered_te_data <- te_data %>% dplyr::filter(type %in% filtered_te_types)

# Load TE classification data and extract relevant columns
te_classification_data <- read.csv2(te_classification_file, header = TRUE, sep = "\t")
clade_info <- te_classification_data[, c("X.TE", "Clade", "Superfamily")] 
colnames(clade_info) <- c("ID", "Clade", "Superfamily") 
clade_info$ID <- sub("#.*$", "", clade_info$ID) 

# Extract CRM-specific data for density plotting
crm_data <- clade_info %>%
  separate(ID, into = c("seqid", "position"), sep = ":") %>%  # Split ID by ":"
  separate(position, into = c("start", "stop"), sep = "\\.\\.") %>% # Split position by ".."
  dplyr::filter(Clade == "CRM") 
crm_data$start <- as.numeric(crm_data$start) 
crm_data$stop <- as.numeric(crm_data$stop) 

# Extract Athila-specific data for density plotting
athila_data <- clade_info %>%
  separate(ID, into = c("seqid", "position"), sep = ":") %>%  # Split ID by ":"
  separate(position, into = c("start", "stop"), sep = "\\.\\.") %>% # Split position by ".."
  dplyr::filter(Clade == "Athila") 
athila_data$start <- as.numeric(athila_data$start) 
athila_data$stop <- as.numeric(athila_data$stop) 

# Load FASTA index data and select the top 15 largest scaffolds
fai_data <- read.table(fai_file, header = FALSE, sep = "\t")
top_scaffolds <- fai_data %>%
  dplyr::arrange(desc(V2)) %>% 
  head(15) 

# Ideogram data for circular plot
ideogram_data <- data.frame(
  scaffold = top_scaffolds$V1,
  start = rep(0, nrow(top_scaffolds)), 
  end = top_scaffolds$V2 
)

pdf("TE_circlize_plot.pdf", width = 10, height = 10)

# Initialize circular plot
circos.genomicInitialize(ideogram_data)

# Color palette for TE types
colors <- brewer.pal(8, "Set3") # Get color palette; increased to 8 to accommodate more colors

# Plot CRM density across scaffolds
te_density_data_crm <- crm_data[, c("seqid", "start", "stop")]
circos.genomicDensity(te_density_data_crm, track.height = 0.1, col = colors[1], window.size = 1e6)

# Plot Athila density across scaffolds
te_density_data_athila <- athila_data[, c("seqid", "start", "stop")]
circos.genomicDensity(te_density_data_athila, track.height = 0.1, col = colors[2], window.size = 1e6)

# Plot other filtered TE types
for (i in seq_along(filtered_te_types)) {  
  te_type <- filtered_te_types[i]  
  te_data_for_type <- filtered_te_data %>% dplyr::filter(type == te_type) 
  
  if (nrow(te_data_for_type) > 0) {  
    te_density_data <- te_data_for_type[, c("seqid", "start", "end")] 
    circos.genomicDensity(te_density_data, track.height = 0.1, col = colors[i + 2], window.size = 1e6)  
  }
}

# Add legend
legend("topright", legend = c("CRM", "Athila", filtered_te_types), 
       fill = colors[1:(length(filtered_te_types) + 2)], 
       title = "TE Superfamilies", cex = 0.7, bty = "n")

dev.off()
print(filtered_te_types)


