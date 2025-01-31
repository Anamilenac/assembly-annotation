#!/usr/bin/env bash

# Purpose: Classifies intact Long Terminal Repeat (LTR) transposable elements from the genome assembly

# Tool:
# TEsorter 1.3.0

# Input:
# - `*.fasta.mod.LTR.intact.fa`: Intact Long Terminal Repeat (LTR) retrotransposon sequences

# Output:
# - `classification/`:
#    - `*.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv`: Classification for intact LTR retrotransposons
#    - Additional files

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=LTR_classification
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_LTR_classification_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_LTR_classification_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory
DIR_EDTA_LTR=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye/assembly.fasta.mod.EDTA.raw/LTR

# Output directory
DIR_LTR_CLASSIFICATION=$DIR_EDTA_LTR/classification

# Create directory to save results
mkdir --parents $DIR_LTR_CLASSIFICATION

# LTR classification
apptainer exec -C -H $DIR_LTR_CLASSIFICATION \
  --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif \
  TEsorter $DIR_EDTA_LTR/assembly.fasta.mod.LTR.intact.fa -db rexdb-plant
