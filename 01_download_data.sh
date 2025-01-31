#!/usr/bin/env bash

# Purpose: Create project directories and access raw reads.

### Output:
# - `raw_data/`:
#   - `Edi-0/*.fastq.gz`: Raw read file for Edi-0
#   - `RNAseq_Sha/*_1.fastq.gz`: Forward read file for RNA-seq
#   - `RNAseq_Sha/*_2.fastq.gz`: Reverse read file for RNA-seq
# - `analysis/`
# - `log/`

###############################################################################

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# raw data directory
DATA_DIR=/data/users/$USER/genome_assembly_annotation/raw_data

# Create directories to save reads
mkdir --parents /data/users/$USER/genome_assembly_annotation/raw_data

# Create directories to save analysis
mkdir --parents /data/users/$USER/genome_assembly_annotation/analysis

# Create directories to save logs
mkdir --parents /data/users/$USER/genome_assembly_annotation/log

# Direct access Edi-0 raw reads
ln -s /data/courses/assembly-annotation-course/raw_data/Edi-0 ./

# direct access RNA_seq_Sha raw reads
ln -s /data/courses/assembly-annotation-course/raw_data/RNAseq_Sha ./
