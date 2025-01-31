# Genome and Transcriptome Assembly and Annotation 

This repository contains the code for project Genome and Transcriptome Assembly and Annotation of *Arabidopsis thaliana* Accessions Edi-0 (Whole Genome PacBio HiFi) and Sha (Whole Transcriptome Illumina RNA-seq).

## Data
Two data sets were used to the genome and transcriptome assembly, PacBio HiFi reads from whole genome sequencing of *Arabidopsis thaliana* accession Edi-0, data from [Lian et al. 2024,](https://www.nature.com/articles/s41588-024-01715-9) and whole transcriptome Illumina RNA-seq data for accession Sha (RNAseq_Sha) identified as Read (_R1) and Read 2 (_R2), data from [Jiao et al. 2020](http://dx.doi.org/10.1038/s41467-020-14779-y).

## Directory Structure

The scripts are structured to organize and run the analysis in the following directory structure:

- **raw_data:**
  - Sequencing reads whole genome and transcriptome
  - The reference genome *Arabidopsis thaliana* TAIR10
  - Conserved single-copy genes for Brassicales from the OrthoDB v10 database

- **analysis:**
  - Outputs of the analysis from the tools implemented in the workflow

- **scripts:**
  - Scripts (numbered 01–50) required to be run in order for the analysis workflow. Each script describes its purpose, tools, inputs, and outputs

- **log:**
  - Output and error information from Slurm job submissions


### Genome and Transcriptome Assembly

Use scripts 01–15 to:

1) Assess sequencing data quality using FastQC and FASTP
2) Genome and transcriptome assembly using FLYE, HIFIASM, LJA and Trinity
3) Assess assembly quality and comparison of genomes using BUSCO, QUAST, MERQURY and MUMmmer 

### Annotate the genome by mapping the transcriptome assembly data to genome assembly 

Use scripts 16–50 to:

1) Annotation of transposable elements (TEs) using EDTA, TE divergence and phylogenetic tree analysis
2) Gene annotation with the MAKER pipeline 
3) Quality assessment of gene using BUSCO, OMArk (HOGs identification), and refinement with MiniProt 
4) Comparative genomics using GENESPACE

Additional annotation statistics are extracted using metrics_annotation.sh