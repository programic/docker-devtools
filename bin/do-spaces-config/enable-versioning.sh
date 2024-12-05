#!/usr/bin/env bash

: ${AWS_ACCESS_KEY_ID?"You need to set the AWS_ACCESS_KEY_ID environment variable."}
: ${AWS_SECRET_ACCESS_KEY?"You need to set the AWS_SECRET_ACCESS_KEY environment variable."}
: ${S3_BUCKET?"You need to set the S3_BUCKET environment variable."}

echo "Enable versioning"
aws s3api put-bucket-versioning --bucket ${S3_BUCKET} --versioning-configuration Status=Enabled
aws s3api get-bucket-versioning --bucket ${S3_BUCKET}

echo "Set bucket lifecycle configuration"
aws s3api put-bucket-lifecycle-configuration --bucket ${S3_BUCKET} --lifecycle-configuration file://lifecycle.json
aws s3api get-bucket-lifecycle-configuration --bucket ${S3_BUCKET}