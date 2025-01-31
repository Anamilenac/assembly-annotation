#!/usr/bin/env bash

# Purpose: Prepare a list of density values per clade to use in the iTOL tool for displaying 
# phylogenetic trees

# Input:
# - `*.list_sum.txt`: A summary file generated from *.mod.EDTA.TEanno.sum with 
#    density data organized by clade

# Output:
# `flye`
# - `*.txt`: Extracted density values per clade

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=prepare_tree_density
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_prepare_tree_density_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_prepare_tree_density_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directory input
DIR_SUM_TE=/data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye

# Extract density
awk '{
    printf "%s,%s\n", $1, $2
}' "$DIR_SUM_TE/list_sum.txt" >>"$DIR_SUM_TE/density.txt"
