#!/usr/bin/env bash

# Purpose: Perform orthology-based gene annotation quality checks, identify orthologous gene relationships 

# Tool:
# OMArk-0.3.0

# Inputs:
# - `*.proteins.fasta.renamed.fasta`: The protein sequences obtained from MAKER gene annotation
# - `LUCA.h5`: The OMA database file containing the "LUCA" (Last Universal Common Ancestor)
#   orthologous relationships for different species
# - `isoform_list.txt`: File listing isoforms for each gene

# Outputs:
# - `omark/`:
#   - `omamer.rename.fasta`: A FASTA file containing sequences that are mapped to
#      the orthologous groups in the LUCA database
#   - `omark_output`: A directory containing the output results, which includes
#      orthology-based annotations and quality assessments

###############################################################################

#SBATCH --cpus-per-task=10
#SBATCH --time=2-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=orthology
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_orthology_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_orthology_%j.e

# Initialize Conda for the current session
eval "$(/home/amaalouf/miniconda3/bin/conda shell.bash hook)"

# Activate the OMArk environment
conda activate OMArk

# Define input and output directories
DIR_MAKER_FINAL="/data/users/$USER/genome_assembly_annotation/analysis/final_maker"
DIR_MAKER_OMARK="$DIR_MAKER_FINAL/omark"

# OMArk software directory
OMArk="/data/courses/assembly-annotation-course/CDS_annotation/softwares/OMArk-0.3.0/"

# Create output directory
mkdir --parents "$DIR_MAKER_OMARK"

# Download the OMA Database
wget https://omabrowser.org/All/LUCA.h5 -O LUCA.h5

# # Run OMAmer search
omamer search \
     --db LUCA.h5 \
     --query "$DIR_MAKER_FINAL/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.fasta" \
     --out "$DIR_MAKER_OMARK/omamer.rename.fasta"

# Run OMAmer
omark -f "$DIR_MAKER_OMARK/omamer.rename.fasta" \
     -of "$DIR_MAKER_FINAL/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.fasta" \
     -i "$DIR_MAKER_OMARK/isoform_list.txt" \
     -d LUCA.h5 \
     -o "$DIR_MAKER_OMARK/omark_output"
