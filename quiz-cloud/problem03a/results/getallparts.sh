#! /bin/bash

export AWS_CONFIG_FILE=/home/jmcastagnetto/.awsconfig

for f in $(seq -f "%05g" 0 9)
do
	s3f=part-r-$f
	key=quiz-cloud/problem03/smalljoin/$s3f
	aws s3 get-object --bucket jmcastagnetto-introdatasci --key $key $s3f
done
