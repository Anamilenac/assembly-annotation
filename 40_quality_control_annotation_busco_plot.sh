#!/usr/bin/env bash

### Purpose: Create summary plots for BUSCO results of gene annotation

# Tool:
# BUSCO v5.7.1

# Inputs:
# - `short_summaries_busco/: summary files from BUSCO runs
#   - `short_summary.*.json`
#   - `short_summary.*.txt`

# Outputs:
# - `short_summaries_busco/`
#    - *.png: plots summary report

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=annotation_summary_busco
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_annotation_summary_busco_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_annotation_summary_busco_%j.e

# Input directory for BUSCO summary results
DIR_MAKER_FINAL="/data/users/$USER/genome_assembly_annotation/analysis/final_maker"
DIR_SUMMARY_BUSCO=$DIR_MAKER_FINAL/short_summaries_busco

# Create output directories
# mkdir --parents $DIR_SUMMARY_BUSCO

# Run the plotting script to generate BUSCO summary plots
apptainer exec /containers/apptainer/busco_5.7.1.sif python3 /usr/local/bin/generate_plot.py -wd $DIR_SUMMARY_BUSCO
