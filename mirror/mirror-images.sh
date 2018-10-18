#!/bin/bash

ECR_REGION='cn-northwest-1'
ECR_DN="937788672844.dkr.ecr.${ECR_REGION}.amazonaws.com.cn"
IMAGES_FILE_LIST='required-images.txt'


function create_ecr_repo() {
  echo "creating repo: $1"
  aws --profile=bjs --region ${ECR_REGION} ecr create-repository --repository-name $1
}

function ecr_login() {
  aws --profile=bjs ecr --region cn-northwest-1 get-login --no-include-email | sh
  aws --profile=bjs ecr --region cn-north-1 get-login --no-include-email | sh
  aws ecr get-login --region us-west-2 --registry-ids 602401143452 --no-include-email | sh
}

function pull_and_push(){
  origimg="$1"
  # strip off the prefix
  img=${origimg/gcr.io\/google_containers\//}
  img=${img/k8s.gcr.io\//}
  target_img="$ECR_DN/${img//\//-}"
  docker pull $origimg
  echo "tagging $origimg to $target_img"
  docker tag $origimg $target_img
  echo "pushing $target_img"
  docker push $target_img
  echo "clean up, deleting $origimg and $target_img"
  docker rmi $origimg $target_img
}


# #repos=$(cat mirror-images.txt | cut -d: -f1 | sed -e 's#/#-#g')
# repos=$(cat mirror-images.txt | cut -d: -f1)
# for r in ${repos[@]}
# do
#   # r=${r/\//-}
#   echo $r
#   # strip off the prefix
#   r=${r/gcr.io\/google_containers\//}
#   r=${r/k8s.gcr.io\//}
#   r=${r/\//-}
#   echo $r
#   create_ecr_repo $r
# done

# exit 0

# ecr login for the once
ecr_login


images=$(cat $IMAGES_FILE_LIST)
# echo ${images//\//-}
for i in ${images[@]}
do
  pull_and_push $i
done


