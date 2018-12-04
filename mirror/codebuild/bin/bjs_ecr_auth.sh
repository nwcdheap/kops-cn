#!/bin/bash
env

# retrieve BJS credentials for ECR pusher


# we should be able to retrieve ak/sk from parameter-store defined in buildspec.yml
# echo $ak_kms_cipherblob | base64 -d > ak.blob
# ak=$(aws --region us-west-2 kms decrypt --ciphertext-blob fileb://ak.blob --output text --query Plaintext | base64 --decode)
# echo $sk_kms_cipherblob | base64 -d > sk.blob
# sk=$(aws --region us-west-2 kms decrypt --ciphertext-blob fileb://sk.blob --output text --query Plaintext | base64 --decode)
# rm -f ak.blob sk.blob
#echo $ak
#echo $sk
echo "foo=$foo"

aws configure --profile=bjs set aws_access_key_id $ak
aws configure --profile=bjs set aws_secret_access_key $sk
aws configure --profile=bjs set default.region cn-north-1


# $(AWS_ACCESS_KEY_ID=$ak AWS_SECRET_ACCESS_KEY=$sk aws --region=cn-north-1 ecr get-login)
