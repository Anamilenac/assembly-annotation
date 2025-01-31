#!/usr/bin/env bash

# Purpose:
# Extract the list of remaining mRNA IDs from the filtered GFF3 file and
# create fasta file that only contain the sequences of high-quality gene models

# Tool:
# - UCSC-Utils/448-foss-2021a

# Inputs:
# - `*.filtered.gff`: The filtered GFF3 file
# - `${transcript}.renamed.fasta`: The input transcript FASTA file
# - `${protein}.renamed.fasta`: The input protein FASTA file

# Outputs:
# - `final_maker/`:
#   - `list.txt`: list of mRNA IDs from the GFF3 file, used to filter sequences
#   - `transcript.renamed.filtered.fasta`: The filtered transcript FASTA file
#      including mRNA sequences sequences with IDs in `list.txt`
#   - `protein.renamed.filtered.fasta`: The filtered protein FASTA file containing
#      only protein sequences corresponding to mRNA IDs listed in `list.txt`

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=create_fasta_high_quality
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_out_create_fasta_high_quality_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_out_create_fasta_high_quality_%j.e

# Output directory
DIR_MAKER_FINAL=/data/users/$USER/genome_assembly_annotation/analysis/final_maker

# file names
gff="assembly.all.maker.noseq.gff"
transcript="assembly.all.maker.fasta.all.maker.transcripts.fasta"
protein="assembly.all.maker.fasta.all.maker.proteins.fasta"

# load module
module load UCSC-Utils/448-foss-2021a
module load MariaDB/10.6.4-GCC-10.3.0

# Extract mRNA IDs from the GFF3 file
grep -P "\tmRNA\t" $DIR_MAKER_FINAL/$gff.renamed.iprscan.filtered.gff |
    awk '{print $9}' |
    cut -d ';' -f1 |
    sed 's/ID=//g' \
        >$DIR_MAKER_FINAL/list.txt

# Filter the transcript FASTA file based on the mRNA IDs
faSomeRecords \
    $DIR_MAKER_FINAL/${transcript}.renamed.fasta \
    $DIR_MAKER_FINAL/list.txt \
    $DIR_MAKER_FINAL/${transcript}.renamed.filtered.fasta

# Filters the protein FASTA file to only include sequences corresponding to the mRNA IDs
faSomeRecords \
    $DIR_MAKER_FINAL/${protein}.renamed.fasta \
    $DIR_MAKER_FINAL/list.txt \
    $DIR_MAKER_FINAL/${protein}.renamed.filtered.fasta
