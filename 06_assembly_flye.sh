#!/usr/bin/env bash

# Purpose: Assemble genome data using Flye for the Edi-0 genome

# Tool:
# Flye v2.9.5

# Input:
# - `*.fastq.gz`: PacBio HiFi reads for Edi-0 from the `raw_data` directory

# Outputs:
# - `flyeEdi-0/`:
#   - `assembly.fasta`: Assembled genome sequence
#   - Additional files

###############################################################################

#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=flye
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_flye_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_flye_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory
DATA_DIR_EDI=/data/users/$USER/genome_assembly_annotation/raw_data/Edi-0

# Output directory
DIR_FLYE_EDI=/data/users/$USER/genome_assembly_annotation/analysis/flyeEdi-0

# Create directories for assembly output
mkdir --parents $DIR_FLYE_EDI

# Run Flye for Edi-0
apptainer exec \
  --bind $DIR_FLYE_EDI \
  /containers/apptainer/flye_2.9.5.sif \
  flye --pacbio-hifi $DATA_DIR_EDI/ERR11437331.fastq.gz \
  --threads 16 \
  --out-dir $DIR_FLYE_EDI \
  --genome-size 153000000
