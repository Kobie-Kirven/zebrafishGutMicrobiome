#!/usr/bin/env bash


#Extract the fasta reads from the fastq files

sequenceList=("E1")

# mkdir samples

for i in ${sequenceList[@]}; do
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.1.fwd.bact.ribosomal.table --noali -o /dev/null 16s_bact_for3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R1.fasta
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.rev.bact.ribosomal.table --noali -o /dev/null 16s_bact_rev3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R1.fasta
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.1.fwd.arch.ribosomal.table --noali -o /dev/null 16s_arch_for3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R1.fasta
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.1.rev.arch.ribosomal.table --noali -o /dev/null 16s_arch_rev3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R1.fasta
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.2.fwd.bact.ribosomal.table --noali -o /dev/null 16s_bact_for3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R2.fasta
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.2.rev.bact.ribosomal.table --noali -o /dev/null 16s_bact_rev3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R2.fasta
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.2.fwd.arch.ribosomal.table --noali -o /dev/null 16s_arch_for3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R2.fasta
  /home/researchlab/Desktop/hmmer-3.0/src/hmmsearch -E 0.00001 --domtblout samples/${i}_.2.rev.arch.ribosomal.table --noali -o /dev/null 16s_arch_rev3.hmm /home/researchlab/Desktop/hostFilteredReads/${i}_host_removed_R2.fasta
done
