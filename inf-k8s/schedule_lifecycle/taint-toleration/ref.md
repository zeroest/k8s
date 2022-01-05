
# Taint Toleration

[doc](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)

```bash
kubectl get nodes -o json | jq '.items[].spec.taints'
```

```bash
kubectl taint nodes node1 key1=value1:NoSchedule
kubectl taint nodes node1 key1=value1:NoExecute
kubectl taint nodes node1 key1=value1:PreferNoSchedule
```
Add taint

```bash
kubectl taint nodes node1 key1=value1:NoSchedule-
```
Remove taint

---

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "example-key"
    operator: "Exists"
    effect: "NoSchedule"
```
```yaml
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoSchedule"
```
```yaml
tolerations:
- key: "key1"
  operator: "Exists"
  effect: "NoSchedule"
```

The default value for operator is Equal.
- the operator is Exists (in which case no value should be specified), or
- the operator is Equal and the values are equal.

Effect
- if there is at least one un-ignored taint with effect NoSchedule then Kubernetes will not schedule the pod onto that node
- if there is no un-ignored taint with effect NoSchedule but there is at least one un-ignored taint with effect PreferNoSchedule then Kubernetes will try to not schedule the pod onto the node
- if there is at least one un-ignored taint with effect NoExecute then the pod will be evicted from the node (if it is already running on the node), and will not be scheduled onto the node (if it is not yet running on the node).

