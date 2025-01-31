#!/usr/bin/env bash

# Purpose: Prepare a list of colors per clade to use in the tool iTOL that displays trees

# Inputs:
# - `*.fa.rexdb-plant.cls.tsv`: Transposable element (TE) sequences from Arabidopsis
#   and Brassicaceae

# Outputs:
# `superfamily_classification/`:
#   - `*.txt`: List of colors in separate files for Copia and Gypsy clades

###############################################################################

#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=prepare_tree_colors
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_prepare_tree_colors_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_prepare_tree_colors_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Directories and file paths for input
DIR_CLASSIFICATION=/data/users/acastro/genome_assembly_annotation/analysis/edtaEdi-0/flye/superfamily_classification
COPIA_FILE=$DIR_CLASSIFICATION/copia_sequences.fa.rexdb-plant.cls.tsv
GYPSY_FILE=$DIR_CLASSIFICATION/gypsy_sequences.fa.rexdb-plant.cls.tsv
COPIA_BRASSICACEAE_FILE=$DIR_CLASSIFICATION/copia_sequences_Brassicaceae.fa.rexdb-plant.cls.tsv
GYPSY_BRASSICACEAE_FILE=$DIR_CLASSIFICATION/gypsy_sequences_Brassicaceae.fa.rexdb-plant.cls.tsv

# Output files
COPIA_COLOR_FILE=$DIR_CLASSIFICATION/copia_list_colors.txt
GYPSY_COLOR_FILE=$DIR_CLASSIFICATION/gypsy_list_colors.txt
COPIA_BRASSICACEAE_COLOR_FILE=$DIR_CLASSIFICATION/copia_brassicaceae_list_colors.txt
GYPSY_BRASSICACEAE_COLOR_FILE=$DIR_CLASSIFICATION/gypsy_brassicaceae_list_colors.txt

# Store unique clade-color mappings
declare -A clade_colors
declare -A color_usage  

# Define a list colors 
color_palette=(
    "#FF5733"  
    "#7F00FF"  
    "#3357FF"  
    "#F3FF33"  
    "#FF33F3"  
    "#33FFF3"  
    "#FF8C00"  
    "#8B00FF"  
    "#008BFF"  
    "#BFFF00"  
    "#FF004F"  
    "#ff7300"  
    "#C71585"  
    "#FFD700"  
    "#00FF00"  
    "#DC143C"  
    "#FF1493"  
    "#20B2AA"  
    "#32CD32"  
    "#FF6347"  

color_index=0

assign_color_to_clade() {
    local clade=$1
    if [[ -z "${clade_colors[$clade]}" ]]; then
        local color=${color_palette[$color_index]}
        clade_colors[$clade]=$color

        ((color_usage[$color]++))
        
        if [[ ${color_usage[$color]} -gt 1 ]]; then
            echo "Color $color has been repeated for clade $clade"
        fi

        color_index=$((color_index + 1)) 
    fi
}

process_file_for_clades() {
    local input_file=$1
    local output_file=$2
    >"$output_file"

    while IFS=$'\t' read -r id _ _ clade _; do
        [[ "$id" == "ID" ]] && continue

        id=$(echo "$id" | sed 's/#.*//')

        assign_color_to_clade "$clade"

        if [[ -n "${clade_colors[$clade]}" ]]; then
            echo "$id ${clade_colors[$clade]} $clade" >>"$output_file"
        else
            echo "$id No_Color $clade" >>"$output_file"  
        fi
    done <"$input_file"
}

# Process each file and assign colors
process_file_for_clades "$COPIA_FILE" "$COPIA_COLOR_FILE"
process_file_for_clades "$GYPSY_FILE" "$GYPSY_COLOR_FILE"
process_file_for_clades "$COPIA_BRASSICACEAE_FILE" "$COPIA_BRASSICACEAE_COLOR_FILE"
process_file_for_clades "$GYPSY_BRASSICACEAE_FILE" "$GYPSY_BRASSICACEAE_COLOR_FILE"

# Concatenate color lists
cat "$COPIA_COLOR_FILE" "$COPIA_BRASSICACEAE_COLOR_FILE" >"$DIR_CLASSIFICATION/concatenated_copia_list_colors.txt"
cat "$GYPSY_COLOR_FILE" "$GYPSY_BRASSICACEAE_COLOR_FILE" >"$DIR_CLASSIFICATION/concatenated_gypsy_list_colors.txt"