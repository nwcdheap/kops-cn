# kops-cn
This project is aimed to help you easily deploy the latest kops clusterin AWS China regions such as NingXia or Beijing region. You will leverage the local mirors of docker images or assets that help you accelerate the cluster creation without suffering the huge latency and connectivity issues from within China to other public sites like `gcr.io`.

# Features
- [x] All docker images required for kops creation are mirrored in `Amazon ECR` **NingXia** or **Beijing** region.
- [x] All binary files or assets required for the cluster creation can be fetched directly from `Amazon S3` **Beijing** region.
- [x] Fast cluster creation and simple deployment
- [x] No VPN or secure tunnel required

# HOWTO

1. checkout this repository to local
```
git clone https://github.com/pahud/kops-cn.git
```

2. follow the [installation guide](https://github.com/kubernetes/kops/blob/master/docs/install.md) to install the `kops` and `kubectl` binary on your laptop

3. edit `env.config`. You may need to change some of the variables as below


|        Name        |                    Description                     | values |
| :----------------: | :----------------------------------------------------------: | :------------------------: |
| **TARGET_REGION** | The region code to deploy the Kops cluster          |   **cn-north-1** or **cn-northwest-1**  |
| **vpcid** | The existing VPC ID to deploy the cluster | **vpc-xxxxxxxx** |
| **sshPublicKey** | SSH public key file path in the local | **~/.ssh/id_rsa.pub** [default] |

4. create the cluster
```
// if you need to specify different AWS_PROFILE
$ export AWS_PROFILE=bjs
$ source env.config
$ bash create_cluster.sh
```

5. edit the cluster
```
kops edit cluster $cluster_name
```
copy the content of `spec.yml` and insert into the editing window. Make sure the content is under `spec` then save and exit.

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