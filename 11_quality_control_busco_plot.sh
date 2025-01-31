#!/usr/bin/env bash

# Purpose: Create summary plots for BUSCO results

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
#SBATCH --job-name=summary_busco
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_summarybusco_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_summarybusco_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory for BUSCO summary results
DIR_SUMMARY_BUSCO=/data/users/$USER/genome_assembly_annotation/analysis/short_summaries_busco

# Create output directories
mkdir --parents $DIR_SUMMARY_BUSCO

# Run the plotting script to generate BUSCO summary plots
apptainer exec /containers/apptainer/busco_5.7.1.sif python3 /usr/local/bin/generate_plot.py -wd $DIR_SUMMARY_BUSCO
