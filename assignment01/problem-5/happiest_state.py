import sys
import csv
import json
from operator import itemgetter

def affin_dict(fname):
    affin = dict()
    with open(fname, 'rb') as csvinput:
        readcsv = csv.reader(csvinput, delimiter="\t", quoting=csv.QUOTE_NONE)
        for line in readcsv:
            affin[line[0]] = float(line[1])
    return affin

def get_entries(jsonfile):
    for line in open(jsonfile, "rb"):
        tweet = json.loads(line)
        # Skip entries without text content and location and not in "en"
        #if "lang" in tweet and (tweet["lang"] == "en") and "text" in tweet:
        if "text" in tweet:
            text = tweet["text"].encode("utf-8")
            location = ""
            # if place is available, trust that
            if tweet["place"] and tweet["place"]["country_code"] == "US":
                location = tweet["place"]["full_name"].encode("utf-8")
            # otherwise use user location
            elif tweet["user"]["location"]:
                location = tweet["user"]["location"].encode("utf-8")
            else:
                location = None
            if location != None:
                entry = {"text":text, "location":location}
                yield entry

def main():
    states = {
        'AK': 'Alaska', 'AL': 'Alabama',
        'AR': 'Arkansas', 'AS': 'American Samoa',
        'AZ': 'Arizona', 'CA': 'California',
        'CO': 'Colorado', 'CT': 'Connecticut',
        'DC': 'District of Columbia', 'DE': 'Delaware',
        'FL': 'Florida', 'GA': 'Georgia',
        'GU': 'Guam', 'HI': 'Hawaii',
        'IA': 'Iowa', 'ID': 'Idaho',
        'IL': 'Illinois', 'IN': 'Indiana',
        'KS': 'Kansas', 'KY': 'Kentucky',
        'LA': 'Louisiana', 'MA': 'Massachusetts',
        'MD': 'Maryland', 'ME': 'Maine',
        'MI': 'Michigan', 'MN': 'Minnesota',
        'MO': 'Missouri', 'MP': 'Northern Mariana Islands',
        'MS': 'Mississippi', 'MT': 'Montana',
        'NA': 'National', 'NC': 'North Carolina',
        'ND': 'North Dakota', 'NE': 'Nebraska',
        'NH': 'New Hampshire', 'NJ': 'New Jersey',
        'NM': 'New Mexico', 'NV': 'Nevada',
        'NY': 'New York', 'OH': 'Ohio',
        'OK': 'Oklahoma', 'OR': 'Oregon',
        'PA': 'Pennsylvania', 'PR': 'Puerto Rico',
        'RI': 'Rhode Island', 'SC': 'South Carolina',
        'SD': 'South Dakota', 'TN': 'Tennessee',
        'TX': 'Texas', 'UT': 'Utah',
        'VA': 'Virginia', 'VI': 'Virgin Islands',
        'VT': 'Vermont', 'WA': 'Washington',
        'WI': 'Wisconsin', 'WV': 'West Virginia',
        'WY': 'Wyoming'
    }
    affinn = affin_dict(sys.argv[1])
    statesent = dict()
    for entry in get_entries(sys.argv[2]):
        text = entry["text"]
        location = entry["location"]
        sentiment = 0.0
        # estimate sentiment
        for akey in affinn.keys():
            sentiment = sentiment + text.count(akey)*affinn[akey]
        # extract state (if any) and add sentiment
        for k_st in states.keys():
            v_st = states[k_st]
            if location.count(k_st) > 0 or location.count(v_st) > 0:
                statesent[k_st] = statesent.get(k_st, 0.0) + sentiment
    # sort in ascending order by value
    tlist = sorted(statesent.iteritems(), key=itemgetter(1), reverse=False)
    # print top one
    (state,score) = tlist.pop()
    print state

if __name__ == '__main__':
    main()
