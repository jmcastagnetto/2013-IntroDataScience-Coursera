#! /bin/bash

export AWS_CONFIG_FILE=/home/jesus/.awsconfig

for f in $(seq -f "%05g" 0 99)
do
	s3f=part-r-$f
	key=quiz-cloud/problem04/histogram/$s3f
	aws s3 get-object --bucket jmcastagnetto-introdatasci --key $key $s3f
done
