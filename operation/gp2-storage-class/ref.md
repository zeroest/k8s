
# EKS default storage class

[doc](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/storage-classes.html)

## gp2 storage class 복구

EKS의 gp2(default) storage class 를 삭제했을때

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: gp2
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  fsType: ext4 
```
위의 yaml 파일을 만들고

```bash
kubectl create -f gp2-storage-class.yaml
```
적용시킨다.

```bash
kubectl get sc

NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
gp2 (default)   kubernetes.io/aws-ebs   Delete          Immediate           false                  7m1s
```
다시 storage class를 복구한것을 확인할 수 있다.

