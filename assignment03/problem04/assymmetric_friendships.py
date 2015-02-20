import MapReduce
import sys

"""
Assymetric friendships using the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

def mapper(record):
    person = record[0].encode('utf8')
    friend = record[1].encode('utf8')
    mr.emit_intermediate(person, friend)

def reducer(key, values):
    person = key
    for friend in values:
        # check if we can find the person as friend in each friend's list
        friendslist = mr.intermediate.get(friend)
        if ( friend not in mr.intermediate ) or ( person not in mr.intermediate[friend] ):
            mr.emit((person, friend))
            mr.emit((friend, person))

if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
