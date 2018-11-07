![](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoibG51QU90bjlHekkzNlJkTHl1M3RWWi9MdVZ0YUE2TEhIMlVTUXNobzlyWEd4eklNVkk2NzJ6MS8zcy9tZCt4UVJXUU9FWTVZVlNIQlVZZVZjeEc2R1NvPSIsIml2UGFyYW1ldGVyU3BlYyI6IlhnZm9qa1lXaTEwVUloSksiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

# kops-cn项目介绍
本项目用于指导客户使用开源自动化部署工具Kops在AWS宁夏区域或北京区域搭建K8S集群。
本项目已经将K8S集群搭建过程中需要拉取的镜像或文件拉回国内，因此您无需任何翻墙设置。



# 特性
- [x] 集群创建过程中所需的docker镜像已存放在 **宁夏** 或 **北京** 区域的`Amazon ECR`中。
- [x] 集群创建过程中所需的二进制文件或配置文件已存放在 **北京** 区域的`Amazon S3`桶中 。
- [x] 简单快速的集群搭建和部署
- [x] 无需任何VPN代理或翻墙设置
- [x] 如有新的Docker镜像拉取需求，您可以创建Github push or pull request,您的request会触发**CodeBuild**(see [#1](https://github.com/nwcdlabs/kops-cn/issues/1)) 去拉取镜像并存放到AWS `cn-north-1` 的ECR中。查看： [镜像列表](https://github.com/nwcdlabs/kops-cn/blob/master/mirror/required-images.txt).

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
| **vpcid** | 选择将您的集群部署在哪个VPC中 | **vpc-xxxxxxxx** |
| **ssh_public_key** | 本地ssh公钥的存放路径 | **~/.ssh/id_rsa.pub** [default] |

4. 创建集群
```
// 如果客户端存在多个aws profile，需要将中国区域profile明确的export出来：
$ export AWS_PROFILE=bjs
$ source env.config
$ bash create-cluster.sh
```

5. 编辑集群
```
kops edit cluster $cluster_name
```
将 `spec.yml` 中内容贴到`spec` 下并保存退出。

![](https://user-images.githubusercontent.com/278432/47897276-084ff880-deac-11e8-92db-b2fdf10e10b4.png)

6. 更新集群
```
kops update cluster $cluster_name --yes
```

7. 完成


# 验证

集群的创建大概需要 3-5 分钟时间。之后，使用 `kops validate cluster` 来验证集群是否是 `ready`状态。

![](./images/01.png)



查看集群对外接口信息、版本信息

![](./images/02.png)



恭喜您已顺利完成!

# 插件安装
* Helm  - https://github.com/nwcdlabs/kops-cn/blob/master/doc/Helm.md
* Istio - https://github.com/nwcdlabs/kops-cn/blob/master/doc/Istio.md


# FAQ

## 集群验证失败?
查看 issue [#5](https://github.com/nwcdlabs/kops-cn/issues/5)

## 如何SSH上master节点和worker节点 ?
查看 issue [#6](https://github.com/nwcdlabs/kops-cn/issues/6)


## 我需要的docker镜像在ECR中不存在.
托管在aws北京区域ECR中的镜像仓库`containerRegistry` 中的镜像见[required-images.txt](https://github.com/nwcdlabs/kops-cn/blob/master/mirror/required-images.txt), 如您在集群创建过程中需要其他镜像, 请您编辑 [required-images.txt](https://github.com/nwcdlabs/kops-cn/blob/master/mirror/required-images.txt) ，这将会在您的GitHub账户中 fork 一个新的分支，之后您可以提交PR（pull request）. merge您的PR会触发`CodeBuild` 去拉取 `required-images.txt` 中定义的镜像回ECR库。 数分钟后，您可以看到  ![](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoibG51QU90bjlHekkzNlJkTHl1M3RWWi9MdVZ0YUE2TEhIMlVTUXNobzlyWEd4eklNVkk2NzJ6MS8zcy9tZCt4UVJXUU9FWTVZVlNIQlVZZVZjeEc2R1NvPSIsIml2UGFyYW1ldGVyU3BlYyI6IlhnZm9qa1lXaTEwVUloSksiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)图标状态变化。

### 查看所有FAQs [这里](https://github.com/nwcdlabs/kops-cn/issues?utf8=%E2%9C%93&q=label%3AFAQ)
