import MapReduce
import sys

"""
Unique DNA trims using the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

def mapper(record):
    key = record[0].encode('utf8')
    seq = record[1].encode('utf8')[:-10]
    mr.emit_intermediate(key, seq)

def reducer(key, seqlist):
    for seq in seqlist:
        if seq not in mr.result:
            mr.emit(seq)

if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
