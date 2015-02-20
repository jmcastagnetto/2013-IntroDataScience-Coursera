REGISTER s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar
-- load data
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file' USING TextLoader AS (line:chararray);
-- parse each line into ntriples
ntriples = FOREACH raw GENERATE FLATTEN(myudfs.RDFSplit3(line)) AS (subject:chararray,predicate:chararray,object:chararray) PARALLEL 10;
tmp = FILTER ntriples BY subject MATCHES '.*business.*' PARALLEL 10;
set1 = ORDER tmp BY subject ASC PARALLEL 10;
set2 = FOREACH set1 GENERATE subject AS subject2, predicate AS predicate2, object AS object2 PARALLEL 10;
joined = JOIN set1 BY subject, set2 BY subject2 PARALLEL 10;
nodups = DISTINCT joined PARALLEL 10;
STORE nodups INTO 's3n://jmcastagnetto-introdatasci/quiz-cloud/problem03/smalljoin';
