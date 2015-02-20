import json
import sys

def extract_text(jsons):
    entry = json.loads(jsons)
    if "text" in entry:
        return entry["text"]

def process_file(fname):
    tweetfile = open(fname, "rb")
    for line in tweetfile:
        text = extract_text(line)
        if text:
            print text

if __name__ == "__main__":
    process_file(sys.argv[1])
