#!/usr/bin/env bash

# Purpose: Output Preparation To merge the individual GFF files into a single GFF file
# and creates a merged FASTA file for genome annotation analysis

# Tools:
# - MAKER v
# - OpenMPI/4.1.1-GCC-10.3.0

# Inputs:
# - `assembly.maker.output`
#   - `assembly_master_datastore_index.log`: Log containing paths to individual GFF and FASTA files
#   - `gff3_merge`: Merges GFF files
#   - `fasta_merge`: Merges FASTA files

# Outputs:
# - `assembly.maker.output`
#   - `assembly.all.maker.gff`: Merged GFF file
#   - `assembly.all.maker.noseq.gff`: Merged GFF file without sequence information
#   - `assembly.all.maker.fasta`: Merged FASTA file
#   - Additional files

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=out_prepararion_maker
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_out_prepararion_maker_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_out_prepararion_maker_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Define directories for MAKER output and software
DIR_MAKER=/data/users/$USER/genome_assembly_annotation/assembly.maker.output
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

# Merge individual GFF files into a single GFF file
$MAKERBIN/gff3_merge \
    -s \
    -d $DIR_MAKER/assembly_master_datastore_index.log \
    >$DIR_MAKER/assembly.all.maker.gff

# Merge individual GFF files without sequence information
$MAKERBIN/gff3_merge \
    -n \
    -s \
    -d $DIR_MAKER/assembly_master_datastore_index.log \
    >$DIR_MAKER/assembly.all.maker.noseq.gff

# Merge FASTA files into a single file
$MAKERBIN/fasta_merge \
    -d $DIR_MAKER/assembly_master_datastore_index.log \
    -o $DIR_MAKER/assembly.all.maker.fasta
