# encoding: utf-8
import sys
import json
from operator import itemgetter

def get_text(jsonfile):
    for line in open(jsonfile, "rb"):
        entry = json.loads(line)
        # Skip entries without text content
        if "text" in entry:
            text = entry["text"].encode("utf-8")
            yield text

def calc_freq(jsonfile):
    freq = dict()
    tcount = 0.0
    for text in get_text(jsonfile):
        #words = text.translate(None, '_:/¦^}][{´+&%$\\|=~*)(“,;.-،!?"\'').lower().split()
        words = text.translate(None, '¨¦^}][{´+&%$\\|=~*)(“,;،!?"\'').lower().split()
        for word in words:
            if len(word) > 2:  # avoid some junk and stopwords
                freq[word] = freq.get(word, 0.0) + 1.0
                tcount = tcount + 1.0
    for k in freq.keys():
        c = freq[k]
        freq[k] = c / tcount
    return freq

def main():
    tfreq = calc_freq(sys.argv[1])
    tlist = sorted(tfreq.iteritems(), key=itemgetter(1), reverse=True)
    for item in tlist:
        print item[0]+" "+str(item[1])

if __name__ == '__main__':
    main()
