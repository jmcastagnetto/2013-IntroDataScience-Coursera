REGISTER s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar
-- load data
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader AS (line:chararray);
-- parse each line into ntriples
ntriples = FOREACH raw GENERATE FLATTEN(myudfs.RDFSplit3(line)) AS (subject:chararray,predicate:chararray,object:chararray) PARALLEL 30;
-- group by subject and do a count
by_subject = GROUP ntriples BY subject;
count_subject = FOREACH by_subject GENERATE COUNT(ntriples) PARALLEL 30;
-- group by count and generate histogram
by_count = GROUP count_subject BY $0 PARALLEL 30;
histogram = FOREACH by_count GENERATE group, COUNT(count_subject) PARALLEL 30;
-- store
STORE histogram INTO 's3n://jmcastagnetto-introdatasci/quiz-cloud/problem02b/histogram';
