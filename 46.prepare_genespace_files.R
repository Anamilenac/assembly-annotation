# This script was provided in the course

# Purpose: Processes gene annotation, filters for genes on the top 20 
# scaffolds, and generates a BED file and corresponding protein sequence file 
# for GENESPACE

# Inputs:
# - `filtered.genes.renamed.final.gff3`: Gene annotation file in GFF3 format
# - `assembly.fasta.fai`: Index file of the genome assembly, used to identify
#   the top 20 longest scaffolds
# - `proteins.longest.fasta`: File containing longest protein sequences in FASTA format
# - `genespace_genes.txt`: Text file listing gene IDs to filter protein sequences

# Outputs:
# - `genespace/bed/genome1.bed`: A BED file containing the coordinates of genes 
#   located on the top 20 longest scaffolds
# - `genespace/peptide/genome1.fa`: A FASTA file containing peptide sequences 
#   corresponding to the genes on the top 20 scaffolds

###############################################################################

library(data.table)
library(tidyverse)

# Load the annotation
annotation <- fread("filtered.genes.renamed.final.gff3", header = FALSE, sep = "\t")
bed_genes <- annotation %>%
  filter(V3 == "gene") %>%
  select(V1, V4, V5, V9) %>%
  mutate(gene_id = as.character(str_extract(V9, "ID=[^;]*"))) %>%
  mutate(gene_id = as.character(str_replace(gene_id, "ID=", ""))) %>%
  select(-V9)

top20_scaff <- fread("assembly.fasta.fai", header = FALSE, sep = "\t") %>%
  select(V1, V2) %>%
  arrange(desc(V2)) %>%
  head(20)

print(top20_scaff)

# Write the bed file
bed_genes <- bed_genes %>%
  filter(V1 %in% top20_scaff$V1)
print(bed_genes)

# Verify outputs
gene_id <- bed_genes$gene_id
write.table(gene_id, "genespace_genes.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

unique_scaffolds <- length(unique(bed_genes$V1))
print(unique_scaffolds)

scaffold_gene_counts <- bed_genes %>%
  group_by(V1) %>%
  tally() %>%
  arrange(desc(n))
print(scaffold_gene_counts)


# Load the longest protein sequences
longest_proteins <-"proteins.longest.fasta"
print(longest_proteins)

# make a genespace specific directory
if (!dir.exists("genespace")) {
  dir.create("genespace")
}
if (!dir.exists("genespace/bed")) {
  dir.create("genespace/bed")
}
if (!dir.exists("genespace/peptide")) {
  dir.create("genespace/peptide")
}

write.table(bed_genes, "genespace/bed/genome1.bed", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

# remove "-R.*" from fasta headers of proteins, to get only gene IDs
system(paste("sed 's/^>>/>/' ", longest_proteins, " > genome1_peptide.fa", sep = ""))

print(genome1_peptide.fa)

# filter to select only proteins of the top 20 scaffolds
system("faSomeRecords genome1_peptide.fa genespace_genes.txt genespace/peptide/genome1.fa")
