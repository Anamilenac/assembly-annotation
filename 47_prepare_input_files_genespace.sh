#!/usr/bin/env bash

# Purpose: prepares a FASTA file with filtered sequences from the top 20 scaffolds for GENESPACE

# Tool:
# - faSomeRecords

# Inputs:
# - `genome1_peptide.fa`: A FASTA file containing peptide sequences with headers
# - `genespace_genes.txt`: A list of gene IDs for sequences to extract

# Outputs:
# - `*.fa`: A FASTA file with filtered sequences from the top 20 scaffolds

###############################################################################

#SBATCH --cpus-per-task=4
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=prepare_genespace
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_prepare_genespace_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_prepare_genespace_%j.e

# Input directory
DIR_FLYE="/data/users/acastro/genome_assembly_annotation/analysis/final_maker/files_edi-0"

# Output directory
DIR_PEPTIDE="$DIR_FLYE/genespace/peptide"
DIR_BED="$DIR_FLYE/genespace/bed"

# Directory TAIR10 reference files
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

# load modules
module load UCSC-Utils/448-foss-2021a
module load MariaDB/10.6.4-GCC-10.3.0

# Run faSomeRecords to filter sequences
faSomeRecords \
    $DIR_FLYE/genome1_peptide.fa \
    $DIR_FLYE/genespace_genes.txt \
    $DIR_PEPTIDE/genome1.fa

###############################################################################

# Additional steps required to organize the directory structure:

# Rename files with the accesion name
mv $DIR_BED/genome1.bed $DIR_BED/edi0.bed
mv $DIR_PEPTIDE/genome1.fa $DIR_PEPTIDE/edi0.fa

# copy the TAIR10 reference files
ln -s $COURSEDIR/data/TAIR10.bed $DIR_BED
ln -s $COURSEDIR/data/TAIR10.fa $DIR_PEPTIDE
