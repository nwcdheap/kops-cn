#!/bin/bash
# set -x

ECR_REGION='cn-north-1'
ECR_DN="937788672844.dkr.ecr.${ECR_REGION}.amazonaws.com.cn"
IMAGES_FILE_LIST='required-images.txt'
NO_TRIM="gcr.io/istio-release/"

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



function get_ecr_repo_name(){
  origimg="$1"
  if need_trim $origimg; then
    #echo "$origimg needs triming"
    # strip off the prefix
    img=${origimg/gcr.io\/google_containers\//}
    img=${img/k8s.gcr.io\//}
    target_img="$ECR_DN/${img//\//-}"
  else
    #echo "$origimg does not need triming"
    target_img="$ECR_DN/$origimg"
  fi
  echo $target_img
}


images=$(grep -v ^# $IMAGES_FILE_LIST)
# echo ${images//\//-}
for i in ${images[@]}
do
  get_ecr_repo_name $i
done


exit 0


