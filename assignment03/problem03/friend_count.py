import MapReduce
import sys

"""
Friend count using the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

def mapper(record):
    key = record[0]
    mr.emit_intermediate(key, 1)

def reducer(key, values):
    mr.emit((key, sum(values)))

if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
