###########################################
# This program will extract the fasta
# reads from a fastq file
#
# Author - Kobie Kirven
# Date: 1-25-2021
##########################################

#imports
from Bio import SeqIO
import gzip
import argparse

#Get the command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-i", help="Input file name")
parser.add_argument("-o", help="Output file name")
parser.add_argument("-z",help='Boolean of whether the file is zipped')
args = parser.parse_args()

try:
    fn = open(args.o, 'w')
except:
    print("Filename " + args.o + " can't be found")

for rec in SeqIO.parse(gzip.open(args.i, 'rt', encoding='utf-8'), "fastq"):
    fn.write('>' + str(rec.id) + '\n')
    fn.write(str(rec.seq) + '\n')
fn.close()
