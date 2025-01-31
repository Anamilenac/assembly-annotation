#!/usr/bin/env bash

# Purpose: Sets up control files for the MAKER annotation pipeline
# Creates a directory and links the necessary files for homology-based annotation

# Output:
# `maker_control_files/`: Directory containing control files for MAKER

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=maker_homology_based
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_maker_homology_based_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_maker_homology_based_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directories
DIR_CONTROL_FILES=/data/users/acastro/genome_assembly_annotation/analysis/maker_control_files

# Create directory
mkdir --parents $DIR_CONTROL_FILES

# Copy the control file (need to be edited for downstream processes)
ln -s /data/courses/assembly-annotation-course/CDS_annotation/example_MAKER_data/maker_opts_accession.ctl $DIR_CONTROL_FILES
ln -s /data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_pep_20110103_representative_gene_model $DIR_CONTROL_FILES
ln -s /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot_viridiplantae_reviewed.fa $DIR_CONTROL_FILES
ln -s /data/courses/assembly-annotation-course/CDS_annotation/data/PTREP20 $DIR_CONTROL_FILES
ln -s /data/courses/assembly-annotation-course/CDS_annotation/example_MAKER_data/maker_bopts.ctl $DIR_CONTROL_FILES
ln -s /data/courses/assembly-annotation-course/CDS_annotation/example_MAKER_data/maker_evm.ctl $DIR_CONTROL_FILES
ln -s /data/courses/assembly-annotation-course/CDS_annotation/example_MAKER_data/maker_exe.ctl $DIR_CONTROL_FILES

# Alternative to get the control files:
# Run MAKER with the specified control files directory using Apptainer.
apptainer exec \
    --bind $DIR_CONTROL_FILES \
    /data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif \
    maker -CTL
