
# NFS

[doc](https://kubernetes.io/docs/concepts/storage/volumes/#nfs)
[nfs sample](https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs)


```yaml
# https://github.com/kubernetes/examples/blob/master/staging/volumes/nfs/nfs-pv.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs
spec:
  capacity:
    storage: 1Mi
  accessModes:
    - ReadWriteMany
  nfs:
    server: nfs-server.default.svc.cluster.local
    path: "/"
  mountOptions:
    - nfsvers=4.2
```

