# Istio installation with Helm

## prepare Helm

follow the [Helm installation guide](Helm.md) to complete the Helm installation.


## install Istio with 'helm template' command

As we hosted and mirrored the Istio required [images](https://github.com/nwcdlabs/kops-cn/blob/18b89e88253904aa2f5a7dfa0b5c8584db83ab26/mirror/required-images.txt#L64-L83), we can simply run the `helm template` command to generate the template content and replace all the `gcr.io/istio-release` to `937788672844.dkr.ecr.cn-north-1.amazonaws.com.cn/gcr.io/istio-release` and force all the image pulling goes to our mirror.

```bash
# checkout the Istio repo
$ git clone https://github.com/istio/istio.git

# isntall from 'install/kubernetes/helm/istio-init'
$ helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system  | \
sed -e 's#gcr.io/istio-release#937788672844.dkr.ecr.cn-north-1.amazonaws.com.cn/gcr.io/istio-release#g' | \
kubectl apply -f -
# make sure all pods completed
$ kubectl get po -n istio-system
NAME                      READY   STATUS      RESTARTS   AGE
istio-init-crd-10-9cqpx   0/1     Completed   0          38s
istio-init-crd-11-l427g   0/1     Completed   0          38s
istio-init-crd-12-gcwgk   0/1     Completed   0          38s

# isntall from 'install/kubernetes/helm/istio'
$ helm template install/kubernetes/helm/istio --name istio --namespace istio-system | \
sed -e 's#gcr.io/istio-release#937788672844.dkr.ecr.cn-north-1.amazonaws.com.cn/gcr.io/istio-release#g' | \
kubectl apply -f -
# verify again
$ kubectl get po -n istio-system
NAME                                                    READY   STATUS      RESTARTS   AGE
istio-citadel-76f9bf955f-hx4pw                          1/1     Running     0          103s
istio-cleanup-secrets-master-latest-daily-d7kkf         0/1     Completed   0          104s
istio-galley-6b9d5bc9c7-4jxl5                           1/1     Running     0          104s
istio-ingressgateway-5dc97bb6bb-tc9tg                   1/1     Running     0          104s
istio-init-crd-10-9cqpx                                 0/1     Completed   0          4m44s
istio-init-crd-11-l427g                                 0/1     Completed   0          4m44s
istio-init-crd-12-gcwgk                                 0/1     Completed   0          4m44s
istio-pilot-6568bc49fd-mgnqd                            2/2     Running     0          103s
istio-policy-68b6b6657c-jflsb                           2/2     Running     2          104s
istio-security-post-install-master-latest-daily-jszfg   0/1     Completed   0          104s
istio-sidecar-injector-7b8c6d66fb-zl794                 1/1     Running     0          103s
istio-telemetry-6b8dc87c86-glqzb                        2/2     Running     3          104s
prometheus-5b48f5d49-fl5s5                              1/1     Running     0          103s
```

## clean up and uninstall

```bash
$ helm template install/kubernetes/helm/istio --name istio --namespace istio-system | kubectl delete -f -
$ helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | kubectl delete -f -
$ kubectl delete namespace istio-system
$ kubectl delete -f install/kubernetes/helm/istio-init/files
```
(please reference the [Istio official document](https://istio.io/docs/setup/kubernetes/helm-install/#uninstall) for clean up or uninstall)
