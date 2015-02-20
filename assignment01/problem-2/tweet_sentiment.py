import sys
import csv
import json

def affin_dict(fname):
    affinn = dict()
    with open(fname, 'rb') as csvinput:
        readcsv = csv.reader(csvinput, delimiter="\t", quoting=csv.QUOTE_NONE)
        for line in readcsv:
            affinn[line[0]] = float(line[1])
    return affinn

def get_text(jsonfile):
    for line in open(jsonfile, "rb"):
        entry = json.loads(line)
        # Skip entries without text content
        if "text" in entry:
            text = entry["text"].encode("utf-8")
            yield text

def main():
    affinn = affin_dict(sys.argv[1])
    affinkeys = affinn.keys()
    for text in get_text(sys.argv[2]):
        sentiment = 0.0
        if text:
            for akey in affinkeys:
                sentiment = sentiment + text.count(akey)*affinn[akey]
        print sentiment

if __name__ == '__main__':
    main()
