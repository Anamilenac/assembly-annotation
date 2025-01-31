#!/usr/bin/env bash

# Purpose: Perform k-mer counting on raw and trimmed reads for Edi-0 and Sha accessions

# Tool:
# Jellyfish v2.3.0

# Inputs:
# - `*.fastq.gz`: Edi-0 raw reads in `raw_data`
# - `*_1.fastq.gz` and `*_2.fastq.gz`: RNA-seq raw reads in `raw_data`
# - `*_1.fastq.gz` and `*_2.fastq.gz`: RNA-seq trimmed reads in `fastpRNA`

# Outputs:
# - `jellyfishEdi-0/`: 
#   - `*.jf`: k-mer count file
#   - `*.txt`: k-mer frequency histogram
#
# - `jellyfishRNA/`: 
#   - `*.jf`: k-mer count file
#   - `*.txt`: k-mer frequency histogram
#
# - `jellyfishRNA_trimmed/`: 
#   - `*.jf`: k-mer count file
#   - `*.txt`: k-mer frequency histogram

###############################################################################

#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=jellyfish
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_jellyfish_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_jellyfish_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Inputs directories 
DATA_DIR_EDI=/data/users/$USER/genome_assembly_annotation/raw_data/Edi-0
DATA_DIR_RNA=/data/users/$USER/genome_assembly_annotation/raw_data/RNAseq_Sha
DIR_FASTP_RNA=/data/users/$USER/genome_assembly_annotation/analysis/fastpRNA

# Output directories 
DIR_JELLYFISH_EDI=/data/users/$USER/genome_assembly_annotation/analysis/jellyfishEdi-0
DIR_JELLYFISH_RNA=/data/users/$USER/genome_assembly_annotation/analysis/jellyfishRNA
DIR_JELLYFISH_RNA_TRIM=/data/users/$USER/genome_assembly_annotation/analysis/jellyfishRNA_trimmed

# Create directories to save results
mkdir --parents $DIR_JELLYFISH_EDI
mkdir --parents $DIR_JELLYFISH_RNA
mkdir --parents $DIR_JELLYFISH_RNA_TRIM

# Load the Jellyfish module
module load Jellyfish/2.3.0-GCC-10.3.0 

# Run Jellyfish k-mer counting for Edi-0 raw reads
jellyfish count \
    --canonical --mer-len=21 --size 1000000000 --threads 4 \
    <(zcat $DATA_DIR_EDI/ERR11437331.fastq.gz) \
    -o $DIR_JELLYFISH_EDI/kmer_counts_edi.jf && \
jellyfish histo --threads 10 $DIR_JELLYFISH_EDI/kmer_counts_edi.jf > $DIR_JELLYFISH_EDI/edi_kmer_histogram.txt

# Run Jellyfish k-mer counting for trimmed RNA-seq reads
jellyfish count \
    --canonical --mer-len=21 --size 1000000000 --threads 4 \
    <(zcat $DIR_FASTP_RNA/trim_ERR754081_1.fastq.gz) \
    <(zcat $DIR_FASTP_RNA/trim_ERR754081_2.fastq.gz) \
    -o $DIR_JELLYFISH_RNA_TRIM/kmer_counts_RNA.jf && \
jellyfish histo --threads 10 $DIR_JELLYFISH_RNA_TRIM/kmer_counts_RNA.jf > $DIR_JELLYFISH_RNA_TRIM/kmer_counts_RNA.txt

# Run Jellyfish k-mer counting for untrimmed RNA-seq reads
jellyfish count \
    --canonical --mer-len=21 --size 1000000000 --threads 4 \
    <(zcat $DATA_DIR_RNA/ERR754081_1.fastq.gz) \
    <(zcat $DATA_DIR_RNA/ERR754081_2.fastq.gz) \
    -o $DIR_JELLYFISH_RNA/kmer_counts_RNA.jf && \
jellyfish histo --threads 10 $DIR_JELLYFISH_RNA/kmer_counts_RNA.jf > $DIR_JELLYFISH_RNA/kmer_counts_RNA.txt
