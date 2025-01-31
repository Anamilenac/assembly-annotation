#!/usr/bin/env bash

# Purpose: Refining clade-level classification of Copia and Gypsy transposable element sequences.

# Tools:
# - SeqKit v2.6.1 
# - TEsorter v1.3.0 

# Input:
# -`assembly.fasta.mod.EDTA.TElib.fa`: TE library with transposable element sequences

# Outputs:
# - `superfamily_classification/`
#   - *.rexdb-plant.dom.faa: Annotated protein sequences.
#   - *.rexdb-plant.cls.tsv: classification of transposable elements into their 
#       classes, orders, and families

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=superfamily_classification
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_superfamily_classification_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_superfamily_classification_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory
DIR_EDTA=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye

# Output directory 
DIR_SUPERFAMILY_CLASSIFICATION=$DIR_EDTA/superfamily_classification

# Create directory to save outputs
mkdir --parents $DIR_SUPERFAMILY_CLASSIFICATION

# Load the SeqKit module
module load SeqKit/2.6.1

# Extract Copia and Gypsy sequences
seqkit grep -r -p "Copia" $DIR_EDTA/assembly.fasta.mod.EDTA.TElib.fa >$DIR_SUPERFAMILY_CLASSIFICATION/copia_sequences.fa
seqkit grep -r -p "Gypsy" $DIR_EDTA/assembly.fasta.mod.EDTA.TElib.fa >$DIR_SUPERFAMILY_CLASSIFICATION/gypsy_sequences.fa

# Classify Copia sequences 
apptainer exec -C -H $DIR_SUPERFAMILY_CLASSIFICATION \
  --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif  \
  TEsorter $DIR_SUPERFAMILY_CLASSIFICATION/copia_sequences.fa -db rexdb-plant

# Classify Gypsy sequences 
apptainer exec -C -H $DIR_SUPERFAMILY_CLASSIFICATION \
  --writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif  \
  TEsorter $DIR_SUPERFAMILY_CLASSIFICATION/gypsy_sequences.fa -db rexdb-plant
