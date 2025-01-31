#!/usr/bin/env bash

# Purpose: Perform FastQC on trimmed Sha reads to assess the quality of the filtered data.

# Tool:
# FastQC v0.12.1

# Input:
# - `*.gz` files: Trimmed Sha reads in the `fastpRNA` directory

# Outputs:
# - `fastqcRNA/`: 
#   - `*_fastqc.html`: HTML report
#   - `*_fastqc.zip`: File with raw data and summary

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=fastqc_trimmed
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_qctrimmed_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_qctrimmed_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory
DATA_DIR_RNA=/data/users/$USER/genome_assembly_annotation/raw_data/RNAseq_Sha

# Output directory
DIR_FASTP_RNA=/data/users/$USER/genome_assembly_annotation/analysis/fastpRNA

# Run FastQC on all trimmed RNA-seq reads
apptainer exec \
    --bind $DIR_FASTP_RNA \
    /containers/apptainer/fastqc-0.12.1.sif \
    fastqc --outdir $DIR_FASTP_RNA $DIR_FASTP_RNA/*.gz
