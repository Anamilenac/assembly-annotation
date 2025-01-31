#!/usr/bin/env bash

# Purpose: Get the genome assembly index

# Tool:
# SAMtools v1.13

# Input:
# - `*.fasta`: Genome assembly file to be indexed

# Output:
# - `Edi-0/:
#   - `*.fasta.fai`: Index file 

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=prepare_assembly
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_prepare_assembly_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_prepare_assembly_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Path assembly directory
DIR_FLYE_EDI=/data/users/$USER/genome_assembly_annotation/analysis/flyeEdi-0

# Load SAMtools module
module load SAMtools/1.13-GCC-10.3.0

#Generate Index (.fai) for Assembly
samtools faidx $DIR_FLYE_EDI/assembly.fasta
