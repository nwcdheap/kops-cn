# Installation


Install the latest `helm` CLI
```
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
```

## Create tiller ServiceAccount and ClusterRoleBinding

```
$ kubectl apply -f https://gist.githubusercontent.com/pahud/14e6cc08f3a7e65cd9b0e8bed454a901/raw/954d71614dda911c4f7960f0d18687fa1ea093fa/helm-sa-rolebinding.yaml
```



## Initialize the Helm

```
$ helm init --service-account tiller --upgrade
$HELM_HOME has been configured at /Users/hunhsieh/.helm.

Tiller (the Helm server-side component) has been upgraded to the current version.
Happy Helming!

```


However, if you describe the tiller pod you will notice it fails to pull image.


```
tiller-deploy-f9b8476d-hnnmm                                              0/1       ErrImagePull   0          21s
```

If you describe the pod you'll see the image is from `gcr.io/kubernetes-helm/tiller:v2.9.1`, which can not be pulled from China. 


We need to update the deployment and set another image from ECR

```
kubectl -n kube-system set image deploy/tiller-deploy tiller=937788672844.dkr.ecr.cn-north-1.amazonaws.com.cn/gcr.io-kubernetes-helm-tiller:v2.9.1
```

The deployment will be successful.
```
$ kubectl -n kube-system get deploy/tiller-deploy
NAME            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
tiller-deploy   1         1         1            1           23m
```

## Helm Samples

**helm search**
```
$ helm search mysql
NAME                            	CHART VERSION	APP VERSION	DESCRIPTION
stable/mysql                    	0.10.2       	5.7.14     	Fast, reliable, scalable, and easy to use open-...
stable/mysqldump                	1.0.0        	5.7.21     	A Helm chart to help backup MySQL databases usi...
stable/prometheus-mysql-exporter	0.2.1        	v0.11.0    	A Helm chart for prometheus mysql exporter with...
stable/percona                  	0.3.3        	5.7.17     	free, fully compatible, enhanced, open source d...
stable/percona-xtradb-cluster   	0.3.0        	5.7.19     	free, fully compatible, enhanced, open source d...
stable/phpmyadmin               	1.2.2        	4.8.3      	phpMyAdmin is an mysql administration frontend
stable/gcloud-sqlproxy          	0.5.0        	1.11       	Google Cloud SQL Proxy
stable/mariadb                  	5.2.2        	10.1.36    	Fast, reliable, scalable, and easy to use open-...                   	0.2.3        	0.28       	Sensu monitoring framework backed by the Redis ...
```

**helm install and delete**
```
$ helm install stable/mysql
```


```
$ helm ls
NAME          	REVISION	UPDATED                 	STATUS  	CHART       	NAMESPACE
plucking-manta	1       	Tue Oct 30 16:52:00 2018	DEPLOYED	mysql-0.10.2	default
$ helm del --purge plucking-manta
release "plucking-manta" deleted
$ helm status plucking-manta
LAST DEPLOYED: Tue Oct 30 16:52:00 2018
NAMESPACE: default
STATUS: DELETED
```

## Reference

Helm Quickstart Guide - https://docs.helm.sh/using_helm/
