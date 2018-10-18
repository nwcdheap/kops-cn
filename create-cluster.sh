#!/bin/bash

source env.config

kops create cluster \
     --cloud=aws \
     --name=$cluster_name \
     --image=$ami \
     --zones=$zones \
     --master-count=$masterCount \
     --master-size=$masterSize \
     --node-count=$nodeCount \
     --node-size=$nodeSize  \
     --vpc=$vpcid \
     --kubernetes-version=$KUBERNETES_VERSION_URL \
     --ssh-public-key=$sshPublicKey
     
