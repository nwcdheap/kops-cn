#!/bin/bash

KOPS_VERSION='1.10.0'
# K8s recommended version for Kops: https://github.com/kubernetes/kops/blob/master/channels/stable
K8S_RECOMMENDED_VERSION='1.10.6'

KUBERNETES_ASSETS=(
  release/v${K8S_RECOMMENDED_VERSION}/
  network-plugins/
)

mirror_kubernetes_release(){
    for asset in "${KUBERNETES_ASSETS[@]}"; do
        echo $asset
        if [ ! -d ./kubernetes-release/$asset ]; then
                mkdir -p ./kubernetes-release/$asset
        fi
        echo gsutil rsync -d -r gs://kubernetes-release/$asset ./kubernetes-release/$asset
        gsutil -m rsync -d -r gs://kubernetes-release/$asset ./kubernetes-release/$asset
    done
}

sync_release_to_s3(){
    aws --profile=bjs s3 sync ./kubernetes-release/ s3://kubernetes-release/ --acl public-read
}

mirror_kubeupv2(){
    TMPDIR="/tmp/kops/$KOPS_VERSION"
    for platform in linux darwin
    do
        if [[ ! -d $TMPDIR/$platform/amd64 ]]; then
        mkdir -p $TMPDIR/$platform/amd64
        fi
        if [[ ! -d $TMPDIR/images ]]; then
        mkdir -p $TMPDIR/images
        fi
    done


    for i in nodeup utils.tar.gz kops
    do
    for platform in linux darwin
    do
        wget -c https://kubeupv2.s3.amazonaws.com/kops/$KOPS_VERSION/$platform/amd64/$i -O $TMPDIR/$platform/amd64/$i
        wget -c https://kubeupv2.s3.amazonaws.com/kops/$KOPS_VERSION/$platform/amd64/$i.sha1 -O $TMPDIR/$platform/amd64/$i.sha1
    done
    done

    for platform in linux darwin
    do
    aws --profile bjs s3 sync $TMPDIR/$platform/amd64/ s3://kubeupv2/kops/$KOPS_VERSION/$platform/amd64/ --acl public-read
    done

    p=protokube.tar.gz
    wget -c https://kubeupv2.s3.amazonaws.com/kops/$KOPS_VERSION/images/$p -O $TMPDIR/images/$p
    wget -c https://kubeupv2.s3.amazonaws.com/kops/$KOPS_VERSION/images/$p.sha1 -O $TMPDIR/images/$p.sha1
    aws --profile bjs s3 sync $TMPDIR/images/ s3://kubeupv2/kops/$KOPS_VERSION/images/ --acl public-read
}



mirror_fileRepo(){
    aws --profile bjs s3 sync s3://kubernetes-release/ s3://kops-bjs/fileRepository/kubernetes-release/ --acl public-read
    aws --profile bjs s3 sync s3://kubeupv2/ s3://kops-bjs/fileRepository/kubeupv2/ --acl=public-read
    aws --profile bjs s3 sync s3://kubeupv2/kops/$KOPS_VERSION s3://kops-bjs/fileRepository/kops/$KOPS_VERSION --acl public-read 
}

mirror_kubernetes_release && \
sync_release_to_s3 && \
mirror_kubeupv2 && \
mirror_fileRepo
