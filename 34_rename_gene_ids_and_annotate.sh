#!/usr/bin/env bash

# Purpose: Prepare files for the next steps:
# - Set up a final directory for filtered annotation files and copy relevant files to it
# - Assign clean and consistent IDs to gene models 

# Tool:
# - Maker_v3.01.03

# Inputs:
# - `assembly.all.maker.noseq.gff`: GFF file
# - `assembly.all.maker.fasta.all.maker.proteins.fasta`: Protein FASTA
# - `assembly.all.maker.fasta.all.maker.transcripts.fasta`: Transcript FASTA

# Output:
# - `final_maker`
#   - `assembly.all.maker.noseq.gff.renamed.gff`: Renamed GFF file
#   - `assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.fasta`: Renamed Protein FASTA file
#   - `assembly.all.maker.fasta.all.maker.transcripts.fasta.renamed.fasta`: Renamed Transcript FASTA file
#   - `id.map`: ID mapping file

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=rename_genes_ids
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_out_rename_genes_ids_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_out_rename_genes_ids_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directories for MAKER and Trinity RNA-Seq
DIR_MAKER=/data/users/$USER/genome_assembly_annotation/assembly.maker.output
DIR_MAKER_FINAL=/data/users/$USER/genome_assembly_annotation/analysis/final_maker

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

# Accesion EDI-0
prefix="edi"

# Create a directory to store the final filtered annotations
mkdir --parents $DIR_MAKER_FINAL

# File names:
protein="assembly.all.maker.fasta.all.maker.proteins.fasta"
transcript="assembly.all.maker.fasta.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"

# Copy file to the final directory
cp "$DIR_MAKER/$gff" "$DIR_MAKER_FINAL/${gff}.renamed.gff"
cp "$DIR_MAKER/$protein" "$DIR_MAKER_FINAL/${protein}.renamed.fasta"
cp "$DIR_MAKER/$transcript" "$DIR_MAKER_FINAL/${transcript}.renamed.fasta"

# Navigate to the final directory
cd "$DIR_MAKER_FINAL" || exit

# Assign clean, consistent IDs to the gene models 
$MAKERBIN/maker_map_ids --prefix "$prefix" --justify 7 "${gff}.renamed.gff" >id.map
$MAKERBIN/map_gff_ids id.map "${gff}.renamed.gff"
$MAKERBIN/map_fasta_ids id.map "${protein}.renamed.fasta"
$MAKERBIN/map_fasta_ids id.map "${transcript}.renamed.fasta"