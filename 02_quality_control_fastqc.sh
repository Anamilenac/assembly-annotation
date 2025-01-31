#!/usr/bin/env bash

# Purpose: Implements FastQC to assess the quality of raw sequencing reads for
# genome accession Edi-0 and trasncriptome accession Sha

# Tool:
# FastQC v0.12.1

# Inputs:
# - `*.gz`: raw read files for Edi-0 
# - `*.gz`: raw read files for Sha

# Outputs:
# - `fastqcEdi-0/`: 
#   - `*_fastqc.html`: HTML report
#   - `*_fastqc.zip`: Compressed file with raw data and summary
#
# - `fastqcRNA/`: 
#   - `*_fastqc.html`: HTML report
#   - `*_fastqc.zip`: Raw data and summary

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=fastqc
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_quality_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_quality_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directories for Edi-0 and raw RNA-seq read files.
DATA_DIR_EDI=/data/users/$USER/genome_assembly_annotation/raw_data/Edi-0
DATA_DIR_RNA=/data/users/$USER/genome_assembly_annotation/raw_data/RNAseq_Sha

# Ouput directories to save FASTQC results
FASTQC_DIR_EDI=/data/users/$USER/genome_assembly_annotation/analysis/fastqcEdi-0
FASTQC_DIR_RNA=/data/users/$USER/genome_assembly_annotation/analysis/fastqcRNA

# Create output directories 
mkdir --parents $FASTQC_DIR_EDI
mkdir --parents $FASTQC_DIR_RNA

# Run FastQC for Edi-0 data
apptainer exec \
    --bind $FASTQC_DIR_EDI \
    /containers/apptainer/fastqc-0.12.1.sif \
    fastqc --outdir $FASTQC_DIR_EDI $DATA_DIR_EDI/*.gz

# Run FastQC for RNA-seq data
apptainer exec \
    --bind $FASTQC_DIR_RNA \
    /containers/apptainer/fastqc-0.12.1.sif \
    fastqc --outdir $FASTQC_DIR_RNA $DATA_DIR_RNA/*.gz
