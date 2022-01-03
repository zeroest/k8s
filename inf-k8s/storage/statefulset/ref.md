
# Statefulset

[doc](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)
[statefulset - headless](https://bcho.tistory.com/1310)

- 스테이트풀셋으로 생성되는 포드는 영구 식별자를 가지고 상태를 유지시킬 수 있다.

## Use case

- 안정적이고 고유한 네트워크 식별자가 필요한 경우
- 안정적이고 지속적인 스토리지를 사용해야 하는 경우
- 질서 정연한 포드의 배치와 확장을 원하는 경우
- 포드의 자동 롤링업데이트를 사용하기 원하는 경우

## Problem

- 스테이트풀셋과 관련된 볼륨이 삭제되지 않음 (관리필요)
- 포드의 스토리지는 PV나 스토리지클래스로 프로비저닝 수행해야 함
- 롤링업데이트를 수행하는 경우 수동으로 복구해야 할 수 있음 (롤링업데이트 수행시 기존의 스토리지와 충돌로 인해 애플리케이션 오류가 발생할 수 있다.)
- 포드 네트워크 ID를 유지하기 위해 헤드레스(headless) 서비스 필요

### Headless service

- 기존의 서비스를 생성하는 방법으로 만드는데 clusterIP를 None으로 지정하여 생성
- 헤드레스 서비스 자체에는 IP가 할당되지 않지만 헤드레스 서비스의 도메인 네임을 사용해 각 포드에 접근할 수 있다.
- 기존의 서비스와 달리 kube-proxy가 벨런싱이나 프록시 형태로 동작하지 않는다.


```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

---

```bash
kubectl run -it --image busybox dns-test --restart=Never --rm /bin/sh

nslookup nginx.default.svc
nslookup web-0.nginx.default.svc
nslookup web-1.nginx
```
