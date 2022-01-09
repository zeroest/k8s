
# Static Token File

- Api Server 서비스를 실행할 때 --token-auth-file=SOMEFILE.csv 전달
- Api Server를 다시 시작해야 적용됨
- 토큰, 사용자 이름, 사용자 uid, 선택적으로 그룹 이름 다음에 최소 3열의 csv 파일


```csv
password1, user1, uid001, "group1,group2"
password2, user2, uid002
password3, user3, uid003
password4, user4, uid004
```
static-token.csv

```bash
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml
```
spec.containers.command 에 --token-auth-file 추가하여 반영


> 이때 host의 경로로 설정하는것이 아닌 kube-apiserver 도커 컨테이너로 마운트된 경로로 설정할것
kube-apiserver.yaml 에 hostPath와 volumeMounts를 참조하여 설정할것

```bash
mv static-token.csv /etc/kubernetes/pki/

#- --token-auth-file=/root/k8s/inf-k8s/account/static-token/static-token.csv
- --token-auth-file=/etc/kubernetes/pki/static-token.csv
```


---

## 사용방법

### http header

- http 요청을 진행할때 다음과 같은 내용을 헤더에 포함해야함
- Authorization: Bearer 31ada4fd-adec-460c-809a-9e56ceb75269

```bash
export TOKEN=31ada4fd-adec-460c-809a-9e56ceb75269
export APISERVER=https://127.0.0.1:6443

curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure
```

### config

```bash
kubectl config set-credentials user1 --token=$TOKEN
kubectl config set-context user1-context --cluster=kubernetes --namespace=frontend --user=user1
kubectl config use-context user1-context

# 다시 kubernetes admin 으로 전환
kubectl config use-context kubernetes-admin@kubernetes
```

