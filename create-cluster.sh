#!/bin/bash

source env.config

kubernetesVersion="https://s3.cn-north-1.amazonaws.com.cn/kubernetes-release/release/$KUBERNETES_VERSION"

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
     --kubernetes-version="$kubernetesVersion" \
     --ssh-public-key=$ssh_public_key
     
