#!/usr/bin/env bash

# Purpose: Quality assessment of gene annotations

# Tool:
# - BUSCO/5.4.2-foss-2021a

# Inputs:
# - `proteins.longest.fasta`: MAKER-produced longest protein sequences
# - `transcripts.longest.fasta`: MAKER-produced longest transcriptone sequences

# Outputs:
# - `busco_output_protein/`:
#   - `*.proteins.longest.fasta`: BUSCO output for protein
# - `busco_output_transcript/`:
#   - `*.transcripts.longest.fasta`: BUSCO output for transcriptome

###############################################################################

#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=annotation_busco
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_busco_annotation_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_busco_annotation_%j.e


# Input and Output Paths
DIR_MAKER_FINAL="/data/users/$USER/genome_assembly_annotation/analysis/final_maker"
DIR_BUSCO_MAKER="/data/users/$USER/genome_assembly_annotation/analysis/final_maker/busco"
DIR_BUSCO_PROTEIN="${DIR_BUSCO_MAKER}/busco_output_protein"
DIR_BUSCO_TRANSCRIPT="${DIR_BUSCO_MAKER}/busco_output_transcript"
PROTEIN="${DIR_MAKER_FINAL}/proteins.longest.fasta"
TRANSCRIPT="${DIR_MAKER_FINAL}/transcripts.longest.fasta"

# Create output directories
mkdir -p "$DIR_BUSCO_PROTEIN" "$DIR_BUSCO_TRANSCRIPT"

# Load BUSCO module
module load BUSCO/5.4.2-foss-2021a

# Run BUSCO on the MAKER-produced longest protein sequences
busco -i "$PROTEIN" -l brassicales_odb10 -o "$DIR_BUSCO_PROTEIN" -m proteins 

# Run BUSCO on the MAKER-produced longest transcriptome sequences
busco -i "$TRANSCRIPT" -l brassicales_odb10 -o "$DIR_BUSCO_TRANSCRIPT" -m transcriptome
