#!/usr/bin/env bash

# Purpose: Create a list of isoforms for each gene, with isoforms separated by semicolons, 
# to be used as input for orthology analysis with OMArk.

# Input:
# - `*.proteins.fasta.renamed.fasta`: protein sequences FASTA

# Outputs:
# `omark/`:
# - `isoform_list.txt`: Text file listing isoforms for each gene

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=prepare_input_ortology
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_prepare_input_ortology_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_prepare_input_ortology_%j.e

# Input and output directories
DIR_MAKER_FINAL="/data/users/$USER/genome_assembly_annotation/analysis/final_maker"
DIR_MAKER_OMARK="$DIR_MAKER_FINAL/omark"

# Input and output file paths
input_file="$DIR_MAKER_FINAL/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.fasta"  
output_file="$DIR_MAKER_OMARK/isoform_list.txt"  

# Declare an associative array to hold isoforms for each gene
declare -A isoform_dict

# Read the input file line by line
while IFS= read -r line; do
  # Check if the line starts with '>'
  if echo "$line" | grep -q "^>"; then
    # Extract the gene ID (before -RA, -RB, etc.) and isoform identifier (e.g., -RA)
    gene_id=$(echo "$line" | sed -E 's/^>([^-]+).*/\1/')  # Extract everything before the first '-'
    isoform_id=$(echo "$line" | sed -E 's/^>([^-]+-[^ ]+).*/\1/')  # Extract gene_id-isoform_id part

    # Debug: Show extracted gene and isoform
    echo "Extracted gene: $gene_id, isoform: $isoform_id"

    # Add the isoform to the list for the gene, ensuring no duplicates for the isoforms of each gene
    if [[ -z "${isoform_dict[$gene_id]}" ]]; then
      isoform_dict["$gene_id"]="$isoform_id"
    else
      # Append isoform with semi-colon separator
      isoform_dict["$gene_id"]="${isoform_dict[$gene_id]};$isoform_id"
    fi
  fi
done < "$input_file"

# Write the formatted output to the output file
> "$output_file"  # Clear the output file if it exists
for gene in "${!isoform_dict[@]}"; do
  # Write each gene's isoforms on a single line
  echo "${isoform_dict[$gene]}" >> "$output_file"
done

echo "Output written to $output_file"
