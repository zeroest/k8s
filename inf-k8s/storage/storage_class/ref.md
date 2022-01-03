
# Storage Classes

[doc](https://kubernetes.io/docs/concepts/storage/storage-classes/)

- PV를 직접 만드는 대신 사용자가 원하는 PV 유형을 선택하도록 오브젝트 정의 가능

```bash
kubectl get sc
```

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: slow
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1 # pd-ssd
  iopsPerGB: "10"
  fsType: ext4
```
AWS EBS


