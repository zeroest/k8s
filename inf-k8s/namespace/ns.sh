
kubectl get ns

kubectl create ns ${namespace_name}

kubectl delete ns ${namespace_name}

kubectl create ns test-ns --dry-run=client -o yaml
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: test-ns
```


kubectl get pod -n ${namespace_name}
kubectl get pod --namespace ${namespace_name}
# 전체 네임스페이스를 대상으로 kubectl을 실행하는 방법
kubectl get pod --all-namespaces



vim ~/.kube/config
```yaml
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
    namespace: default # 여기에 default namespace를 설정한다.
```

