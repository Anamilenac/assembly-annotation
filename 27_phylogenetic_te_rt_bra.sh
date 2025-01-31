#!/usr/bin/env bash

# Purpose: Obtain Copia and Gypsy retrotransposon sequences (Ty1-RT and Ty3-RT)
# from the Brassicaceae TE domain databases (DB) to be used in the next step of the phylogenetic tree analysis

# Tools:
# SeqKit v2.6.1

# Inputs:
# - `copia_sequences_Brassicaceae.fa.rexdb-plant.dom.faa`: DB Copia retrotransposon domain sequences
# - `gypsy_sequences_Brassicaceae.fa.rexdb-plant.dom.faa`: DB Gypsy retrotransposon domain sequences

# Outputs:
# `superfamily_classification/`:
#   - `copia_RT_Brassicaceae.fasta`: Extracted Ty1-RT sequences for Copia
#   - `gypsy_RT_Brassicaceae.fasta`: Extracted Ty3-RT sequences for Gypsy

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=phylogenetic_te_rt_bra
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_phylogenetic_te_rt_bra_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_phylogenetic_te_rt_bra_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directories and file paths for input and output files
DIR_TE_CLASSIFICATION=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification
DIR_RT_DOMAIN_COPIA_BRA=$DIR_TE_CLASSIFICATION/copia_sequences_Brassicaceae.fa.rexdb-plant.dom.faa
DIR_RT_DOMAIN_GYPSI_BRA=$DIR_TE_CLASSIFICATION/gypsy_sequences_Brassicaceae.fa.rexdb-plant.dom.faa

# Load modules
module load SeqKit/2.6.1

# Extract RT sequences for Copia (Ty1-RT) from Brassicaceae
grep Ty1-RT $DIR_RT_DOMAIN_COPIA_BRA >$DIR_TE_CLASSIFICATION/copia_list_Brassicaceae.txt
sed -i 's/>//' $DIR_TE_CLASSIFICATION/copia_list_Brassicaceae.txt
sed -i 's/ .\+//' $DIR_TE_CLASSIFICATION/copia_list_Brassicaceae.txt
seqkit grep -f $DIR_TE_CLASSIFICATION/copia_list_Brassicaceae.txt $DIR_RT_DOMAIN_COPIA_BRA -o $DIR_TE_CLASSIFICATION/copia_RT_Brassicaceae.fasta

# Extract RT sequences for Gypsy (Ty3-RT) from Brassicaceae
grep Ty3-RT $DIR_RT_DOMAIN_GYPSI_BRA >$DIR_TE_CLASSIFICATION/gypsy_list_Brassicaceae.txt
sed -i 's/>//' $DIR_TE_CLASSIFICATION/gypsy_list_Brassicaceae.txt
sed -i 's/ .\+//' $DIR_TE_CLASSIFICATION/gypsy_list_Brassicaceae.txt
seqkit grep -f $DIR_TE_CLASSIFICATION/gypsy_list_Brassicaceae.txt $DIR_RT_DOMAIN_GYPSI_BRA -o $DIR_TE_CLASSIFICATION/gypsy_RT_Brassicaceae.fasta
