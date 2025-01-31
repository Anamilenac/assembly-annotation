#!/usr/bin/env bash

# Purpose: Assemble genome for Edi-0 using LJA (Long-Read Assembler) with PacBio HiFi reads

# Tool:
# LJA v0.2

# Input:
# - `*.gz`: PacBio HiFi compressed reads for Edi-0 located in `raw_data` directory

# Outputs:
# - `ljaEdi-0/`:
#   - `assembly.fasta`: Assembled genome sequence
#   - Additional files

###############################################################################

#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=lja
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_lja_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_lja_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory
DATA_DIR_EDI=/data/users/$USER/genome_assembly_annotation/raw_data/Edi-0

# Output directory
DIR_LJA_EDI=/data/users/$USER/genome_assembly_annotation/analysis/ljaEdi-0

# Create directories to save results
mkdir --parents $DIR_LJA_EDI

# Run LJA for Edi-0
apptainer exec \
  --bind $DIR_LJA_EDI \
  /containers/apptainer/lja-0.2.sif \
  lja --output-dir $DIR_LJA_EDI \
  --reads $DATA_DIR_EDI/*.gz \
  --threads 16
