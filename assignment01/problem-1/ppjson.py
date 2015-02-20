import sys
import json

jsonf = open(sys.argv[1])
for line in jsonf:
    print json.dumps(json.loads(line.encode('utf-8')), sort_keys=True, indent=4, separators=(',',':'))
