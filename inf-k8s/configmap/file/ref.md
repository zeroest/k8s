
# from-file

[doc](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)

```bash
echo -n 1234 > test
```

```bash
kubectl create configmap map-name --from-file=test

kubectl create configmap map-name --from-file=test --dry-run=client -o yaml > configmap-file.yaml

kubectl apply -f configmap-file.yaml

kubectl get configmap map-name -o yaml
```

```bash
kubectl run --image gcr.io/google-samples/node-hello:1.0 envar-demo -o yaml --dry-run=client > envar-configmap.yaml

kubectl apply -f envar-configmap.yaml

kubectl exec -it envar-demo -- bash

printenv
```

