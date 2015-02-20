# encoding: utf-8
import sys
import json
from operator import itemgetter

def get_hashtags(jsonfile):
    for line in open(jsonfile, "rb"):
        entry = json.loads(line)
        # Skip entries without text content
        if "entities" in entry:
            hashtags = entry["entities"]["hashtags"]
            yield hashtags

def calc_freq(jsonfile):
    freq = dict()
    for hashtags in get_hashtags(jsonfile):
        for tag in hashtags:
            word = tag["text"].encode("utf-8")
            freq[word] = freq.get(word, 0.0) + 1.0
    return freq

def main():
    tfreq = calc_freq(sys.argv[1])
    tlist = sorted(tfreq.iteritems(), key=itemgetter(1), reverse=True)
    for item in tlist[0:10]:
        print item[0]+" "+str(item[1])

if __name__ == '__main__':
    main()
