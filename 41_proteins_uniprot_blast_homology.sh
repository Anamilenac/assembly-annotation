#!/usr/bin/env bash

# Purpose: Annotate proteins with putative functions based on sequence similarity to functionally validated proteins

# Tool:
# BLAST+/2.15.0-gompi-2021a

# Inputs:
# - `uniprot_viridiplantae_reviewed.fa`: The UniProt-reviewed protein database for
#   the Viridiplantae plant lineage
#  `proteins.filtered.fasta`: MAKER-produced predicted proteins

# Outputs:
# `uniprot/`:
# - `blastp_output`: Results protein-to-protein sequence similarity search

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=uniprot
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_uniprot_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_uniprot_%j.e

# Input and output directory
DIR_MAKER_FINAL="/data/users/$USER/genome_assembly_annotation/analysis/final_maker"
DIR_UNIPROT=$DIR_MAKER_FINAL/uniprot
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

# Protein FASTA file
PROTEIN="${DIR_MAKER_FINAL}/proteins.filtered.fasta"

# Create output directories
mkdir --parents $DIR_UNIPROT

# load module
module load BLAST+/2.15.0-gompi-2021a

# Run BLASTP for protein sequence homology search
blastp -query "$PROTEIN" \
    -db "$COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa" \
    -num_threads 10 \
    -outfmt 6 \
    -evalue 1e-10 \
    -out "$DIR_UNIPROT/blastp_output"
