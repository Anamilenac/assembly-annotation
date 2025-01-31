#!/usr/bin/env bash

# Purpose: Uses fastp to trim, filter, and generate quality reports for raw sequencing
# reads from Edi-0 and Sha accessions

# Tool:
# fastp v0.23.4

# Inputs:
# - `*.fastq.gz`: Raw reads for Edi-0  in `raw_data/Edi-0`
# - `*_1.fastq.gz` and `*_2.fastq.gz`: Paired-end Sha reads in `raw_data/RNAseq_Sha`

# Outputs:
# - `fastpEdi-0/`:
#   - `*.html`: Quality report for Edi-0 reads
#
# - `fastpRNA/`:
#   - `*.html`: Quality report for RNA-seq reads
#   - `*_1.fastq.gz` and `*_2.fastq.gz`: Trimmed paired-end RNA-seq reads

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=trim
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_fastp_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_fastp_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directories for Edi-0 and raw RNA-seq read files.
DATA_DIR_EDI=/data/users/$USER/genome_assembly_annotation/raw_data/Edi-0
DATA_DIR_RNA=/data/users/$USER/genome_assembly_annotation/raw_data/RNAseq_Sha

# Output directories to save fastp results
DIR_FASTP_EDI=/data/users/$USER/genome_assembly_annotation/analysis/fastpEdi-0
DIR_FASTP_RNA=/data/users/$USER/genome_assembly_annotation/analysis/fastpRNA

# Create directories for fastp output reports
mkdir --parents $DIR_FASTP_EDI
mkdir --parents $DIR_FASTP_RNA

# Load fastp module for read quality trimming
module load fastp/0.23.4-GCC-10.3.0

# Run fastp quality control and trimming in Edi-0 reads
fastp --in1 $DATA_DIR_EDI/ERR11437331.fastq.gz --out1 /dev/null --html $DIR_FASTP_EDI/fastp_report.html

# Run fastp quality control and trimming in RNAseq_Sha reads
fastp --in1 $DATA_DIR_RNA/ERR754081_1.fastq.gz --in2 $DATA_DIR_RNA/ERR754081_2.fastq.gz \
      --out1 $DIR_FASTP_RNA/trim_ERR754081_1.fastq.gz --out2 $DIR_FASTP_RNA/trim_ERR754081_2.fastq.gz \
      --cut_front --cut_tail --cut_window_size 4 --cut_mean_quality 25 \
      --length_required 50 \
      --html $DIR_FASTP_RNA/fastp_report.html
