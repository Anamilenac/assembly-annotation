#!/usr/bin/env bash

# Purpose:
# Incorporate the InterProScan functional annotations into the GFF3 file
# Calculate AED (Annotation Edit Distance) values and filter the GFF3 file based on AED threshold (< 0.05)

# Tool:
# - ipr_update_gff
# - AED_cdf_generator.pl
# - quality_filter.pl

# Input:
# - `*.gff` : GFF file for annotation
# - `output.iprscan`: InterProScan output file with functional annotations 

# Output:
# - `final_maker/`:
#   - `*.renamed.iprscan.gff`: The GFF3 file with InterProScan annotations incorporated
#   - `assembly.all.maker.renamed.gff.AED.txt`: A file containing AED values for gene models
#   - `*.filtered.gff`: A filtered GFF3 file based on AED and quality thresholds

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=annotation_edit_distance
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_out_annotation_edit_distance_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_out_annotation_edit_distance_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# directory input and output
DIR_MAKER_FINAL=/data/users/$USER/genome_assembly_annotation/analysis/final_maker

# Software directory
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

# GFF file
gff="assembly.all.maker.noseq.gff"

# Incorporate the InterProScan functional annotations into the GFF3 file
$MAKERBIN/ipr_update_gff \
    $DIR_MAKER_FINAL/${gff}.renamed.gff \
    $DIR_MAKER_FINAL/output.iprscan \
    >$DIR_MAKER_FINAL/${gff}.renamed.iprscan.gff

# AED (Annotation Edit Distance) values
perl $MAKERBIN/AED_cdf_generator.pl \
    -b 0.025 \
    $DIR_MAKER_FINAL/${gff}.renamed.iprscan.gff \
    >$DIR_MAKER_FINAL/assembly.all.maker.renamed.gff.AED.txt

# Filter the GFF file for quality
perl $DIR_MAKER_FINAL/quality_filter.pl \
    -s $DIR_MAKER_FINAL/${gff}.renamed.iprscan.gff \
    >$DIR_MAKER_FINAL/${gff}.renamed.iprscan.filtered.gff
