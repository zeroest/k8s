
# Service Account

[doc](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

```bash
kubectl get sa default -o yaml
```

- Pod에 spec.serviceAccount: service-account-name과 같은 형식으로 지정

