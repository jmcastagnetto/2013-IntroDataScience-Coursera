register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
-- raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file' USING TextLoader as (line:chararray);
-- later you will load to other files, example:
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader as (line:chararray); 

g_raw = GROUP raw ALL;
c_raw = FOREACH g_raw GENERATE COUNT(raw);

-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);
g_ntriples = GROUP ntriples ALL;
c_ntriples = FOREACH g_ntriples GENERATE COUNT(ntriples);

--group the n-triples by object column
objects = group ntriples by (object) PARALLEL 50;
g_objects = GROUP objects ALL;
c_objects = FOREACH g_objects GENERATE COUNT(objects);

-- flatten the objects out (because group by produces a tuple of each object
-- in the first column, and we want each object ot be a string, not a tuple),
-- and count the number of tuples associated with each object
count_by_object = foreach objects generate flatten($0), COUNT($1) as count PARALLEL 50;

--order the resulting tuples by their count in descending order
count_by_object_ordered = order count_by_object by (count)  PARALLEL 50;
g_count_by_object = GROUP count_by_object ALL;
c_count_by_object = FOREACH g_count_by_object GENERATE COUNT(count_by_object);

-- store the results in the folder /user/hadoop/example-results
-- store count_by_object_ordered into '/user/hadoop/example-results' using PigStorage();
-- store c_count_by_object into 's3n://introdatsci/quiz-cloud/problem01/test';
-- Alternatively, you can store the results in S3, see instructions:
store c_raw into 's3n://introdatsci/quiz-cloud/problem01/count_raw';
store c_ntriples into 's3n://introdatsci/quiz-cloud/problem01/count_ntriples';
store c_objects into 's3n://introdatsci/quiz-cloud/problem01/count_objects';
store c_count_by_object into 's3n://introdatsci/quiz-cloud/problem01/count_by_object';
