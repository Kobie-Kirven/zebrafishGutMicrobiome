#!/usr/bin/env bash

sampleList=("N2" "N3" "N4" "E1" "E3" "E4" "E5")

for sample in ${sampleList[@]}; do
  kraken2 --gzip-compressed --paired --db ~/Desktop/kraken_databases/ \
  ~/Desktop/hostFilteredReads/${sample}_host_removed_R1.fastq.gz \
  ~/Desktop/hostFilteredReads/${sample}_host_removed_R2.fastq.gz \
  --report kraken_classification/${sample}.kraken
done
