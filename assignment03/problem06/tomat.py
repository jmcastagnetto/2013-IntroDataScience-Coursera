import sys
import json

input = open(sys.argv[1])
amat = open("amat.txt", "w")
bmat = open("bmat.txt", "w")
a = dict()
b = dict()
for line in input:
    (mat,i,j,val) = json.loads(line)
    if (mat == "a"):
        a[(i,j)] = val
    else:
        b[(i,j)] = val
for i in range(5):
    for j in range(5):
        value = a.get((i,j), 0)
        amat.write('{:4d}'.format(value))
        value = b.get((i,j), 0)
        bmat.write('{:4d}'.format(value))
    amat.write('\n')
    bmat.write('\n')
