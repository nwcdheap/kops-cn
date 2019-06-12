#!/bin/bash
# set -x

ECR_REGION='cn-north-1'
ECR_DN="937788672844.dkr.ecr.${ECR_REGION}.amazonaws.com.cn"
IMAGES_FILE_LIST='required-images.txt'
NO_TRIM="gcr.io/istio-release/"



function create_ecr_repo() {
  if in_array "$1" "$all_ecr_repos"
  then
    echo "repo: $1 already exists"
  else
    echo "creating repo: $1"
    aws --profile=bjs --region ${ECR_REGION} ecr create-repository --repository-name "$1"    
    attach_policy "$1"
  fi
}

function attach_policy() {
  echo "attaching public-read policy on ECR repo: $1"
  aws --profile bjs --region $ECR_REGION ecr  set-repository-policy --policy-text file://policy.text --repository-name "$1"
}

function is_remote_image_exists(){
  # is_remote_image_exists repositoryName:Tag Digests
  fullrepo=${1#*/}
  repo=${fullrepo%%:*}
  tag=${fullrepo##*:}
  res=$(aws --profile bjs --region $ECR_REGION ecr describe-images --repository-name "$repo" \
--query "imageDetails[?(@.imageDigest=='$2')].contains(@.imageTags, '$tag') | [0]")

  if [ "$res" == "true" ]; then 
    return 0 
  else
    return 1
  fi
}

function get_local_image_digests(){
  x=$(docker image inspect --format='{{index .RepoDigests 0}}' "$1")
  echo ${x##*@}
  # docker images --digests --no-trunc -q "$1"
}

function need_trim() {
  s=$1
  for i in $NO_TRIM
  do 
    if [ "${s/$i/}" == "$s" ]; then
      continue
    else
      return 1
    fi
  done
  return 0
}

function in_array() {
    local list=$2
    local elem=$1  
    for i in ${list[@]}
    do
        if [ "$i" == "${elem}" ] ; then
            return 0
        fi
    done
    return 1    
}

function ecr_login() {
  aws --profile=bjs ecr --region cn-northwest-1 get-login --no-include-email | sh
  aws --profile=bjs ecr --region cn-north-1 get-login --no-include-email | sh
  aws ecr get-login --region us-west-2 --registry-ids 602401143452 894847497797 --no-include-email | sh
}

function pull_and_push(){
  origimg="$1"
  if need_trim $origimg; then
    echo "$origimg needs triming"
    # strip off the prefix
    img=${origimg/gcr.io\/google_containers\//}
    img=${img/k8s.gcr.io\//}
    target_img="$ECR_DN/${img//\//-}"
  else
    echo "$origimg does not need triming"
    target_img="$ECR_DN/$origimg"
  fi
    
  docker pull $origimg
  echo "tagging $origimg to $target_img"
  docker tag $origimg $target_img
  echo "getting the digests on $target_img..."
  digests=$(get_local_image_digests $target_img)
  echo "$digests"
  echo "checking if remote image exists"

  if is_remote_image_exists $target_img $digests;then 
    echo "[SKIP] image already exists, skip"
  else
    echo "[PUSH] remote image not exists or digests not match, pushing $target_img"
    docker push $target_img
  fi

  #echo "clean up, deleting $origimg and $target_img"
  #docker rmi $origimg $target_img
}


# list all existing repos
all_ecr_repos=$(aws --profile=bjs --region $ECR_REGION ecr describe-repositories --query 'repositories[*].repositoryName' --output text)
echo "$all_ecr_repos"
repos=$(grep -v ^# $IMAGES_FILE_LIST | cut -d: -f1 | sort -u)
for r in ${repos[@]}
do
  if need_trim $r; then
    # strip off the prefix
    r=${r/gcr.io\/google_containers\//}
    r=${r/k8s.gcr.io\//}
    r=${r//\//-}
  fi
  
  # echo $r
  #attach_policy $r
  create_ecr_repo $r
done

# exit 0

# ecr login for the once
ecr_login


images=$(grep -v ^# $IMAGES_FILE_LIST)
# echo ${images//\//-}
for i in ${images[@]}
do
  pull_and_push $i
done


