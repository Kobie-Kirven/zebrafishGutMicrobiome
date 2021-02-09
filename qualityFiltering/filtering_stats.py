###########################################
# Assessing the number of reads that 
# were filtered out from the host-filtering
# step from bowtie2
###########################################

#imports
import os
from Bio import SeqIO
import gzip
from collections import defaultdict


#Path to raw reads
path_raw = '/Volumes/UUI/reads/'

#Path to filtered reads
path_filtered = '/Volumes/UUI/host_filtered/'

#Functions
def getSeqNum(path):
	'''Read in the sequence files and return
	   a dictionary:
	    - keys = file name
	    - values = number of sequences '''
	counts = defaultdict(int)
	for file in os.listdir(path):
		if file != 'hide':
			file_path = path + file
			sequences = 0
			for record in SeqIO.parse(gzip.open(file_path, 'rt', encoding='utf-8'),"fastq"):
				sequences += 1
			counts[file] = sequences
	return counts



#Read in the raw sequences
raw_counts = getSeqNum(path_raw)

#Read in the filtered sequences
filtered_counts = getSeqNum(path_filtered)


#output the filtering statistics
with open('filtering_stats.csv') as fn:
	fn.write("Raw Sequences\tcounts\n")
	for key, value in raw_counts.items():
		fn.write(key + '\t' + str(value) + '\n')

	fn.write("\t\tFiltered Sequences\tcounts\n")
	for key, value in filtered_counts.items():
		fn.write("\t\t" + key + '\t' + str(value) + '\n')

