REGISTER s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file' USING TextLoader as (line:chararray);
-- raw = LOAD 'cse344-test-file.bz2' using TextLoader as (line:chararray);
-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);
by_subject = GROUP ntriples BY subject;
count_subject = FOREACH by_subject GENERATE COUNT(ntriples);
by_count = GROUP count_subject BY $0;
histogram = FOREACH by_count GENERATE group, COUNT(count_subject);
STORE histogram into 's3n://introdatsci/quiz-cloud/problem02/histogram';

