# Istio installation with Helm and Tiller via helm 

## prepare Helm

follow the [Helm installation guide for China](https://github.com/pahud/kops-cn/blob/master/doc/Helm.md) to complete the Helm installation.

## checkout the Istio repo

```
$ git clone https://github.com/istio/istio.git
```

## create required CRD

```
$ kubectl apply -f install/kubernetes/helm/istio/templates/crds.yaml
```


Install `istio` by overriding the `global.hub` attribute in [values.yaml](https://github.com/istio/istio/blob/master/install/kubernetes/helm/istio/values.yaml)

```
$ cd istio
$ helm install install/kubernetes/helm/istio \
    --name istio \
    --namespace istio-system \
    --set grafana.enabled=true \
    --set global.hub=937788672844.dkr.ecr.cn-north-1.amazonaws.com.cn/gcr.io/istio-release    
```

check all pods in `istio-system` namespace, all pods should be `Running`
(This command may take up to 1 minute to complete. Please be patient.)

```
$ kubectl  -n istio-system get po
NAME                                     READY     STATUS    RESTARTS   AGE
grafana-98d47d7c7-rxsjv                  1/1       Running   0          26s
istio-citadel-768fb44b87-dv4c7           1/1       Running   0          25s
istio-egressgateway-64d686fb87-qv5sk     1/1       Running   0          26s
istio-galley-76b59bb6bf-xkqql            0/1       Running   0          26s
istio-ingressgateway-6fc44d584f-9kd57    1/1       Running   0          26s
istio-pilot-7f7795c79b-8sqzq             2/2       Running   0          26s
istio-policy-59bffc4dc5-r2lcx            2/2       Running   0          26s
istio-sidecar-injector-656696459-2frms   1/1       Running   0          25s
istio-telemetry-649885f6bd-96hp7         2/2       Running   0          26s
prometheus-7fcd5846db-wrd4k              1/1       Running   0          25s
```


## clean up and uninstall

```
$ helm del --purge istio
$ kubectl -n istio-system delete job --all
$ kubectl delete -f install/kubernetes/helm/istio/templates/crds.yaml -n istio-system
```
(please reference the [Istio official document](https://istio.io/docs/setup/kubernetes/helm-install/#uninstall) for clean up or uninstall)
