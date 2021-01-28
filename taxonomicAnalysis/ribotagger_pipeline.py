import os

perlPath = "perl /home/researchlab/Desktop/github/ribotagger/ribotagger/ribotagger.pl"
biomPath = "perl /home/researchlab/Desktop/github/ribotagger/ribotagger/biom.pl"
samplesPath = "/home/researchlab/Desktop/hostFilteredReads/"
forward = "_host_removed_R1.fastq.gz"
reverse = "_host_removed_R2.fastq.gz"


sampleList = [["E1", "E3", "E4", "E5"], ["N2", "N3", "N4"]]
expGroups = ["experimental","normal"]
for gp in expGroups:
    os.mkdir(gp)

for i in range(len(sampleList)):
    for sam in sampleList[i]:
        os.system(perlPath + " -r v4 -i "+ samplesPath + sam + forward + " " +
        samplesPath + sam + reverse + " -o " + expGroups[i] + "/" + sam + ".v4")

for exp in expGroups:
    os.system(biomPath + " -r v4 -i " + exp + "/*.v4 -o " + exp + "/" + exp)
