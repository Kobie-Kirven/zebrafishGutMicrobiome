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
path_raw_n = '/media/researchlab/Elements/zebrafish_reads/normal/'
path_raw_exp = '/media/researchlab/Elements/zebrafish_reads/experimental/'

normal = ['n2','n3','n4']
experimental = ['e1','e3','e4','e5']

#Path to filtered reads
path_filtered = '/home/researchlab/Desktop/hostFilteredReads/'

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


raw_counts = []
for noSam in normal:
	raw_counts.append(getSeqNum(path_raw_n + noSam + "/filtered/"))
for noExp in experimental:
	raw_counts.append(getSeqNum(path_raw_n + noExp + "/filtered/"))


#Read in the filtered sequences
filtered_counts = getSeqNum(path_filtered)


#output the filtering statistics
with open('filtering_stats.csv','w') as fn:
	fn.write("Raw Sequences\tcounts\n")
	for count in raw_counts:
		for key, value in count.items():
			fn.write(key + '\t' + str(value) + '\n')

	fn.write("\tFiltered Sequences\tcounts\n")
	for key, value in filtered_counts.items():
		fn.write("\t\t" + key + '\t' + str(value) + '\n')
