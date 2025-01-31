#!/usr/bin/env bash

# Purpose: Obtain the reverse transcriptase (RT) sequences for Copia and Gypsy
# transposable elements to be used in the next step of the phylogenetic tree analysis

# Tools:
# SeqKit v2.6.1

# Inputs:
# 1. `*.fa.rexdb-plant.dom.faa`: RT domain sequences for Copia
# 2. `*.fa.rexdb-plant.dom.faa`: RT domain sequences for Gypsy

# Outputs:
# `superfamily_classification/`:
#   - `copia_RT.fasta`: Extracted RT sequences for Copia
#   - `cypsy_RT.fasta`: Extracted RT sequences for Gypsy

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=phylogenetic_te_rt
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_phylogenetic_te_rt_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_phylogenetic_te_rt_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directories and file paths for input and output files
DIR_TE_CLASSIFICATION=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification
DIR_RT_DOMAIN_COPIA=$DIR_TE_CLASSIFICATION/copia_sequences.fa.rexdb-plant.dom.faa
DIR_RT_DOMAIN_GYPSI=$DIR_TE_CLASSIFICATION/gypsy_sequences.fa.rexdb-plant.dom.faa

# Load modules
module load SeqKit/2.6.1

# Extract RT sequences for Copia (Ty1-RT)
grep Ty1-RT $DIR_RT_DOMAIN_COPIA >$DIR_TE_CLASSIFICATION/copia_list.txt
sed -i 's/>//' $DIR_TE_CLASSIFICATION/copia_list.txt
sed -i 's/ .\+//' $DIR_TE_CLASSIFICATION/copia_list.txt
seqkit grep -f $DIR_TE_CLASSIFICATION/copia_list.txt $DIR_RT_DOMAIN_COPIA -o $DIR_TE_CLASSIFICATION/copia_RT.fasta

# Extract RT sequences for Gypsy (Ty3-RT)
grep Ty3-RT $DIR_RT_DOMAIN_GYPSI >$DIR_TE_CLASSIFICATION/gypsy_list.txt
sed -i 's/>//' $DIR_TE_CLASSIFICATION/gypsy_list.txt
sed -i 's/ .\+//' $DIR_TE_CLASSIFICATION/gypsy_list.txt
seqkit grep -f $DIR_TE_CLASSIFICATION/gypsy_list.txt $DIR_RT_DOMAIN_GYPSI -o $DIR_TE_CLASSIFICATION/gypsy_RT.fasta
