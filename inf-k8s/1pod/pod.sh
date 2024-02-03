
# crud
kubectl create -f .yaml
kubectl delete -f .yaml
kubectl delete pod ${pod_name}
kubectl delete pod --all
# kubectl delete all --all

kubectl get pod ${pod_name} -o yaml
kubectl get pod ${pod_name} -o wide
kubectl get pod ${pod_name} -w # 상태변화를 트래킹한다
kubectl describe pod ${pod_name}

# port forward
kubectl port-forward ${pod_name} 8888:8080

# run command in pod
kubectl exec ${pod_name} -- command

# util
kubectl logs ${pod_name}
# 필요한 어노테이션 추가가능
kubectl annotate pod ${pod_name} key=value

# docs
kubectl explain pods
