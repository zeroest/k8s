
# Static Token File

- Api Server 서비스를 실행할 때 --token-auth-file=SOMEFILE.csv 전달
- Api Server를 다시 시작해야 적용됨
- 토큰, 사용자 이름, 사용자 uid, 선택적으로 그룹 이름 다음에 최소 3열의 csv 파일

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

kubectl get pod --user user1
```

