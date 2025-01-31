#!/usr/bin/env bash

# Purpose: Assemble transcriptomes from RNA-seq data using Trinity

# Tool:
# Trinity v2.15.1

# Inputs:
# - `*_1.fastq.gz`: Trimmed left read file from the `fastpRNA` directory
# - `*_2.fastq.gz`: Trimmed right read file from the `fastpRNA` directory

# Outputs:
# - `trinityRNA/`:
#   - `*.Trinity.fasta`: Assembled transcripts.
#   - Additional files

###############################################################################

#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=trinity
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_trinity_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_trinity_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory
DIR_FASTP_RNA=/data/users/$USER/genome_assembly_annotation/analysis/fastpRNA

# Ouput directory
DIR_TRINITY_RNA=/data/users/$USER/genome_assembly_annotation/analysis/trinityRNA

# Create directories to save results
mkdir --parents $DIR_TRINITY_RNA

# Load the Trinity module
module load Trinity/2.15.1-foss-2021a

# Run Trinity
Trinity --seqType fq --max_memory 50G \
        --left $DIR_FASTP_RNA/trim_ERR754081_1.fastq.gz \
        --right $DIR_FASTP_RNA/trim_ERR754081_2.fastq.gz \
        --CPU 16 \
        --output $DIR_TRINITY_RNA
