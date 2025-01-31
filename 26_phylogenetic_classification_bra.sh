#!/usr/bin/env bash

# Purpose: Obtain Copia and Gypsy retrotransposon classification from Brassicaceae TE sequences 
# to be used in the next step of the phylogenetic tree analysis

# Tools:
# SeqKit v2.6.1
# TEsorter v1.3.0

# Input:
# `Brassicaceae_repbase_all_march2019.fasta`: DB TE sequences

# Outputs:
# `superfamily_classification/`:
#   - `copia_sequences_Brassicaceae.fa`: Extracted Copia sequences
#   - `gypsy_sequences_Brassicaceae.fa`: Extracted Gypsy sequences

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=phylogenetic_classification_bra
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_phylogenetic_classification_bra_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_phylogenetic_classification_bra_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input file
Brassicaceae_TE_db=/data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta

# Output directory
DIR_TE_CLASSIFICATION=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification

# Load the SeqKit module
module load SeqKit/2.6.1

# Extract Copia and Gypsy sequences from the Brassicaceae TE database
seqkit grep -r -p "Copia" $Brassicaceae_TE_db >$DIR_TE_CLASSIFICATION/copia_sequences_Brassicaceae.fa
seqkit grep -r -p "Gypsy" $Brassicaceae_TE_db >$DIR_TE_CLASSIFICATION/gypsy_sequences_Brassicaceae.fa

# Copia retrotransposons classification
apptainer exec -C -H $DIR_TE_CLASSIFICATION \
    --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif TEsorter $DIR_TE_CLASSIFICATION/copia_sequences_Brassicaceae.fa -db rexdb-plant

# Gypsy retrotransposons classification
apptainer exec -C -H $DIR_TE_CLASSIFICATION \
    --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif TEsorter $DIR_TE_CLASSIFICATION/gypsy_sequences_Brassicaceae.fa -db rexdb-plant
