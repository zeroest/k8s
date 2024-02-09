
kubectl get ns

kubectl create ns ${namespace_name}

kubectl delete ns ${namespace_name}

kubectl create ns test-ns --dry-run=client -o yaml > test-ns.yaml
# ```yaml
# apiVersion: v1
# kind: Namespace
# metadata:
#   name: test-ns
# ```
kubectl create -f test-ns.yaml

kubectl create deploy nginx --image nginx -n test-ns

kubectl get pod -n ${namespace_name}
kubectl get pod --namespace ${namespace_name}
