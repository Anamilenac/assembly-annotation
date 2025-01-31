#!/usr/bin/env bash

# Purpose: Obtain shortened identifiers of RT sequences to be used in the next step of the phylogenetic tree analysis

# Inputs:
# - `Copia_RT.fasta`: Copia retrotransposon sequences for Arabidopsis
# - `Copia_RT_Brassicaceae.fasta`: Copia retrotransposon sequences for Brassicaceae
# - `Gypsy_RT.fasta`: Gypsy retrotransposon sequences for Arabidopsis
# - `Gypsy_RT_Brassicaceae.fasta`: Gypsy retrotransposon sequences for Brassicaceae

# Outputs:
# `superfamily_classification/`
#   - same input files modified

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=phylogenetic_id_tree
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_phylogenetic_id_tree_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_phylogenetic_id_tree_%j.e


# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directory for input and output files
DIR_TE_CLASSIFICATION=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification

# Concatenate RT Sequences from Both Brassicaceae and Arabidopsis
cat $DIR_TE_CLASSIFICATION/copia_RT.fasta $DIR_TE_CLASSIFICATION/copia_RT_Brassicaceae.fasta >$DIR_TE_CLASSIFICATION/concatenated_Copia_RT.fasta
cat $DIR_TE_CLASSIFICATION/gypsy_RT.fasta $DIR_TE_CLASSIFICATION/gypsy_RT_Brassicaceae.fasta >$DIR_TE_CLASSIFICATION/concatenated_Gypsy_RT.fasta

# Shorten identifiers of RT sequences
sed -i 's/#.*//' $DIR_TE_CLASSIFICATION/concatenated_Copia_RT.fasta
sed -i 's/:/_/g' $DIR_TE_CLASSIFICATION/concatenated_Copia_RT.fasta
sed -i -E 's/^>([^|]+)\|.*$/>\1/' $DIR_TE_CLASSIFICATION/concatenated_Copia_RT.fasta

sed -i 's/#.\+//' $DIR_TE_CLASSIFICATION/concatenated_Gypsy_RT.fasta
sed -i 's/:/_/g' $DIR_TE_CLASSIFICATION/concatenated_Gypsy_RT.fasta
sed -i -E 's/^>([^|]+)\|.*$/>\1/' $DIR_TE_CLASSIFICATION/concatenated_Gypsy_RT.fasta
