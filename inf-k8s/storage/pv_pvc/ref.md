
# PV : Persistent Volume
# PVC : Persistent Volume Claim

[doc](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

- 애플리케이션을 배포하는 개발자가 스토리지 기술의 종류를 몰라도 상관없도록 스토리지를 추상화하여 제공
- 인프라 세부 사항을 알지 못해도 클러스터의 스토리지를 사용할 수 있도록 제공해주는 리소스
- pv를 통해 인프라 관리자가 스토리지를 추상화하여 제공
- pvc를 통해 개발자는 추상화된 스토리지를 사용만 함
- pvc는 네임스페이스에 속하지 않는다

## Reclaiming
- Retain : pvc 삭제시 pv 유지하고 볼륨만 해제
- Delete : 인프라와 연관된 스토리지 자산 모두 삭제
- Recycle : rm -rf /volume/* 볼륨에 대한 데이터를 모두 삭제하고 새로운 클레임에 재사용


```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```
pv

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
  storageClassName: slow
  selector:
    matchLabels:
      release: "stable"
    matchExpressions:
      - {key: environment, operator: In, values: [dev]}
```
pvc

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```
Claims As Volumes

