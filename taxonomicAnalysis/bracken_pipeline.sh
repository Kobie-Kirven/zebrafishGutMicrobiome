#!/usr/bin/env bash

sampleList=("N2" "N3" "N4" "E1" "E3" "E4" "E5")

for sample in ${sampleList[@]}; do
  python Bracken-master/src/est_abundance.py \
  -i kraken_classification/${sample}.kraken \
  -k ~/Desktop/kraken_databases/database150mers.kmer_distrib \
   -o bracken_outputs/${sample}.bracken
done
