#! /bin/bash

export AWS_CONFIG_FILE=/home/jmcastagnetto/.awsconfig

for f in $(seq -f "%05g" 0 49)
do
	s3f=part-r-$f
	key=quiz-cloud/problem03/bigjoin/$s3f
	aws s3 get-object --bucket jmcastagnetto-introdatasci --key $key $s3f
done

cat part* | sort > alldata.txt
