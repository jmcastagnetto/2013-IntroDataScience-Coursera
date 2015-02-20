REGISTER s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar
-- load data
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader AS (line:chararray);
-- parse each line into ntriples
ntriples = FOREACH raw GENERATE FLATTEN(myudfs.RDFSplit3(line)) AS (subject:chararray,predicate:chararray,object:chararray) PARALLEL 50;
tmp = FILTER ntriples BY subject MATCHES '.*rdfabout\\.com.*' PARALLEL 50;
set1 = ORDER tmp BY subject ASC PARALLEL 50;
set2 = FOREACH set1 GENERATE subject AS subject2, predicate AS predicate2, object AS object2 PARALLEL 50;
joined = JOIN set1 BY object, set2 BY subject2 PARALLEL 50;
nodups = DISTINCT joined PARALLEL 50;
STORE nodups INTO 's3n://jmcastagnetto-introdatasci/quiz-cloud/problem03/bigjoin';
