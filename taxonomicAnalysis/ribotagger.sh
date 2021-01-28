#!/usr/bin/env bash

# SEQPATH = "/home/researchlab/Desktop/hostFilteredReads"
# RIBOPATH = "/home/researchlab/Desktop/github/ribotagger/ribotagger"

# mkdir out

perl /home/researchlab/Desktop/github/ribotagger/ribotagger/ribotagger.pl -r v4 -i /home/researchlab/Desktop/hostFilteredReads/E1_host_removed_R1.fastq.gz  -o out/E1.v4
