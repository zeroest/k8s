
# crud
kubectl create -f .yaml
kubectl delete -f .yaml
kubectl delete pod ${pod_name}

kubectl get pod ${pod_name} -o yaml
kubectl get pod ${pod_name} -o wide
kubectl describe pod ${pod_name} 

# port forward
kubectl port-forward ${pod_name} 8888:8080

# run command in pod
kubectl exec ${pod_name} -- command

# util
kubectl logs ${pod_name}
kubectl annotate pod ${pod_name} key=value


# docs
kubectl explain pods

