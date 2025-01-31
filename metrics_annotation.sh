mkdir metrics

# Purpose: Extract annotation statistics from MAKER outputs

DIR_MAKER="/data/users/acastro/genome_assembly_annotation/analysis/assembly.maker.output/assembly.all.maker.gff"
OUTPUT_FILE="metrics/gene_annotation_metrics.txt"

# Number of genes
echo "Number of genes:" >> $OUTPUT_FILE
grep -P "\tgene\t" $DIR_MAKER | wc -l >> $OUTPUT_FILE

# Number of mRNA
echo "Number of mRNA:" >> $OUTPUT_FILE
grep -P "\tmRNA\t" $DIR_MAKER | wc -l >> $OUTPUT_FILE

# Number of genes with functional annotation
echo "Number of genes with functional annotation:" >> $OUTPUT_FILE
grep -P "\tgene\t" $DIR_MAKER | awk '$9 ~ /GO|EC|description/' | wc -l >> $OUTPUT_FILE

# Gene lengths 
echo "Gene lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "gene" {print $5 - $4}' $DIR_MAKER | sort -n > gene_lengths.txt
echo "Max gene length: $(tail -n 1 gene_lengths.txt)" >> $OUTPUT_FILE
echo "Min gene length: $(head -n 1 gene_lengths.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median gene length: " a[(NR+1)/2]; else print "Median gene length: " (a[NR/2] + a[NR/2+1])/2}' gene_lengths.txt >> $OUTPUT_FILE

# mRNA lengths 
echo "mRNA lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "mRNA" {print $5 - $4}' $DIR_MAKER | sort -n > mrna_lengths.txt
echo "Max mRNA length: $(tail -n 1 mrna_lengths.txt)" >> $OUTPUT_FILE
echo "Min mRNA length: $(head -n 1 mrna_lengths.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median mRNA length: " a[(NR+1)/2]; else print "Median mRNA length: " (a[NR/2] + a[NR/2+1])/2}' mrna_lengths.txt >> $OUTPUT_FILE

# Exon lengths 
echo "Exon lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "exon" {print $5 - $4}' $DIR_MAKER | sort -n > exon_lengths.txt
echo "Max exon length: $(tail -n 1 exon_lengths.txt)" >> $OUTPUT_FILE
echo "Min exon length: $(head -n 1 exon_lengths.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median exon length: " a[(NR+1)/2]; else print "Median exon length: " (a[NR/2] + a[NR/2+1])/2}' exon_lengths.txt >> $OUTPUT_FILE

# Intron lengths 
echo "Intron lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "exon" {print $4, $5}' $DIR_MAKER | sort -n | awk 'NR > 1 {if ($1 > prev_end) print $1 - prev_end; prev_end = $2}' > intron_lengths.txt
echo "Max intron length: $(tail -n 1 intron_lengths.txt)" >> $OUTPUT_FILE
echo "Min intron length: $(head -n 1 intron_lengths.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median intron length: " a[(NR+1)/2]; else print "Median intron length: " (a[NR/2] + a[NR/2+1])/2}' intron_lengths.txt >> $OUTPUT_FILE

# Number of monoexonic genes
echo "Number of monoexonic genes:" >> $OUTPUT_FILE
awk '$3 == "gene" {gene_id = $9} $3 == "exon" {exon_count[gene_id]++} END {for (gene in exon_count) if (exon_count[gene] == 1) print gene}' $DIR_MAKER | wc -l >> $OUTPUT_FILE


###############################################################################

# Purpose: Extract annotation statistics from iprscan outputs

DIR_MAKER="/data/users/acastro/genome_assembly_annotation/analysis/final_maker/assembly.all.maker.noseq.gff.renamed.iprscan.filtered.gff"
OUTPUT_FILE="metrics/gene_annotation_metrics_iprscan.txt"

# Number of genes
echo "Number of genes:" >> $OUTPUT_FILE
grep -P "\tgene\t" $DIR_MAKER | wc -l >> $OUTPUT_FILE

# Number of mRNA
echo "Number of mRNA:" >> $OUTPUT_FILE
grep -P "\tmRNA\t" $DIR_MAKER | wc -l >> $OUTPUT_FILE

# Number of genes with functional annotation
echo "Number of genes with functional annotation:" >> $OUTPUT_FILE
grep -P "\tgene\t" $DIR_MAKER | awk '$9 ~ /GO|EC|description/' | wc -l >> $OUTPUT_FILE

# Gene lengths (max, min, median)
echo "Gene lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "gene" {print $5 - $4}' $DIR_MAKER | sort -n > gene_lengths_iprscan.txt
echo "Max gene length: $(tail -n 1 gene_lengths_iprscan.txt)" >> $OUTPUT_FILE
echo "Min gene length: $(head -n 1 gene_lengths_iprscan.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median gene length: " a[(NR+1)/2]; else print "Median gene length: " (a[NR/2] + a[NR/2+1])/2}' gene_lengths_iprscan.txt >> $OUTPUT_FILE

