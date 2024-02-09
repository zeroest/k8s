
- alpine:3.4 이미지를 사용하여 deployment 생성
  - Replicas: 10
  - maxSurge: 50%
  - maxUnavailable: 50%

`kubectl create deploy --image alpine:3.4 alpine-deploy --dry-run=client -o yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: alpine-deploy
  name: alpine-deploy
spec:
  replicas: 10
  selector:
    matchLabels:
      app: alpine-deploy
  strategy: 
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 50%
  template:
    metadata:
      labels:
        app: alpine-deploy
    spec:
      containers:
        - image: alpine:3.4
          name: alpine
          resources: {}
```

```bash
kubectl apply -f alpine-deploy.yaml --record=true
```

- alpine:3.5 롤링 업데이트 수행

```bash
kubectl edit deploy alpine-deploy --record=true
```

```bash
kubectl rollout history deploy alpine-deploy

deployment.apps/alpine-deploy
REVISION  CHANGE-CAUSE
1         kubectl apply --filename=alpine-deploy.yaml --record=true
2         kubectl edit deploy alpine-deploy --record=true
```

```bash
kubectl get rs

NAME                       DESIRED   CURRENT   READY   AGE
alpine-deploy-54794686dc   3         3         0       3m46s
alpine-deploy-5c7ccdc674   10        10        0       2m1s
```

- alpine:3.4 롤백

```bash
kubectl rollout undo deploy alpine-deploy
or
kubectl rollout undo deploy alpine-deploy --to-revision=1
```

```bash
kubectl rollout history deploy alpine-deploy

deployment.apps/alpine-deploy
REVISION  CHANGE-CAUSE
2         kubectl edit deploy alpine-deploy --record=true
3         kubectl apply --filename=alpine-deploy.yaml --record=true
```

```bash
kubectl get rs

NAME                       DESIRED   CURRENT   READY   AGE
alpine-deploy-54794686dc   10        10        0       6m18s
alpine-deploy-5c7ccdc674   5         5         0       4m33s
```
