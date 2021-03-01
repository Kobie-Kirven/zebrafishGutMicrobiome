######################################################################
# Add the lineage information to the Kraken/Braken output file. 
#
#
# Author - Kobie Kirven
# Date: 2 - 17 - 2021
#
######################################################################

#Imports
import os, sys, argparse, subprocess


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i",
        "--input",
        dest="in_file",
        help="Input Kraken/Braken report file",
    )
    parser.add_argument(
        "-o",
        "--output",
        dest="out",
        help="Output file with lineages added",
    )
    parser.add_argument(
        "-db",
        "--database",
        dest="database",
        help="Path to NCBI Lineage database",
    )
    parser.add_argument(
        "-t", "--type", dest="type", help="Output type"
    )

    args = parser.parse_args()

    classLevels = ["k", "p", "c", "o", "f", "g", "s"]

    def extractNCBIids(fileName):
        with open(fileName) as fn:
            lines = fn.readlines()
            lines = [line.split("\t")[1] for line in lines]

        with open("ids.txt", "w") as fn:
            for line in lines[1:]:
                fn.write(line + "\n")
        return lines[1:]

    def getLineages():
        os.system(
            "taxonkit --data-dir "
            + str(args.database)
            + " lineage ids.txt > out.txt"
        )
        with open("out.txt") as fn:
            lines = fn.readlines()
            lineages = [
                line.strip("\n").split("\t")[1] for line in lines
            ]

        return lineages

        # Remove intermediate files
        os.system("rm out.txt")
        os.system("rm ids.txt")

    def outputWithLineage(lineages):
        with open(args.in_file) as fn:
            lines = fn.readlines()
            lines = [line.strip("\n").split("\t") for line in lines]

        with open(args.out, "w") as fn:
            fn.write("lineage\t" + "\t".join(lines[0][3:]) + "\n")
            lines = lines[1:]

            for i in range(len(lines)):
                inLineages = lineages[i].split(";")[1:8]
                lineList = ["r_Root"]

                for y in range(len(inLineages)):
                    inLineages[y] = "_".join(inLineages[y].split(" "))
                    lineList.append(
                        ";"
                        + classLevels[y]
                        + "_"
                        + inLineages[y].title()
                    )
                fn.write(
                    "".join(lineList)
                    + "\t"
                    + "\t".join(lines[i][3:])
                    + "\n"
                )

    def outputForOTU(lineages):
        with open(args.in_file) as fn:
            lines = fn.readlines()
            lines = [line.strip("\n").split("\t") for line in lines]

        with open(args.out, "w") as fn:
            fn.write(
                "Kingdom\tPyhlum\tClass\tOrder\tFamily\tGenus\tSpecies\t"
                + "\t".join(lines[0][3:])
                + "\n"
            )

            lines = lines[1:]
            for i in range(len(lines)):
                linList = lineages[i].split(";")
                if len(linList) < 8:
                    length = 8 - len(linList)

                    for t in range(length):
                        linList.append("N/A")
                linList = linList[1:8]

                fn.write(
                    "\t".join(linList)
                    + "\t"
                    + "\t".join(lines[i][3:])
                    + "\n"
                )

    ids = extractNCBIids(args.in_file)
    lineage = getLineages()

    if args.type == "l":
        outputWithLineage(lineage)

    elif args.type == "otu":
        outputForOTU(lineage)

    else:
        print("No output style specified: Default linear")
        outputWithLineage(lineage)

if __name__ == "__main__":
    main()
