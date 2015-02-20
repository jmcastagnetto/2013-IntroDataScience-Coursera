import MapReduce
import sys

"""
Matrix multiplication using the Simple Python MapReduce Framework
Algorithm taken from 'Mining of Massive Datasets' page 53
"""

mr = MapReduce.MapReduce()

def mapper(record):
    mat = record[0].encode('utf8')
    x = record[1]
    y = record[2]
    value = record[3]
    for w in range(5):
        if mat == "a":
            mr.emit_intermediate((x,w), (mat, y, value))
        else:
            mr.emit_intermediate((w,y), (mat, x, value))

def reducer(key, list_vals):
    (i,k) = key
    sum = 0
    a = dict()
    b = dict()
    for entry in list_vals:
        (mat, j, value) = entry
        if mat == "a":
            a[j] = value
        else:
            b[j] = value
    for j in range(5):
        sum = sum + a.get(j, 0) * b.get(j, 0)
    mr.emit((i,k,sum))

if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