# mRNA lengths (max, min, median)
echo "mRNA lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "mRNA" {print $5 - $4}' $DIR_MAKER | sort -n > mrna_lengths_iprscan.txt
echo "Max mRNA length: $(tail -n 1 mrna_lengths_iprscan.txt)" >> $OUTPUT_FILE
echo "Min mRNA length: $(head -n 1 mrna_lengths_iprscan.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median mRNA length: " a[(NR+1)/2]; else print "Median mRNA length: " (a[NR/2] + a[NR/2+1])/2}' mrna_lengths_iprscan.txt >> $OUTPUT_FILE

# Exon lengths (max, min, median)
echo "Exon lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "exon" {print $5 - $4}' $DIR_MAKER | sort -n > exon_lengths_iprscan.txt
echo "Max exon length: $(tail -n 1 exon_lengths_iprscan.txt)" >> $OUTPUT_FILE
echo "Min exon length: $(head -n 1 exon_lengths_iprscan.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median exon length: " a[(NR+1)/2]; else print "Median exon length: " (a[NR/2] + a[NR/2+1])/2}' exon_lengths_iprscan.txt >> $OUTPUT_FILE

# Intron lengths (max, min, median)
echo "Intron lengths (max, min, median):" >> $OUTPUT_FILE
awk '$3 == "exon" {print $4, $5}' $DIR_MAKER | sort -n | awk 'NR > 1 {if ($1 > prev_end) print $1 - prev_end; prev_end = $2}' > intron_lengths_iprscan.txt
echo "Max intron length: $(tail -n 1 intron_lengths_iprscan.txt)" >> $OUTPUT_FILE
echo "Min intron length: $(head -n 1 intron_lengths_iprscan.txt)" >> $OUTPUT_FILE
awk '{a[NR] = $1} END {if (NR % 2 == 1) print "Median intron length: " a[(NR+1)/2]; else print "Median intron length: " (a[NR/2] + a[NR/2+1])/2}' intron_lengths_iprscan.txt >> $OUTPUT_FILE

# Number of monoexonic genes
echo "Number of monoexonic genes:" >> $OUTPUT_FILE
awk '$3 == "gene" {gene_id = $9} $3 == "exon" {exon_count[gene_id]++} END {for (gene in exon_count) if (exon_count[gene] == 1) print gene}' $DIR_MAKER | wc -l >> $OUTPUT_FILE

grep "Ontology_term=" $DIR_MAKER | \
  grep -oP 'ID=[^;]+' | \
  sort | \
  uniq -c  >> $OUTPUT_FILE

###############################################################################

# Purpose: Extract statistics from BLASTP outputs 

BLAST_OUTPUT="/data/users/acastro/genome_assembly_annotation/analysis/final_maker/uniprot/blastp_output.txt"
OUTPUT_FILE="metrics/gene_annotation_metrics_blast_longest.txt"

# Number of proteins with significant BLASTP hits (e-value < 1e-10)
echo "Number of proteins with significant BLASTP hits (e-value < 1e-10):" >> $OUTPUT_FILE
awk '$11 < 1e-10' $BLAST_OUTPUT | cut -f1 | sort | uniq | wc -l >> $OUTPUT_FILE

# Average Identity Percentage of Top Hits
echo "Average identity percentage of top BLASTP hits:" >> $OUTPUT_FILE
awk '{sum+=$3} END {print sum/NR}' $BLAST_OUTPUT >> $OUTPUT_FILE

# Average Bit Score of Top Hits
echo "Average bit score of top BLASTP hits:" >> $OUTPUT_FILE
awk '{sum+=$12} END {print sum/NR}' $BLAST_OUTPUT >> $OUTPUT_FILE

# Unique Functional Hit Count
echo "Unique functional hit count from BLASTP:" >> $OUTPUT_FILE
cut -f2 $BLAST_OUTPUT | sort | uniq | wc -l >> $OUTPUT_FILE

###############################################################################

# Purpose: Extract statistics from Uniprot outputs 

DIR_MAKER="/data/users/acastro/genome_assembly_annotation/analysis/final_maker/map_uniprot/filtered.maker.gff3.Uniprot"
OUTPUT_FILE="metrics/go_terms.txt"

echo "Unique proteins with functional annotations (GO terms):" >> $OUTPUT_FILE
grep "Ontology_term=" "$DIR_MAKER" | cut -f9 | cut -d";" -f1 | sort -u | wc -l >> $OUTPUT_FILE

# find the most frequent one
grep "Ontology_term=" "$GFF_FILE" | sed -n 's/.*Ontology_term=\([^;]*\).*/\1/p' | tr ',' '\n' | sort | uniq -c | sort -nr | head -n 1 > >> $OUTPUT_FILE
echo "Most common GO term:" >> $OUTPUT_FILE
