#!/usr/bin/env bash

# Purpose: Assemble genome data using Hifiasm for Edi-0 with PacBio HiFi reads,
# converting the assembly output from GFA to FASTA format.

# Tool:
# Hifiasm v0.19.8

# Inputs:
# - `*.fastq.gz`: PacBio HiFi reads for Edi-0 from the `raw_data` directory

# Outputs:
# - `hifiasmEdi-0/`:
#    - `hifiasm_output.*`: Hifiasm assembly output files

###############################################################################

#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=hifiasm
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_hifiasm_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_hifiasm_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Input directory
DATA_DIR_EDI=/data/users/$USER/genome_assembly_annotation/raw_data/Edi-0

# output directory
DIR_HIFIASM_EDI=/data/users/$USER/genome_assembly_annotation/analysis/hifiasmEdi-0

# Create directories to save results
mkdir --parents $DIR_HIFIASM_EDI

# Run Hifiasm for Edi-0
apptainer exec \
  --bind $DIR_HIFIASM_EDI \
  /containers/apptainer/hifiasm_0.19.8.sif \
  hifiasm -o $DIR_HIFIASM_EDI/hifiasm_output -t 16 $DATA_DIR_EDI/ERR11437331.fastq.gz

# Convert GFA file to FASTA format
for gfa_file in "$DIR_HIFIASM_EDI"/*.gfa; do
  fasta_file="${gfa_file%.gfa}.fa"
  awk '/^S/{print ">"$2;print $3}' "$gfa_file" >"$fasta_file"
  echo "Converted $gfa_file to $fasta_file"
done
