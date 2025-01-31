#!/usr/bin/env bash

# Purpose: Downloads orthologs for fragment and missing HOGs using OMArk.
# Runs MiniProt to map gene fragments and missing HOGs

# Tools:
# - OMArk-0.3.0
# - MiniProt

# Inputs:
# - `omamer.rename.fasta`: Maker's final annotated genome 
# - `assembly.fasta`: Flye assembly fasta file
# - `*_HOGs.fa`: Fragment and missing HOGs from OMArk output

# Outputs:
#   - `*_output.gff` : MiniProt output files in GFF format

###############################################################################

#SBATCH --cpus-per-task=4
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=refinement_hogs
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_refinement_hogs_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_refinement_hogs_%j.e

# Input and output directories
DIR_MAKER_FINAL="/data/users/$USER/genome_assembly_annotation/analysis/final_maker"
DIR_MAKER_OMARK="$DIR_MAKER_FINAL/omark"

CONTEXTUALIZE=/data/courses/assembly-annotation-course/CDS_annotation/softwares/OMArk-0.3.0/utils/omark_contextualize.py

# Initialize Conda for the current session
eval "$(/home/amaalouf/miniconda3/bin/conda shell.bash hook)"

# Activate the OMArk environment
conda activate OMArk

# OMArk software directory
OMArk="/data/courses/assembly-annotation-course/CDS_annotation/softwares/OMArk-0.3.0/"
pip install omadb

# Download the Orthologs for fragment HOGs
python $CONTEXTUALIZE fragment \
    -m $DIR_MAKER_OMARK/omamer.rename.fasta \
    -o $DIR_MAKER_OMARK/omark_output \
    -f $DIR_MAKER_OMARK/omark_output/fragment_HOGs

# Download the Orthologs for missing HOGs
python $CONTEXTUALIZE missing \
    -m $DIR_MAKER_OMARK/omamer.rename.fasta \
    -o $DIR_MAKER_OMARK/omark_output \
    -f $DIR_MAKER_OMARK/omark_output/missing_HOGs

###############################################################################

# Define directories for Flye assembly and MiniProt output
DIR_FLYE_EDI=/data/users/$USER/genome_assembly_annotation/analysis/flyeEdi-0/assembly.fasta
DIR_MINIPROT=$DIR_MAKER_OMARK/miniprot
REPOSITORY="/data/users/acastro/genome_assembly_annotation/scripts"

# create output directory
mkdir --parents "$DIR_MINIPROT"

# Download and compile miniprot
rm -rf miniprot
git clone https://github.com/lh3/miniprot
cd miniprot
make
cd ..

# Run miniprot for fragment HOGs
miniprot/miniprot -I --gff --outs=0.95 \
    $DIR_FLYE_EDI \
    $DIR_MAKER_OMARK/omark_output/fragment_HOGs > \
    $DIR_MINIPROT/miniprot_fragment_output.gff

# Run miniprot for missing HOGs
miniprot/miniprot -I --gff --outs=0.95 \
    $DIR_FLYE_EDI \
    $DIR_MAKER_OMARK/omark_output/missing_HOGs.fa > \
    $DIR_MINIPROT/miniprot_missing_output.gff
