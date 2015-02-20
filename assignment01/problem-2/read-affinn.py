import csv

def affindict(fname):
    affin = {}
    with open(fname, 'rb') as csvinput:
        readcsv = csv.reader(csvinput, delimiter="\t", quoting=csv.QUOTE_NONE)
        for line in readcsv:
            affin[line[0]] = line[1]
    return affin

affin111 = affindict("AFINN-111.txt")
print affin111
