#!/bin/sh

sessnum=$1

mkdir "fastqc_for_"$sessnum

fastqc $sessnum"_1.fastq" $sessnum"_2.fastq" -o "fastqc_for_"$sessnum

AdapterRemoval --identify-adapters --file1 $sessnum"_1.fastq" --file2 $sessnum"_2.fastq" > "adapters_ident_"$sessnum".txt"

python extract_adapter_using_AdapterRemoval.py "adapters_ident_"$sessnum".txt" "adapters_"$sessnum".txt"

AdapterRemoval --file1 $sessnum"_1.fastq" --file2 $sessnum"_2.fastq" --basename output --adapter-list "adapters_"$sessnum".txt"

bowtie2 -p 6 -X2000 --dovetail --no-mixed --no-discordant --no-unal -x /home/wzhang/genome/hg19_bowtie2/hg19 -q -1 output.pair1.truncated -q -2 output.pair2.truncated -S $sessnum"_mapping_result.sam" > $sessnum".obw2" 2>&1

samtools view -b -S $sessnum"_mapping_result.sam" | samtools sort - > $sessnum"_sorted.bam"

java -Xmx5g -jar /home/wzhang/software/Picard/picard.jar MarkDuplicates REMOVE_DUPLICATES=true INPUT=$sessnum"_sorted.bam" OUTPUT=$sessnum"_sorted_rmdup.bam" METRICS_FILE=picard_rmdup.txt

bedtools bamtobed -i $sessnum"_sorted_rmdup.bam" | awk 'BEGIN {OFS = "\t"} ; {if ($6 == "+") print $1, $2 + 4, $3 + 4, $4, $5, $6; else print $1, $2 - 5, $3 - 5, $4, $5, $6}' - > $sessnum"_shifted.bed"

python remove_chrM_and_merge.py $sessnum"_shifted.bed" $sessnum"_frag.bed"
