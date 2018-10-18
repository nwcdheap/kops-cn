#!/bin/bash

source env.config

kops create cluster \
     --cloud=aws \
     --name=$cluster_name \
     --image=$ami \
     --zones=$zones \
     --master-count=$master_count \
     --master-size=$master_size \
     --node-count=$node_count \
     --node-size=$node_size  \
     --vpc=$vpcid \
     --kubernetes-version=$KUBERNETES_VERSION_URL \
     --ssh-public-key=$ssh_public_key
     
