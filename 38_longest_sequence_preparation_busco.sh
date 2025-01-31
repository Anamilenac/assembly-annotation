#!/usr/bin/env bash

# Purpose: Prepare fasta files by retaining only the longest sequence for each gene
# to perform BUSCO on the MAKER-produced longest protein sequences.

# Inputs:
# - `*.fasta` : Protein FASTA file:
# - `*.fasta`: Transcript FASTA file

# Outputs:
# - `final_maker/`:
#   - `*.longest.fasta`: Protein FASTA file with the longest sequences
#   -`*.longest.fastat`: Transcript FASTA file with the longest sequences

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=longest_sequences
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_out_longest_sequences_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_out_longest_sequences_%j.e

# Output directory
DIR_MAKER_FINAL=/data/users/$USER/genome_assembly_annotation/analysis/final_maker

# Rename file to avoid conflicts when using awk for filtering
# Original names
protein_old="$DIR_MAKER_FINAL/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta"
transcript_old="$DIR_MAKER_FINAL/assembly.all.maker.fasta.all.maker.transcripts.fasta.renamed.filtered.fasta"

# New file names (shortened names)
protein_input="$DIR_MAKER_FINAL/proteins.filtered.fasta"
transcript_input="$DIR_MAKER_FINAL/transcripts.filtered.fasta"

# Rename the old files
mv "$protein_old" "$protein_input"
mv "$transcript_old" "$transcript_input"

# Define output file paths
protein_output="$DIR_MAKER_FINAL/proteins.longest.fasta"
transcript_output="$DIR_MAKER_FINAL/transcripts.longest.fasta"

# Function to extract longest isoform for each gene in a FASTA file
filter_longest_isoform() {
    input_file=$1
    output_file=$2

    declare -A longest_isoform
    header=""
    sequence=""

    while read -r line; do
        if echo "$line" | grep -q "^>"; then
            if [[ -n "$header" && -n "$sequence" ]]; then
                gene_id=$(echo "$header" | sed 's/^\(>\S*\)-[A-Z].*/\1/')
                current_length=${#sequence}

                if [[ -z "${longest_isoform[$gene_id]}" || ${longest_isoform[$gene_id]} -lt $current_length ]]; then
                    longest_isoform["$gene_id"]="$sequence"
                fi
            fi

            header=$line
            sequence=""
        else
            sequence+=$line
        fi
    done <"$input_file"

    if [[ -n "$header" && -n "$sequence" ]]; then
        gene_id=$(echo "$header" | sed 's/^\(>\S*\)-[A-Z].*/\1/')
        current_length=${#sequence}
        if [[ -z "${longest_isoform[$gene_id]}" || ${longest_isoform[$gene_id]} -lt $current_length ]]; then
            longest_isoform["$gene_id"]="$sequence"
        fi
    fi

    # filtered longest isoform sequences 
    for gene_id in "${!longest_isoform[@]}"; do
        echo ">${gene_id}" >>"$output_file"
        echo "${longest_isoform[$gene_id]}" >>"$output_file"
    done
}

filter_longest_isoform "$protein_input" "$protein_output"
filter_longest_isoform "$transcript_input" "$transcript_output"
