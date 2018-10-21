#!/bin/bash

# retrieve BJS credentials for ECR pusher


echo $ak_kms_cipherblob | base64 -d > ak.blob

ak=$(aws --region us-west-2 kms decrypt --ciphertext-blob fileb://ak.blob --output text --query Plaintext | base64 --decode)


echo $sk_kms_cipherblob | base64 -d > sk.blob

sk=$(aws --region us-west-2 kms decrypt --ciphertext-blob fileb://sk.blob --output text --query Plaintext | base64 --decode)

rm -f ak.blob sk.blob

#echo $ak
#echo $sk

$(AWS_ACCESS_KEY_ID=$ak AWS_SECRET_ACCESS_KEY=$sk aws --region=cn-north-1 ecr get-login)
