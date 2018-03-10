#!/bin/sh

# merge all reads (not fragment) bed file
cat /home/wzhang/scATAC_test/GM12878/reads_output/*_shifted.bed > reads.bed

# delete chrM and chrY
python rm_chrM.py reads.bed reads_filtered.bed

# sort file
sortBed -i reads_filtered.bed > reads_filtered_sorted.bed

# delete tmp file
rm -f reads.bed
rm -f reads_filtered.bed

# call peaks
macs2 callpeak -t reads_filtered_sorted.bed -f BED -g hs -n output --nomodel --nolambda --keep-dup all --call-summits

# filter peaks in blacklist
Rscript peak_filter.R output_summits.bed consensusBlacklist.bed peaks_filtered.bed 0.2

# sort by score, extract top 50000 and sort
sort -k5rn,5 peaks_filtered.bed | head -n 50000 - | sort -k1,1 -k2n,2 - > top_peaks.bed



