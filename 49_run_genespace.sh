#!/usr/bin/env bash

# Purpose: runs the GENESPACE for synteny and gene family analysis

# Tool:
# - GENESPACE 

# Inputs:
# - `DIR_GENESPACE`: Directory containing the GENESPACE data
# - `DIR_R_SCRIPT`: Directory containing the R scripts `48_genespace.R`
# - `COURSEDIR`: Path to the course directory that contains the necessary containers and tools for execution

# Outputs:
# - GENESPACE analysis results stored in the `DIR_GENESPACE` directory, including synteny and gene duplication data

###############################################################################

#SBATCH --cpus-per-task=4
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --job-name=run_genespace
#SBATCH --mail-user=ana.castromarquez@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/acastro/genome_assembly_annotation/log/output_prepare_run_genespace_%j.o
#SBATCH --error=/data/users/acastro/genome_assembly_annotation/log/error_prepare_run_genespace_%j.e

DIR_GENESPACE="/data/users/acastro/genome_assembly_annotation/analysis/final_maker/genespace"
DIR_R_SCRIPT="/data/users/acastro/genome_assembly_annotation/scripts"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

# Run GENESPACE
apptainer exec \
    --bind $DIR_GENESPACE \
    --bind $COURSEDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif Rscript \
    $DIR_R_SCRIPT/48_genespace.R $DIR_GENESPACE
