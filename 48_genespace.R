# Purpose: R script needed to run GENESPACE analysis 

# Tools:
# - GENESPACE
# - MCScanX

# Input:
# - `wd`: The working directory containing the input files for GENESPACE analysis

# Output:
# - `out`: Results of the GENESPACE analysis, including synteny and gene duplication data

###############################################################################

# Load the GENESPACE library
library(GENESPACE)

# Get the directory where the working files are located 
args <- commandArgs(trailingOnly = TRUE)
wd <- args[1]

# Initialize GENESPACE with the directory and path to MCScanX 
gpar <- init_genespace(wd = wd, path2mcscanx = "/data/courses/assembly-annotation-course/CDS_annotation/softwares/MCScanX")

# Run GENESPACE and output the results
out <- run_genespace(gpar, overwrite = TRUE)
