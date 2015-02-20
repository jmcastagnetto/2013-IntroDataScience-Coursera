# encoding: utf-8
import sys
import csv
import json
import re
from operator import itemgetter

def affinn_dict(fname):
    affinn = {}
    with open(fname, 'rb') as csvinput:
        readcsv = csv.reader(csvinput, delimiter="\t", quoting=csv.QUOTE_NONE)
        for line in readcsv:
            affinn[line[0]] = float(line[1])
    return affinn

def get_text(jsonfile):
    for line in open(jsonfile, "rb"):
        entry = json.loads(line)
        # Skip entries without text content
        if "lang" in entry and entry["lang"] == "en" and "text" in entry:
            text = entry["text"].encode("utf-8")
            yield text

def main():
    affinn = affinn_dict(sys.argv[1])
    affinn_keys = affinn.keys()
    pos_terms = dict()
    neg_terms = dict()
    new_terms = []
    httpregex = re.compile("^http:.*$")
    for text in get_text(sys.argv[2]):
        sentiment = 0.0
        has_negative_terms = False
        has_positive_terms = False
        for akey in affinn_keys:
            if text.count(akey) > 0:
                sentiment = sentiment + text.count(akey)*affinn[akey]
                if not has_negative_terms:
                    has_negative_terms = (affinn[akey] < 0)
                if not has_positive_terms:
                    has_positive_terms = (affinn[akey] > 0)
        words = re.sub('[¦^}\]\[{`+&%$\\|=~*)(,;،!?"\']', ' ', text).lower().split()
        # avoid some urls, junk and stopwords, and cleanup the terms
        terms = [w.translate(None, ':.-_@#\/') for w in words 
                if (len(w.translate(None, ':.-_@#\/')) > 2 
                    and not httpregex.match(w))]
        tdiff = list(set(terms) - set(affinn_keys))
        for (tword, tcount) in [(t, terms.count(t)) for t in tdiff]:
            if has_positive_terms:
                pos_terms[tword] = pos_terms.get(tword,0.0) + float(tcount)
            if has_negative_terms:
                neg_terms[tword] = neg_terms.get(tword,0.0) + float(tcount)
            new_terms.append(tword)
    uniq_terms = [ut for ut in set(new_terms) if ut ]
    uniq_terms.sort()
    for nterm in uniq_terms:
        pos_count = pos_terms.get(nterm, 0.0)
        neg_count = neg_terms.get(nterm, 0.0)
        tot_count = pos_count + neg_count
        if tot_count > 0.0:
            if pos_count > neg_count:
                sign = 1.0
            else:
                sign = -1.0
            a = max(pos_count,neg_count)
            b = min(pos_count,neg_count)
            if a > 0.0 and b > 0.0:
                nterm_sentiment = sign * a / b
            else:
                nterm_sentiment = (pos_count - neg_count) / tot_count
        else:
            nterm_sentiment = 0.0
        print nterm + " " + "{:.1f}".format(nterm_sentiment)

if __name__ == '__main__':
    main()
