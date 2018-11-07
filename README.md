![](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoibG51QU90bjlHekkzNlJkTHl1M3RWWi9MdVZ0YUE2TEhIMlVTUXNobzlyWEd4eklNVkk2NzJ6MS8zcy9tZCt4UVJXUU9FWTVZVlNIQlVZZVZjeEc2R1NvPSIsIml2UGFyYW1ldGVyU3BlYyI6IlhnZm9qa1lXaTEwVUloSksiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

# kops-cn项目介绍
本项目用于指导客户使用开源自动化部署工具Kops在AWS宁夏区域或北京区域搭建K8S集群。
本项目已经将K8S集群搭建过程中需要拉取的镜像或文件拉回国内，因此您无需任何翻墙设置。



# 特性
- [x] 集群创建过程中所需的docker镜像已存放在 **宁夏** 或 **北京** 区域的`Amazon ECR`中。
- [x] 集群创建过程中所需的二进制文件或配置文件已存放在 **北京** 区域的`Amazon S3`桶中 。
- [x] 简单快速的集群搭建和部署
- [x] 无需任何VPN代理或翻墙设置
- [x] 如有新的Docker镜像拉取需求，您可以创建Github push or pull request,您的request会触发**CodeBuild**(see [#1](https://github.com/nwcdlabs/kops-cn/issues/1)) 去拉取镜像并存放到AWS `cn-north-1` 的ECR中。集群创建所需镜像列表： [list](https://github.com/nwcdlabs/kops-cn/blob/master/mirror/required-images.txt).

# 步骤

1. 下载项目到本地
```
$ curl  https://github.com/nwcdlabs/kops-cn/archive/master.zip -L -o kops-cn.zip
$ unzip kops-cn
$ cd kops-cn-master
```

2. 在本机安装`kops` and `kubectl`命令行客户端： [安装指导](https://github.com/kubernetes/kops/blob/master/docs/install.md)

您也可以直接从以下链接的AWS中国区域的S3桶中下载 `kops` and `kubectl` 的二进制文件：

```
//kops for linux
https://s3.cn-north-1.amazonaws.com.cn/kops-bjs/fileRepository/kops/1.10.0/linux/amd64/kops
//kops for mac os
https://s3.cn-north-1.amazonaws.com.cn/kops-bjs/fileRepository/kops/1.10.0/darwin/amd64/kops
//kubectl for linux
https://s3.cn-north-1.amazonaws.com.cn/kops-bjs/fileRepository/kubernetes-release/release/v1.10.6/bin/linux/amd64/kubectl
//kubectl for mac os
https://s3.cn-north-1.amazonaws.com.cn/kops-bjs/fileRepository/kubernetes-release/release/v1.10.6/bin/darwin/amd64/kubectl
```


3. 编辑 `env.config`文件. 您需要设置如下变量


|        Name        |                    Description                     | values |
| :----------------: | :----------------------------------------------------------: | :------------------------: |
| **TARGET_REGION** | 选择将集群部署在aws北京或宁夏区域          |   **cn-north-1** or **cn-northwest-1**  |
| **KOPS_STATE_STORE** | 您需要提供一个S3桶给KOPS存放配置信息 | s3://YOUR_S3_BUCKET_NANME |
| **vpcid** | 选择将您的部署在哪个VPC中 | **vpc-xxxxxxxx** |
| **ssh_public_key** | 本地ssh公钥的存放路径 | **~/.ssh/id_rsa.pub** [default] |

4. create the cluster
```
// if you need to specify different AWS_PROFILE
$ export AWS_PROFILE=bjs
$ source env.config
$ bash create-cluster.sh
```

5. edit the cluster
```
kops edit cluster $cluster_name
```
copy the content of `spec.yml` and insert into the editing window. Make sure the content is under `spec` then save and exit.

![](https://user-images.githubusercontent.com/278432/47897276-084ff880-deac-11e8-92db-b2fdf10e10b4.png)

6. upate the cluster
```
kops update cluster $cluster_name --yes
```

7. DONE


# Validate

It may take 3-5 minutes before you can `kops validate cluster` to validate it as `ready`

![](./images/01.png)



And check the `cluster-info` as well as the kubernetes client/server version

![](./images/02.png)



Have Fun!

# Extra Installation after cluster creation
* Helm Installation in AWS China - https://github.com/nwcdlabs/kops-cn/blob/master/doc/Helm.md
* Istio Installation in AWS China - https://github.com/nwcdlabs/kops-cn/blob/master/doc/Istio.md


# FAQ

## can't validate the cluster?
See issue [#5](https://github.com/nwcdlabs/kops-cn/issues/5)

## how to SSH into the master node or worker node?
See issue [#6](https://github.com/nwcdlabs/kops-cn/issues/6)


## Some docker images missing and can't be pulled from ECR. What can I do?
As this project configures `containerRegistry` to ECR in `cn-north-1` which only hosts docker images defined in [required-images.txt](https://github.com/nwcdlabs/kops-cn/blob/master/mirror/required-images.txt), if you find any required images not available during the cluster creation, please directly edit [required-images.txt](https://github.com/nwcdlabs/kops-cn/blob/master/mirror/required-images.txt) from github web UI and this will fork a new branch from your github account so you can submit a PR(pull request) to me. By merging the PR, the `CodeBuild` behind the scene will be triggered and images defined in `required-images.txt` will be mirrored to ECR in `cn-north-1` within a few minutes and you should be able to see this badge icon status change - ![](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoibG51QU90bjlHekkzNlJkTHl1M3RWWi9MdVZ0YUE2TEhIMlVTUXNobzlyWEd4eklNVkk2NzJ6MS8zcy9tZCt4UVJXUU9FWTVZVlNIQlVZZVZjeEc2R1NvPSIsIml2UGFyYW1ldGVyU3BlYyI6IlhnZm9qa1lXaTEwVUloSksiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

### check all FAQs [here](https://github.com/nwcdlabs/kops-cn/issues?utf8=%E2%9C%93&q=label%3AFAQ)
