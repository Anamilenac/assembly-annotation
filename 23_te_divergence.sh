#!/usr/bin/env bash

# Purpose: Analyzes divergence of transposable elements (TEs).

# Tool:
# parseRM.pl
# BioPerl/1.7.8

# Input:
# `*.fasta.mod.out`: TE annotations.

# Output:
# - `assembly.fasta.mod.EDTA.anno/`:
#   - `*.fasta.mod.out.landscape.Div.Rclass.tab`: Summary classification of transposable elements (TEs) 
#   - `*.fasta.mod.out.landscape.Div.Rfam.tab`: Family classification of TEs
#   - `*.mod.out.landscape.Div.Rname.tab`: TEs identified 

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=te_divergence
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_te_divergence_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_te_divergence_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Define the directory for the EDTA output
DIR_EDTA=/data/users/$USER/genome_assembly_annotation/analysis/edtaEdi-0/flye
DIR_REPEATMASKER=$DIR_EDTA/assembly.fasta.mod.EDTA.anno

# Download parseRM.pl
wget -P $DIR_REPEATMASKER https://raw.githubusercontent.com/4ureliek/Parsing-RepeatMasker-Outputs/master/parseRM.pl

# Make parseRM.pl executable
chmod +x $DIR_REPEATMASKER/parseRM.pl

# Load the BioPerl module
module load BioPerl/1.7.8-GCCcore-10.3.0

# Run parseRM.pl to process RepeatMasker
perl $DIR_REPEATMASKER/parseRM.pl -i $DIR_REPEATMASKER/assembly.fasta.mod.out -l 50,1 -v
