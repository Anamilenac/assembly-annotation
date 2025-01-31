#!/usr/bin/env bash

# Purpose: Annotate transposable elements (TEs) in the genome assembly using EDTA

# Tool:
# EDTA_v1.9.6

# Inputs:
# -`*.fasta`: Genome assembly file for TE annotation
# - `TAIR10_cds_20110103_representative_gene_model_updated`: CDS file to mask coding regions

# Outputs:
# -`edtaEdi-0/`:
#   - *.mod.EDTA.TElib.fa: Non-redundant TE Library
#   - *.mod.EDTA.TEanno.gff3: Whole-genome TE annotation
#   - *.mod.EDTA.intact.gff3: Intact TE annotation
#   - *.mod.EDTA.TEanno.sum: Summary of whole-genome TE annotation
#   - *.mod.EDTA.anno/*.mod.out: RepeatMasker Output
#   - Additional files and directories

###############################################################################

#SBATCH --cpus-per-task=40
#SBATCH --time=3-00:00:00
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=EDTAEdi-0
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_EDTAEdi-0_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_EDTAEdi-0_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input genome assembly and cds file
DIR_FLYE_EDI=/data/users/$USER/genome_assembly_annotation/analysis/flyeEdi-0
CDS_FILE=/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated

# Output directory TE annotation results
DIR_EDTA=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0

# Create directory to save results
mkdir --parents $DIR_EDTA

# Mask coding regions and annotate TEs in the genome
apptainer exec -C -H $DIR_EDTA/flye \
  --writable-tmpfs /data/courses/assembly-annotation-course/containers2/EDTA_v1.9.6.sif \
  EDTA.pl \
  --genome $DIR_FLYE_EDI/assembly.fasta \
  --species others \
  --step all \
  --cds $CDS_FILE \
  --anno 1 \
  --threads 40
