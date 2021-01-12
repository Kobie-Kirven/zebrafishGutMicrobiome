#!/usr/bin/env bash

#outputs:
# batchBowtie.txt - The log file for the whole script
# a log file for each of the read pairs

#create a log file
log=batchBowtieLog.txt

#add the date to the log file
date >> batchBowtieLog.txt

#List containg the names of the different sequences
sequenceList=("N2" "N3" "N4" "E1" "E3" "E4" "E5")

for i in ${sequenceList[@]}; do

  #Add the date, time, and the reads that are currently being aligned to the log file
  echo $(date +'Time: %X') "Now Aligning: ${i}" >> batchBowtieLog.txt

  #unzip the reads
  gunzip reads/${i}_R*

  # Perform the Bowtie2 alignment
  bowtie2 -p 8 -x align/zebrafish -1 reads/${i}_R1_filtered.fastq -2 reads/${i}_R2_filtered.fastq --un-conc-gz filtered_sequences/${i}_host_removed > ${i}_host_removed.sam

  #Remove the sam file to save space
  rm ${i}_host_removed.sam

  #zip the reads back up
  gzip reads/${i}_R*


  #Re-name the files
  mv filtered_sequences/${i}_host_removed.1 filtered_sequences/${i}_host_removed_R1.fastq.gz
  mv filtered_sequences/${i}_host_removed.2 filtered_sequences/${i}_host_removed_R2.fastq.gz
  
  
done
