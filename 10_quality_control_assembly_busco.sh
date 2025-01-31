#!/usr/bin/env bash

# Purpose: Evaluate quality of genome assemblies using BUSCO.

# Tool:
# BUSCO v5.7.1

# Inputs:
# - `*.fasta`: Genome assembly file for Flye
# - `*.bp.p_ctg.fa`: Genome assembly file for Hifiasm
# - `*.fasta`: Genome assembly file for LJA
# - `*.Trinity.fasta`: Transcriptome assembly file for Trinity

# Outputs:
# - `busco_Edi-0/`:
#   - `buscoflye/`: BUSCO results for Flye assembly
#   - `buscohifiasm/`: BUSCO results for Hifiasm assembly
#   - `buscolja/`: BUSCO results for LJA assembly
# - `busco_RNA`:
#   - `buscotrinity/`: BUSCO results for Trinity assembly
# - `raw_data/busco_lineages/`: Downloaded BUSCO lineage data

###############################################################################

#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=busco
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_busco_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_busco_%j.e

# Go to working directory
cd /data/users/$USER/genome_assembly_annotation

# Imput directories for assemblies
DIR_FLYE_EDI=/data/users/$USER/genome_assembly_annotation/analysis/flyeEdi-0
DIR_HIFIASM_EDI=/data/users/$USER/genome_assembly_annotation/analysis/hifiasmEdi-0
DIR_LJA_EDI=/data/users/$USER/genome_assembly_annotation/analysis/ljaEdi-0
DIR_TRINITY_RNA=/data/users/$USER/genome_assembly_annotation/analysis/trinityRNA

# Output directory for BUSCO lineage database
DIR_BUSCO_DB=/data/users/$USER/genome_assembly_annotation/raw_data/busco_lineages

# Output directories for BUSCO results
DIR_BUSCO_EDI=/data/users/$USER/genome_assembly_annotation/analysis/busco_Edi-0
DIR_BUSCO_RNA=/data/users/$USER/genome_assembly_annotation/analysis/busco_RNA

# Create output directories
mkdir --parents $DIR_BUSCO_EDI/buscoflye
mkdir --parents $DIR_BUSCO_EDI/buscohifiasm
mkdir --parents $DIR_BUSCO_EDI/buscolja
mkdir --parents $DIR_BUSCO_RNA/buscotrinity
mkdir --parents $DIR_BUSCO_DB

# Download lineage dataset
wget -P $DIR_BUSCO_DB https://busco-data.ezlab.org/v5/data/lineages/brassicales_odb10.2024-01-08.tar.gz
tar -xvzf $DIR_BUSCO_DB/brassicales_odb10.2024-01-08.tar.gz -C $DIR_BUSCO_DB
wget -P $DIR_BUSCO_DB https://busco-data.ezlab.org/v5/data/file_versions.tsv

# Run BUSCO for Flye assembly
apptainer exec /containers/apptainer/busco_5.7.1.sif busco \
    --in $DIR_FLYE_EDI/assembly.fasta \
    --out_path $DIR_BUSCO_EDI/buscoflye \
    --mode genome \
    --lineage_dataset $DIR_BUSCO_DB/brassicales_odb10 \
    --cpu 16 \
    --download_base_url $DIR_BUSCO_DB/file_versions.tsv \
    --offline

# Run BUSCO for Hifiasm assembly
apptainer exec /containers/apptainer/busco_5.7.1.sif busco \
    --in $DIR_HIFIASM_EDI/hifiasm_output.bp.p_ctg.fa \
    --out_path $DIR_BUSCO_EDI/buscohifiasm \
    --mode genome \
    --lineage_dataset $DIR_BUSCO_DB/brassicales_odb10 \
    --cpu 16 \
    --download_base_url $DIR_BUSCO_DB/file_versions.tsv \
    --offline

# Run BUSCO for LJA assembly
apptainer exec /containers/apptainer/busco_5.7.1.sif busco \
    --in $DIR_LJA_EDI/assembly.fasta \
    --out_path $DIR_BUSCO_EDI/buscolja \
    --mode genome \
    --lineage_dataset $DIR_BUSCO_DB/brassicales_odb10 \
    --cpu 16 \
    --download_base_url $DIR_BUSCO_DB/file_versions.tsv \
    --offline

# Run BUSCO for Trinity assembly
apptainer exec /containers/apptainer/busco_5.7.1.sif busco \
    --in $DIR_TRINITY_RNA/trinityRNA.Trinity.fasta \
    --out_path $DIR_BUSCO_RNA/buscotrinity \
    --mode transcriptome \
    --lineage_dataset $DIR_BUSCO_DB/brassicales_odb10 \
    --cpu 16 \
    --download_base_url $DIR_BUSCO_DB/file_versions.tsv \
    --offline
