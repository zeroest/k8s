
# ArgoCD

https://argo-cd.readthedocs.io/en/stable/getting_started/

```
kubectl create namespace argocd
```

https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

위 install.yaml 파일에서 tolerations 를 적용

```
kubectl apply -f install.yaml -n argocd
```

```
kubectl get svc -n argocd

kubectl edit svc argocd-server -n argocd
type: LoadBalancer
```

편의상 LoadBalancer로 설정하여 접근하도록 한다. 

```
ID: admin
password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

---

# Argo Rollouts

https://argoproj.github.io/argo-rollouts/

```
kubectl create ns argo-rollouts
```

https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
동일하게 tolerations 적용

```
kubectl apply -f install.yaml -n argo-rollouts
```

## 데모 실행

Rollouts 관련 추가 plugin 설치 

```
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
kubectl argo rollouts version
```

```
mkdir argo-rollouts-demo
cd argo-rollouts-demo
curl -Lo basic-rollout-blue.yaml https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/basic/rollout.yaml
curl -Lo basic-service.yaml https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/basic/service.yaml

kubectl apply -f basic-rollout-blue.yaml
kubectl apply -f basic-service.yaml

kubectl edit svc rollouts-demo
```

```
kubectl argo rollouts get rollout rollouts-demo --watch
# 콘솔 모니터링

kubectl argo rollouts set image rollouts-demo rollouts-demo=argoproj/rollouts-demo:yellow
# 이미지변경 배포

kubectl argo rollouts promote rollouts-demo
# 배포 진행처리

kubectl argo rollouts pause rollouts-demo
# 배포 중단

kubectl argo rollouts undo rollouts-demo
# 롤백 처리 

kubectl-argo-rollouts --help
# 메뉴얼 확인 
```

```
kubectl apply -f basic-rollout-blue.yaml
kubectl apply -f basic-rollout-red.yaml

둘다 pause 조건을 수정하여 자동 promote를 수동으로 변경
```



