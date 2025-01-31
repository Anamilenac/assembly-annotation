#!/usr/bin/env bash

# Purpose: Refine the annotation by running InterProScan to annotate protein sequences with functional domains

# Tool: 
# InterProScan v5.70-102.0 

# Input:
#   - `assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.fasta`: Renamed Protein FASTA file

# Output:
# - `final_maker/`
#   - `output.iprscan`: InterProScan results

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=run_interProScan
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_out_run_interProScan_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_out_run_interProScan_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directory containing MAKER output
DIR_MAKER=/data/users/$USER/genome_assembly_annotation/assembly.maker.output

# Final directory to store results after processing
DIR_MAKER_FINAL=/data/users/$USER/genome_assembly_annotation/analysis/final_maker

# Path to the MAKER binary tools
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

# Protein sequences file
protein="assembly.all.maker.fasta.all.maker.proteins.fasta"

# Running InterProScan
apptainer exec \
  --bind "$COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data" \
  --bind "$DIR_MAKER_FINAL" \
  --bind "$COURSEDIR" \
  --bind "$SCRATCH:/temp" \
  "$COURSEDIR/containers/interproscan_latest.sif" \
  /opt/interproscan/interproscan.sh \
  -appl pfam --disable-precalc -f TSV \
  --goterms --iprlookup --seqtype p \
  -i "$DIR_MAKER_FINAL/${protein}.renamed.fasta" -o "$DIR_MAKER_FINAL/output.iprscan"
