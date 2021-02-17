#################################
# Split the lineage output
################################

with open("lineages.tsv") as fn:
	out = []
	lines = fn.readlines()
	splitLines = [line.strip('\n').split('\t') for line in lines]
	for sp in splitLines:
		spL = sp[1].split(";")
		out.append(spL)

with open("split_lineages.tsv",'w') as outFile:
	for rec in out:
		outFile.write('\t'.join(rec))
		outFile.write('\n')
