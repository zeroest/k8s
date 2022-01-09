
# Service Account

[doc](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

```bash
kubectl get sa default -o yaml
```

- Pod에 spec.serviceAccountName: service-account-name과 같은 형식으로 지정

---

```bash
kubectl create sa sa1

kubectl get sa,secret

NAME                        SECRETS   AGE
serviceaccount/default      1         45d
serviceaccount/sa1          1         33s

NAME                            TYPE                                  DATA   AGE
secret/default-token-2tt4x      kubernetes.io/service-account-token   3      45d
secret/sa1-token-mc459          kubernetes.io/service-account-token   3      33s
```
- 포드에 별도의 service account 설정을 주지 않으면 default service account를 사용

---

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nx
spec:
  serviceAccountName: sa1
  containers:
  - image: nginx
    name: nx
EOF
```

```bash
kubectl get pod nx -o yaml

/var/run/secrets/kubernetes.io/serviceaccount
```
명시하지 않은 마운트가 존재하며 service account의 토큰이 마운트 되어 있는것을 확인 할 수 있다.

```bash
kubectl exec -it nx -- bash

cd /var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat token)
curl -X GET https://$KUBERNETES_SERVICE_HOST/api --header "Authorization: Bearer $TOKEN" -k
```
실제 해당 토큰을 통해 kubernetes 서버로 호출이 가능함을 확인 할 수 있다.

[API Reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/)

