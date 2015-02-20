import urllib
import json

searchurl = "http://search.twitter.com/search.json"
query = "?q=microsoft"
for i in range(0,10):
    jsonresp = urllib.urlopen(searchurl+query)
    resp = json.load(jsonresp)
    query = resp["next_page"]
    results = resp["results"]
    print "\n* Page: "+str(i+1)
    for entry in results:
        print "> "+entry["text"].encode("utf-8")
