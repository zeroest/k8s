
# AWS EBS volume

[doc](https://kubernetes.io/docs/concepts/storage/volumes/#awselasticblockstore)

```bash
aws ec2 create-volume --availability-zone=ap-northeast-2a --size=10 --volume-type=gp2
```
EBS 생성

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-ebs
spec:
  containers:
  - image: k8s.gcr.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-ebs
      name: test-volume
  volumes:
  - name: test-volume
    # This AWS EBS volume must already exist.
    awsElasticBlockStore:
      volumeID: "<volume id>"
      fsType: ext4
```
Configuration example


