#!/usr/bin/env bash

# Purpose: Annotates MAKER's output with functional data from the Uniprot
# database, mapping relevant protein functions to the genome annotation

# Tool:
# Maker_v3.01.03

# Inputs:
# - `uniprot_viridiplantae_reviewed.fa`: UniProt FASTA file for Viridiplantae
# - `blastp_output.txt`: BLAST results matching MAKER proteins to UniProt sequences
# - `proteins.filtered.fasta`: MAKER-produced predicted proteins
# - `*.filtered.gff`: MAKER-produced GFF3 file with gene models

# Outputs:
# `map_uniprot/`:
# - `maker_proteins.fasta.Uniprot`: Annotated protein FASTA with UniProt function data
# - `filtered.maker.gff3.Uniprot`: Annotated GFF3 file with UniProt function data for gene models

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=map_uniprot
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_map_uniprot_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_map_uniprot_%j.e

# Input and output directory
DIR_MAKER_FINAL="/data/users/$USER/genome_assembly_annotation/analysis/final_maker"
DIR_MAP_PROTEIN=$DIR_MAKER_FINAL/map_uniprot
DIR_UNIPROT="$DIR_MAKER_FINAL/uniprot"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

# Create output directories
mkdir --parents $DIR_MAP_PROTEIN

# Copy files into a new name
cp $DIR_MAKER_FINAL/proteins.filtered.fasta $DIR_MAP_PROTEIN/maker_proteins.fasta.Uniprot
cp $DIR_MAKER_FINAL/assembly.all.maker.noseq.gff.renamed.iprscan.filtered.gff $DIR_MAP_PROTEIN/filtered.maker.gff3.Uniprot

# Run maker_functional_fasta for protein mapping
$MAKERBIN/maker_functional_fasta \
    $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa \
    $DIR_UNIPROT/blastp_output.txt \
    $DIR_MAKER_FINAL/proteins.filtered.fasta \ 
>$DIR_MAP_PROTEIN/maker_proteins.fasta.Uniprot

# Run maker_functional_gff for GFF annotation
$MAKERBIN/maker_functional_gff \
    $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa \
    $DIR_UNIPROT/blastp_output.txt \
    $DIR_MAKER_FINAL/assembly.all.maker.noseq.gff.renamed.iprscan.filtered.gff \
    >$DIR_MAP_PROTEIN/filtered.maker.gff3.Uniprot
