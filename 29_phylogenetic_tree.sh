#!/usr/bin/env bash

# Purpose: Align Copia and Gypsy retrotransposons from Brassicaceae and
# Arabidopsis to build phylogenetic trees.

# Tools:
# - Clustal Omega v1.2.4
# - FastTree v2.1.11

# Inputs:
# - `Copia_RT.fasta`: Copia retrotransposon sequences for Arabidopsis
# - `Copia_RT_Brassicaceae.fasta`: Copia retrotransposon sequences for Brassicaceae
# - `Gypsy_RT.fasta`: Gypsy retrotransposon sequences for Arabidopsis
# - `Gypsy_RT_Brassicaceae.fasta`: Gypsy retrotransposon sequences for Brassicaceae

# Outputs:
# `superfamily_classification/`:
#   -`concatenated_Copia_RT.fasta`: Combined Copia sequences from Arabidopsis and Brassicaceae
#   -`concatenated_Gypsy_RT.fasta`: Combined Gypsy sequences from Arabidopsis and Brassicaceae
#   -`aligned_Copia_RT.fasta`: Aligned Copia sequences
#   -`aligned_Gypsy_RT.fasta`: Aligned Gypsy sequences
#   -`aligned_Copia_RT_tree.nwk`: Phylogenetic tree for aligned Copia sequences
#   -`aligned_Gypsy_RT_tree.nwk`: Phylogenetic tree for aligned Gypsy sequences

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=phylogenetic_tree
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_phylogenetic_tree_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_phylogenetic_tree_%j.e


# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directory for input and output files
DIR_TE_CLASSIFICATION=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification

# Load modules
module load Clustal-Omega/1.2.4-GCC-10.3.0
module load FastTree/2.1.11-GCCcore-10.3.0

# Clustal Omega for multiple sequence alignment
clustalo -i $DIR_TE_CLASSIFICATION/concatenated_Copia_RT.fasta -o $DIR_TE_CLASSIFICATION/aligned_Copia_RT.fasta --outfmt=fasta
clustalo -i $DIR_TE_CLASSIFICATION/concatenated_Gypsy_RT.fasta -o $DIR_TE_CLASSIFICATION/aligned_Gypsy_RT.fasta --outfmt=fasta

# FastTree to build phylogenetic trees
FastTree -out $DIR_TE_CLASSIFICATION/aligned_Copia_RT_tree.nwk $DIR_TE_CLASSIFICATION/aligned_Copia_RT.fasta
FastTree -out $DIR_TE_CLASSIFICATION/aligned_Gypsy_RT_tree.nwk $DIR_TE_CLASSIFICATION/aligned_Gypsy_RT.fasta
