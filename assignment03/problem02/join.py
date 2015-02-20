import MapReduce
import sys

"""
Relational Join using the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

def mapper(record):
    orderid = record[1]
    #print orderid,values
    mr.emit_intermediate(orderid, record)

def reducer(key, values):
    order = list();
    for entry in values:
        entry = [s.encode('utf8') for s in entry]
        if entry[0] == "order":
            order = entry
        else:
            joined = order + entry
            #print key, joined
            mr.emit(joined)

if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
