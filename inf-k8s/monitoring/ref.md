
# Monitoring

[k8s monitoring - concept, architecture](https://gruuuuu.github.io/cloud/monitoring-k8s1/)


- Installation

[doc](https://github.com/kubernetes-sigs/metrics-server)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

while true; do kubectl top node && sleep 3; done;
```

- Run

```bash
kubectl top node
kubectl top pod
```



